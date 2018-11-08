function New-PRTGResult {
    [CmdletBinding()]
    [Alias("New-PRTGResultSet")]
    param()
    <#
    .SYNOPSIS
        Creates a new PRTG Result Set Base Object
    #>
    return [PRTGResult]::New()
}