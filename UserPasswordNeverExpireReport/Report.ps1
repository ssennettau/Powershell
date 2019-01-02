$EmailTo = "Sysadmins@contoso.local"
$ReportPath = "C:\PSReport\"
$OUs = @(
    "OU=Engineering,OU=NAT,OU=Departments,DC=contoso,DC=local"
    "OU=Marketing,OU=Departments,DC=contoso,DC=local"
    "OU=Sales,OU=Departments,DC=contoso,DC=local"
)

Import-Module ActiveDirectory

$ADParams = @{
    SearchScope = 'Subtree'
    Filter = '(PasswordNeverExpires -eq $true)'
    Properties = 'Title','Department','PasswordNeverExpires'
}

# Gather user details from relevant OU's
$Users = @()
Foreach ($OU in $OUs)
{
    $Users += Get-ADUser @ADParams -SearchB
}

# Exclude any users based on particular criteria
$Users = $Users | Where-Object -FilterScript { $_.Department -ne 'Executive' }
$Users = $Users | Where-Object -FilterScript { $_.SamAccountName -notlike 'Service*' }

# Exclude users based on a specific list 
$Users | Where-Object {$_.SamAccountName -inotin (Get-Content 'C:\temp\exclude.txt')} | Select Name,SamAccountName

# Basic header and format of the report
$content  = "<style>body { font-family:sans-serif } table { border-collapse: collapse } table, th, td { border: 1px solid black } td { font-size: 10pt }</style>"
$content += "<h1>Accounts with Password Never Expiring</h1>"
$content += "<h3>$(Get-Date -Format "F")</h3>"
$content += "<table>"
$content += "<tr><th>Name</th><th>UserPrincipalName</th><th>Title</th><th>Department</th></tr>"

# Get details on each account, and remove password never expiring
Foreach ($User in $Users)
{
    # Format the details of the user into the report
    $content += "<tr>"
    $content += "<td>$($User.Name)</td>"
    $content += "<td>$($User.UserPrincipalName)</td>"
    $content += "<td>$($User.Title)</td>"
    $content += "<td>$($User.Department)</td>"
    $content += "</tr>"

    # Disable the Password Never Expiring. Use with caution, as this can cause problems for service accounts that rely on these
    #Set-ADUser -Identity $User -PasswordNeverExpires $False
}

$content += "</table>"
$content += "<h6>Executed on $($env:computername)</h6>"

# Saves a copy of the report in a HTML file
$content | Out-File -FilePath "$ReportPath\passwordexpiry-$(Get-Date -Format "yyyyMMdd-hhmm").html"

# Sends the Report in an Email
Send-MailMessage `
    -From "TechReports@contoso.local" `
    -To $EmailTo `
    -SmtpServer "PROEX01.contoso.local" `
    -Subject "PasswordNeverExpires Review - $(Get-Date -F "ddd dd/MM/yyyy")" `
    -Body $content `
    -BodyAsHtml
