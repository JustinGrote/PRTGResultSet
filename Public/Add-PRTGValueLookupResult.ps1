function Add-PRTGValueLookupResult {
    <#
    .SYNOPSIS
    Adds a ValueLookup Result to a PRTG Result Set
    #>
    [CmdletBinding()]
    param(
        #A PRTG Result set created by New-PRTGResultSet
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)][PRTGResult]$PRTGResultSet = (New-PRTGResultSet),
        #The name for the sensor channel
        [Parameter(ValueFromPipelineByPropertyName)][String]$Channel = "PowershellTestResult-$(Get-Random)",
        #The name of te value lookup ID to use. Defaults to simple 1 for true and 0 for false
        [Parameter(ValueFromPipelineByPropertyName)][String]$ValueLookup = "powershell.boolean",
        #The name of the value lookup ID to use. Defaults to simple 1 for true and 0 for false
        [Parameter(ValueFromPipelineByPropertyName)][Int]$Value = $false
    )

    process {
        $result = @{
            Channel =  $Channel
            ValueLookup = $ValueLookup
            Value = $Value
        }
        $PRTGResultSet += $result
    }
}