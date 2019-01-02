# This is a sample script to look at how we can make Powershell code cleaner
# using Splatting to tidy up repetative code
#
# Our example will be to send three emails with slightly different content to
# different recipients. We will start off with simple one-liner, and progress
# through different ways of achieving the same result


# Example 1 - One-line
#
# The simplest form of a powershell command, packing everything into a single
# line. This works well, especially for short commands, but can make longer
# commands very difficult to read

Send-MailMessage -From "Script@contoso.local" -To "Bob@contoso.local" -Cc "Alerts@contoso.local" -Bcc "Postmaster@contoso.local" -Priority 'High' -SmtpServer "EXPRO01.contoso.local" -Subject "Test" -Body "<h1>I'm Bob's test email</h1><h2>" -BodyAsHtml
Send-MailMessage -From "Script@contoso.local" -To "Alice@contoso.local" -Cc "Alerts@contoso.local" -Bcc "Postmaster@contoso.local" -Priority 'High' -SmtpServer "EXPRO01.contoso.local" -Subject "Test" -Body "<h1>I'm Alice's test email</h1><h2>" -BodyAsHtml
Send-MailMessage -From "Script@contoso.local" -To "Charlie@contoso.local" -Cc "Alerts@contoso.local" -Bcc "Postmaster@contoso.local" -Priority 'High' -SmtpServer "EXPRO01.contoso.local" -Subject "Test" -Body "<h1>I'm Charlie's test email</h1><h2>" -BodyAsHtml


# Example 2 - Variables
#
# The simplest way to make this code easier to work with is to place common
# parameter values into variables, like the sender, some recipients, priority, 
# mail server, and subject. The main recipient (To), and message content
# change each time, so we have to enter them individually. BodyAsHtml is a
# single switch, so we can't make that any easier just yet.
#
# We shave about 10 characters off from Example 1, but it becomes easier to 
# make changes to one of the common variables.

$eFrom = "Script@contoso.local"
$eCc = "Alerts@contoso.local"
$eBcc = "Postmaster@contoso.local"
$ePriority = 'High'
$eServer = "EXPRO01.contoso.local"
$eSubject = "Test"

Send-MailMessage -From $eFrom -To "Bob@contoso.local" -Cc $eCc -Bcc $eBcc -Priority $ePriority -SmtpServer $eServer -Subject $eSubject -Body "<h1>I'm Bob's test email</h1><h2>" -BodyAsHtml
Send-MailMessage -From $eFrom -To "Alice@contoso.local" -Cc $eCc -Bcc $eBcc -Priority $ePriority -SmtpServer $eServer -Subject $eSubject -Body "<h1>I'm Alice's test email</h1><h2>" -BodyAsHtml
Send-MailMessage -From $eFrom -To "Charlie@contoso.local" -Cc $eCc -Bcc $eBcc -Priority $ePriority -SmtpServer $eServer -Subject $eSubject -Body "<h1>I'm Charlie's test email</h1><h2>" -BodyAsHtml


# Example 3 - Backticks
#
# Using a backtick (grave accent) allows Powershell to ignore the carriage
# return, enabling a command to span multiple lines. This makes the code easier
# to read by breaking it up. We can also still easy changes to common values 
# using variables
#
# Although this takes up many more lines, it is a lot easier to read, and the
# code has not changed aside from the backticks, and additional whitespace.

$eFrom = "Script@contoso.local"
$eCc = "Alerts@contoso.local"
$eBcc = "Postmaster@contoso.local"
$ePriority = 'High'
$eServer = "EXPRO01.contoso.local"
$eSubject = "Test"

Send-MailMessage `
    -From       $eFrom `
    -To         "Bob@contoso.local" `
    -Cc         $eCc `
    -Bcc        $eBcc `
    -Priority   $ePriority `
    -SmtpServer $eServer `
    -Subject    $eSubject `
    -Body       "<h1>I'm Bob's test email</h1><h2>" `
    -BodyAsHtml

Send-MailMessage `
    -From       $eFrom `
    -To         "Alice@contoso.local" `
    -Cc         $eCc `
    -Bcc        $eBcc `
    -Priority   $ePriority `
    -SmtpServer $eServer `
    -Subject    $eSubject `
    -Body       "<h1>I'm Alice's test email</h1><h2>" `
    -BodyAsHtml

Send-MailMessage `
    -From       $eFrom `
    -To         "Charlie@contoso.local" `
    -Cc         $eCc `
    -Bcc        $eBcc `
    -Priority   $ePriority `
    -SmtpServer $eServer `
    -Subject    $eSubject `
    -Body       "<h1>I'm Charlie's test email</h1><h2>" `
    -BodyAsHtml


# Example 4 - Splatting with Backticks
#
# While Example 3 was very readable, it takes up a lot of space. Splatting lets
# us compact these common variables into hashtable, and specify the hashtable 
# as the first positional parameter. Note we can also specify BodyAsHtml as a 
# boolean value here
#
# Here we compact our code from 39 lines down to just 24

$MailParams = @{
    From = "Script@contoso.local"
    Cc = "Alerts@contoso.local"
    Bcc = "Postmaster@contoso.local"
    Priority = 'High'
    Server = "EXPRO01.contoso.local"
    Subject = "Test"
    BodyAsHtml = $true
}

Send-MailMessage `
    @MailParams `
    -To         "Bob@contoso.local" `
    -Body       "<h1>I'm Bob's test email</h1><h2>"

Send-MailMessage `
    @MailParams `
    -To         "Alive@contoso.local" `
    -Body       "<h1>I'm Alice's test email</h1><h2>"

Send-MailMessage `
    @MailParams `
    -To         "Charlie@contoso.local" `
    -Body       "<h1>I'm Charlie's test email</h1><h2>"

# Example 5 - Splatting with one-liners
#
# Since our commands are a lot shorter, we now don't need to necessarily 
# separate each parameter onto it's own line for it to be readable, so we 
# compact it back down.
#
# If we had more commands using the same common complex sets of parameters, we 
# can see how this becomes very useful

$MailParams = @{
    From = "Script@contoso.local"
    Cc = "Alerts@contoso.local"
    Bcc = "Postmaster@contoso.local"
    Priority = 'High'
    Server = "EXPRO01.contoso.local"
    Subject = "Test"
    BodyAsHtml = $true
}

Send-MailMessage @MailParams -To "Bob@contoso.local" -Body "<h1>I'm Bob's test email</h1><h2>"
Send-MailMessage @MailParams -To "Alice@contoso.local" -Body "<h1>I'm Alice's test email</h1><h2>"
Send-MailMessage @MailParams -To "Charlie@contoso.local" -Body "<h1>I'm Charlie's test email</h1><h2>"
