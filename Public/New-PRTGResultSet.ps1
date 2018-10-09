function New-PRTGResultSet {
    <#
    .SYNOPSIS
        Creates a new PRTG Result Set Base Object
    #>

    [CmdletBinding()]

    $result = @{}
    $result.prtg = @{}
    $result.prtg.result = New-Object System.Collections.Arraylist
    $result

}
