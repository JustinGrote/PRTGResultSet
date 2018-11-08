using namespace system.collections.generic
class PRTGResult {
    [Collections.ArrayList]$Channels = @()
    [String]$Message = @()
    [Switch]$isWarning
    [Switch]$isError

    [void]Add($channel) {
        $this.Channels.add($channel)
    }

    [HashTable]GetResult() {
        $result = @{prtg=[ordered]@{result=@($this.Channels)}}
        if ($this.message) {$result.prtg.text = $this.message}
        if ($this.isWarning) {$result.prtg.warning = 1}
        if ($this.isError) {$result.prtg.error = 1}
        return $result
    }

    [String]ToJson() {
        return (ConvertTo-Json -Compress -Depth 5 $this.GetResult())
    }

    [String]ToString() {
        return $this.ToJSON()
    }

    static [PRTGResult]op_Addition($target,$newItem) {
        $target.add($newItem)
        return $target
    }
}