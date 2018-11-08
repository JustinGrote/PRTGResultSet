param (
    #Specify an alternate location for the Powershell Module. This is useful when testing a build in another directory
    [string]$ModulePath = (Get-Location)
)

import-module (join-path $ModulePath '*.psd1') -force
. .\Private\PRTGResult.class.ps1

Describe 'PRTGResult Class' {
    It 'Basic Construct' {
        $prtgresult = New-PRTGResult
        $prtgresult.gettype().name | Should -Be 'PRTGResult'
    }
    It 'String Cast Outputs Proper JSON' {
        $prtgresult = New-PRTGResult
        $prtgresult.message = 'testmessage'
        $prtgresult.iswarning = $true
        $prtgresult.iserror = $true
        $prtgresult += @{Channel="TestChannel";Value="TestValue"}
        [string]$prtgresult | Should -Be '{"prtg":{"result":[{"Channel":"TestChannel","Value":"TestValue"}],"text":"testmessage","warning":1,"error":1}}'
    }
}

Describe 'Add-PRTGResultSet' {
    It 'Values passed as parameters' {
        $testResultSet = Add-PRTGResult -Channel "Test" -Value 5
        $testResultSet.GetResult().prtg.result[0].channel | Should Be 'Test'
        $testResultSet.GetResult().prtg.result[0].value | Should Be 5
    }
    It 'ResultSet passed via pipeline' {
        $testResultSet = New-PRTGResult
        $testResultSet | Add-PRTGResult -Channel "Test" -Value 5
        $testResultSet | Add-PRTGResult -Channel "Test2" -Value 8
        $testResultSet.GetResult().prtg.result[0].channel | Should Be 'Test'
        $testResultSet.GetResult().prtg.result[0].value | Should Be 5
        $testResultSet.GetResult().prtg.result[1].channel | Should Be 'Test2'
        $testResultSet.GetResult().prtg.result[1].value | Should Be 8
    }
    It 'Multiple Add-PRTGResults work correctly via pipeline' {
        $testResultSet = New-PRTGResult
        $testResultSet | Add-PRTGResult -Channel "Test" -Value 5
        $testResultSet | Add-PRTGResult -Channel "Test2" -Value 8
        $testResultSet.GetResult().prtg.result[0].channel | Should Be 'Test'
        $testResultSet.GetResult().prtg.result[0].value | Should Be 5
        $testResultSet.GetResult().prtg.result[1].channel | Should Be 'Test2'
        $testResultSet.GetResult().prtg.result[1].value | Should Be 8
    }
    It 'Outputs correctly formatted JSON' {
        $testResultSet = New-PRTGResult
        $testResultSet | Add-PRTGResult -Channel "Test" -Value 5
        $testResultSet | Add-PRTGResult -Channel "Test2" -Value 8
        $testResultSet.tostring() | Should Be '{"prtg":{"result":[{"Channel":"Test","Value":5},{"Channel":"Test2","Value":8}]}}'
    }
}
