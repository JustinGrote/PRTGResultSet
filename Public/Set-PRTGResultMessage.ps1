function Set-PRTGResultSetMessage {
<#
.SYNOPSIS
Output the PRTG Result Set Object in JSON Format. Typically this is the last step in your EXEXML script to report to PRTG
#>
    param(
        #The content of the message. Default is "OK"
        [String]$Message,
        #Specify if the message is an error. WARNING: This type of error does not save the channel data, only use for script errors or if historical info is not required. A sensor in this error status cannot return any data in its channels; if used, all channel values in the <result> section will be removed.
        [Switch]$AsError,
        #Specify if the message is a warning
        [Switch]$AsWarning,
        #The PRTG Result Set to set the message for
        [Parameter(ValueFromPipeline)]$PRTGResultSet
    )

    if ($AsError -or (-not $PRTGResultSet)) {
        $PRTGResultSet = New-PRTGResult
    }

    if ($AsError) {$PRTGResultSet.isError = $true}
    if ($AsWarning) {$PRTGResultSet.isWarning = $true}

    $PRTGResultSet.message = $Message
    if ($AsError -or (-not $PRTGResultSet)) {
        $PRTGResultSet
    }
}