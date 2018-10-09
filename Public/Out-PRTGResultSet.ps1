function Out-PRTGResultSet {
<#
.SYNOPSIS
Output the PRTG Result Set Object in JSON Format. Typically this is the last step in your EXEXML script to report to PRTG
#>
    param(
        #The PRTG Result Set to Output
        [Parameter(ValueFromPipeline)][PSCustomObject]$PRTGResultSet,
        #Whether to compress the JSON or not. Defaults to True, set to false if you want to see a more readable JSON (useful for debugging)
        [Switch]$Compress = $true
    )
    $ConvertToJsonParams = @{
        InputObject = $PRTGResultSet
        Depth = 5
        Compress = $Compress
    }
    ConvertTo-Json @ConvertToJsonParams
}
