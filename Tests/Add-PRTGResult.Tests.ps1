param (
    #Specify an alternate location for the Powershell Module. This is useful when testing a build in another directory
    [string]$ModulePath = (Get-Location)
)
import-module (join-path $ModulePath '*.psd1') -force

Describe 'Add-PRTGResultSet' {
    It 'Add-PRTGResult -Channel -Value' {
        $testResultSet = Add-PRTGResult -Channel "Test" -Value 5
        $testResultSet['prtg'].result[0].channel | Should -Be 'Test'
        $testResultSet['prtg'].result[0].value | Should -Be 5
    }
}