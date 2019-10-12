function Test-Links
{
    <#
    .Synopsis
       Tests validity of links
    .DESCRIPTION
       Performs a test on each of the links in an array of strings, and returns a 
       "True" response for each that it can reach the Uri (follows redirects)
    .EXAMPLE
       Test-Links -Links "http://www.google.com/"

       Performs checks on the individual link
    .EXAMPLE
       $Check = @()
       $Check += "http://www.google.com/"
       $Check += "http://www.github.com/"
       Test-Links -Links $Check

       Performs checks on each of the links in the array
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Links
    )

    begin
    {
        $Results = @()
    }

    process
    {
        Foreach ($l in $Links)
        {
            # Fix Relative Links
            If ($l -notlike '*://*')
            {
                $l = $Uri + $l
            }
    
            $o = $true
            try
            {
                $Check = Invoke-WebRequest -Uri $l -UseBasicParsing
            }
            catch
            {
                $o = $false
            }

            $r = New-Object -TypeName PSObject
            Add-Member -InputObject $r -MemberType NoteProperty -Name 'Uri' -Value $l
            Add-Member -InputObject $r -MemberType NoteProperty -Name 'Reachable' -Value $o

            $Results += $r
        }
    }

    end
    {
        return $Results
    }
}


$Uri = "https://www.github.com/"

try
{
    $Response = Invoke-WebRequest -Uri $Uri -UseBasicParsing
}
catch
{
    throw "Could not load Uri"
}

$Links = $Response.Links.href

Test-Links -Links $Links
