#Collect all mailbox info who have the smtpaddress with captial letter domain name

$a= Get-Mailbox -resultsize unlimited | ?{$_.Primarysmtpaddress -cmatch "@Advantagesolutions.net"}

$a | fl Name,Alias,Primarysmtpaddress,Emailaddresses,Emailaddresspolicyenabled >> c:\temp\alldetails_smtp.txt

#Adding AD module as it requires AD related cmdlets
Import-Module ActiveDirectory


#Foreach of that mailbox verify if the email address policy is set to true , then change it to false modify the smtp address the set back to true
#Else modify the emailaddress and set on the mailbox

foreach($mbx in $a)
{
   $pAddr=((get-ADUser $mbx.distinguishedName -Properties proxyaddresses).Proxyaddresses) | ? {$_ -cmatch "SMTP*"}
   $new1 = @()
   Set-ADUser $mbx.DistinguishedName -Remove @{"proxyaddresses"=$pAddr.toString()}
   $new1 = $pAddr.Replace("@Advantagesolutions.net","@advantagesolutions.net")   
   $new1
   Set-ADUser $mbx.Distinguishedname -Add @{"proxyaddresses"=$new1}
   Write-host "we have modiofied email address is $mbx.Alias"
}
{get-mailbox}
