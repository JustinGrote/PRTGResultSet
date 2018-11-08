# PRTGResultSet
Powershell Module for generating PRTG results in a structured manner. Used in custom EXEXML sensors.

## Simple Example Usage
``` powershell
$result = New-PRTGResult
$result += @{Channel="BrokenTest";Value=0}
$result.message = "broken!"
$result.isError = $true
$result.tojson()
```