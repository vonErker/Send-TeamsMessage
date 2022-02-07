function Send-TeamsMessage {

    param (
        [string]$Title = "$ENV:Computername",
        [string]$Summary = "Message from: $ENV:Computername",
        [parameter (Mandatory=$true)][string]$Message,
        [parameter (Mandatory=$true)]$TeamsURI,
        [switch]$SuppressOutput,
        [switch]$WhatIf
    )

    if ($WhatIf) {
        Write-Host "What if: Sending Message:" -NoNewline -ForegroundColor "Cyan"
        Write-host ""$Message "" -NoNewline -ForegroundColor "Green"
        Write-Host "with Title: " -NoNewline -ForegroundColor "Cyan"
        Write-Host "$Title " -NoNewline -ForegroundColor "Green"
        Write-Host "to Teams-channel:" -NoNewline -ForegroundColor "Cyan"
        Write-Host ""$TeamsURI "" -ForegroundColor "Green"
        exit
    }
        
    $JSONBody = [PSCustomObject][Ordered]@{
        "@type" = "MessageCard"
        "@context" = "<http://schema.org/extensions>"
        "summary" = "$Summary"
        "themeColor" = '0078D7'
        "title" = "$Title"
        "text" = "$Message"
    }

    $TeamMessageBody = ConvertTo-Json $JSONBody
    
    $parameters = @{
        "URI" = "$TeamsURI"
        "Method" = 'POST'
        "Body" = $TeamMessageBody
        "ContentType" = 'application/json'
    }

    if ($SuppressOutput) {
        Invoke-RestMethod @parameters | Out-Null
    } else {
        Invoke-RestMethod @parameters
    }   
}
