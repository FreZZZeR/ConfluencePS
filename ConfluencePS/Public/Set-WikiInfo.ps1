﻿function Set-WikiInfo {
    <#
    .SYNOPSIS
    Gather URI/auth info for use in this session's REST API requests.

    .DESCRIPTION
    Unless allowing anonymous access to your instance, credentials are needed.
    Confluence REST API supports passing basic authentication in headers.
    (If you have a better suggestion for how to handle this, please reach out on GitHub!)

    .EXAMPLE
    Set-WikiInfo -BaseURI 'https://brianbunke.atlassian.net/wiki' -PromptCredentials
    Declare your base install; be prompted for username and password.

    .EXAMPLE
    Set-WikiInfo -BaseURI $ConfluenceURL -Credential $MyCreds -PageSize 100
    Sets the url, credentials and default page size for the session.

    .LINK
    https://github.com/brianbunke/ConfluencePS

    .LINK
    http://stackoverflow.com/questions/27951561/use-invoke-webrequest-with-a-username-and-password-for-basic-authentication-on-t

    .LINK
    http://www.dexterposh.com/2015/01/powershell-rest-api-basic-cms-cmsurl.html
    #>
    [CmdletBinding()]
    param (
        # Address of your base Confluence install. For Atlassian Cloud instances, include /wiki.
        [Parameter(
            HelpMessage = 'Example = https://brianbunke.atlassian.net/wiki (/wiki for Cloud instances)'
        )]
        [Uri]$BaseURi,

        # The username/password combo you use to log in to Confluence.
        [PSCredential]$Credential,

        # Default PageSize for the invocations.
        [int]$PageSize,

        # Prompt the user for credentials
        [switch]$PromptCredentials
    )

    BEGIN {
        $moduleCommands = Get-Command -Module ConfluencePS

        if ($PromptCredentials) {
            $Credential = (Get-Credential)
        }
    }

    PROCESS {

        if ($BaseURi) {
            $parameter = "ApiURi"
            foreach ($command in ($moduleCommands | Where-Object {$_.Parameters.Keys -contains $parameter})) {
                Write-Verbose "Setting ApiURi for: $command"
                $PSDefaultParameterValues["${command}:${parameter}"] = $BaseURi.AbsoluteUri.TrimEnd('/') + '/rest/api'
            }
        }

        if ($Credential) {
            $parameter = "Credential"
            foreach ($command in ($moduleCommands | Where-Object {$_.Parameters.Keys -contains $parameter})) {
                Write-Verbose "Setting Credential for: $command"
                $PSDefaultParameterValues["${command}:${parameter}"] = $Credential
            }
        }

        if ($PageSize) {
            $parameter = "PageSize"
            foreach ($command in ($moduleCommands | Where-Object {$_.Parameters.Keys -contains $parameter})) {
                Write-Verbose "Setting PageSite for: $command"
                $PSDefaultParameterValues["${command}:${parameter}"] = $PageSize
            }
        }
    }
}
