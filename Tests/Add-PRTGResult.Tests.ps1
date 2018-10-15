param (
    #Specify an alternate location for the Powershell Module. This is useful when testing a build in another directory
    [string]$ModulePath = (Get-Location)
)
import-module (join-path $ModulePath '*.psd1') -force

Describe 'Add-PRTGResultSet' {
    It 'Add-PRTGResult -Channel -Value' {
        $testResultSet = Add-PRTGResult -Channel "Test" -Value 5
        $testResultSet['prtg'].result[0].channel | Should Be 'Test'
        $testResultSet['prtg'].result[0].value | Should Be 5
    }
    It 'Multiple Add-PRTGResults work correctly via pipeline' {
        $testResultSet = New-PRTGResultSet
        $testResultSet | Add-PRTGResult -Channel "Test" -Value 5
        $testResultSet | Add-PRTGResult -Channel "Test2" -Value 8
        $testResultSet['prtg'].result[0].channel | Should Be 'Test'
        $testResultSet['prtg'].result[0].value | Should Be 5
        $testResultSet['prtg'].result[1].channel | Should Be 'Test2'
        $testResultSet['prtg'].result[1].value | Should Be 8
    }
    It 'Outputs correctly formatted JSON' {
        $testResultSet = New-PRTGResultSet
        $testResultSet | Add-PRTGResult -Channel "Test" -Value 5
        $testResultSet | Add-PRTGResult -Channel "Test2" -Value 8
        $testResultSet | ConvertTo-Json -Depth 5 -Compress | Should Be '{"prtg":{"result":[{"Channel":"Test","Value":5},{"Channel":"Test2","Value":8}]}}'
    }
}