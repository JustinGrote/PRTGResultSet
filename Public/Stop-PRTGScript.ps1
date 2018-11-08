function Stop-PRTGScript {
<#
.DESCRIPTION
Shortcut function for converting an exception into the PRTG JSON Error Format, outputting it, then exiting the script
.EXAMPLE
$ErrorActionPreference = 'Stop'
trap {Stop-PRTGScript $PSItem}

Put this at the top of your script to return a meaningful error for any Powershell exceptions that may occur in your script

.EXAMPLE
try {
    throw "This didn't work!"
}
catch {Stop-PRTGScript $PSItem}
Only do handling for a very specific amount of code

#>

    [CmdletBinding()]
    param (
        #The error record to provide info from. Typically this is passed via $PSItem in either a catch or trap context
        [System.Management.Automation.ErrorRecord]$ErrorRecord,
        #The exitcode to use. Defaults to 2 (System Error). Common PRTG Codes are 0=OK,1=WARNING,2=System Error (e.g. a network/socket error),3=Protocol Error (e.g. web server returns a 404),Content Error (e.g. a web page does not contain a required word). NOTE: These are not handled by PRTG for Advanced Sensors
        [int]$ExitCode = 2
    )
    (Set-PRTGResultSetMessage -AsError -Message "PS Script Error: $ErrorRecord $($ErrorRecord.ScriptStackTrace)").tostring()
    exit $ExitCode
}