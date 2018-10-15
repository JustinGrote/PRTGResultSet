function Add-PRTGResult {
    <#
    .SYNOPSIS
    Creates a new PRTG Result Type
    .DESCRIPTION
    This command creates a new PRTG result
    #>
    [CmdletBinding(DefaultParameterSetName="Unit")]
    param(
        #The name for the sensor channel
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][String]$Channel,
        #The value as integer or float.
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][Float]$Value,
        #A PRTG Result set created by New-PRTGResultSet
        [Parameter(ValueFromPipeline)][PSCustomObject]$PRTGResultSet,

        #Pass through the final resultset (if not creating a new one)
        [Switch]$PassThru,

        #Define if the limit settings defined above will be active. Default is false (no; limits inactive). If 0 is used the limits will be written to the sensor channel settings as predefined values, but limits will be disabled.
        [Parameter(ValueFromPipelineByPropertyName)][Switch]$LimitMode,
        #If enabled for at least one channel, the entire sensor is set to "Warning" status. Default is false (no).
        [Parameter(ValueFromPipelineByPropertyName)][Switch]$Warning,
        #Init value for the Show in Graphs option. Default is 1 (yes). The values defined with this element will be considered only on the first sensor scan, when the channel is newly created; they are ignored on all further sensor scans (and may be omitted). You can change this initial setting later in the sensor's channel settings.
        [Parameter(ValueFromPipelineByPropertyName)][Switch]$ShowChart,
        #Init value for the Show in Tables option. Default is 1 (yes). The values defined with this element will be considered only on the first sensor scan, when the channel is newly created; they are ignored on all further sensor scans (and may be omitted). You can change this initial setting later in the sensor's channel settings.
        [Parameter(ValueFromPipelineByPropertyName)][Switch]$ShowTable,
        #If a returned channel contains this tag, it will trigger a change notification that you can use with the Change Trigger to send a notification.
        [Parameter(ValueFromPipelineByPropertyName)][Switch]$NotifyChanged,

        #The name of the value lookup ID to use. Defaults to simple 1 for true and 0 for false
        [Parameter(ParameterSetName="ValueLookup",Mandatory,ValueFromPipelineByPropertyName)][String]$ValueLookup = "powershell.boolean",

        #The unit of the value. Default is Custom. This is useful for PRTG to be able to convert volumes and times. NOTE: CPU is a percentage unit that is accounted to the CPU load in index graphs.
        [Parameter(ParameterSetName="Unit",ValueFromPipelineByPropertyName)]
            [ValidateSet("Custom","BytesBandwidth","BytesDisk","Temperature","Percent","TimeResponse","TimeSeconds","Count","CPU","BytesFile","SpeedDisk","SpeedNet","TimeHours")]
            [String]$Unit,
        #If Custom is used as unit, this is the text displayed behind the value. Use Any string (keep it short)
        [Parameter(ParameterSetName="Unit",ValueFromPipelineByPropertyName)][String]$CustomUnit,
        #Size used for the display value. For example, if you have a value of 50000 and use Kilo as size, the display is 50 kilo #.
        [Parameter(ParameterSetName="Unit",ValueFromPipelineByPropertyName)]
            [ValidateSet("One","Kilo","Mega","Giga","Tera","Byte","KiloByte","MegaByte","GigaByte","TeraByte","Bit","KiloBit","MegaBit","GigaBit","TeraBit")]
            [Alias("VolumeSize")]
            [String]$SpeedSize,
        #In conjunction with SpeedSize, specify a duration. For instance, if you specify "Kilobit" for SpeedSize and "Second" for this parameter, the unit will be kilobit per second
        [Parameter(ParameterSetName="Unit",ValueFromPipelineByPropertyName)]
            [ValidateSet("Second","Minute","Hour","Day")]
            [String]$SpeedTime,
        #Select if the value is an absolute value or counter. Default is Absolute.
        [Parameter(ParameterSetName="Unit",ValueFromPipelineByPropertyName)]
            [ValidateSet("Absolute","Difference")]
            [String]$Mode,
        #Whether the value is a float or an integer. Set this to true if your result has a decimal point in it and is not a whole number
        [Parameter(ParameterSetName="Unit",ValueFromPipelineByPropertyName)][Switch]$Float,
        #Init value for the Decimal Places option. If 0 is used in the <Float> element (use integer), the default is Auto; otherwise (for float) the default is All.
        [Parameter(ParameterSetName="Unit",ValueFromPipelineByPropertyName)]
            [ValidateSet("Auto","All")]
            [String]$DecimalMode,
        #Define an upper error limit for the channel. If enabled, the sensor will be set to a "Down" status if this value is overrun and the LimitMode is activated.
        [Parameter(ParameterSetName="Unit",ValueFromPipelineByPropertyName)][Int]$LimitMaxError,
        #Define a lower error limit for the channel. If enabled, the sensor will be set to a "Down" status if this value is undercut and the LimitMode is activated.
        [Parameter(ParameterSetName="Unit",ValueFromPipelineByPropertyName)][Int]$LimitMinError,
        #Define an additional message. It will be added to the sensor's message when entering a "Down" status that is triggered by a limit.
        [Parameter(ParameterSetName="Unit",ValueFromPipelineByPropertyName)][String]$LimitErrorMsg,
        #Define an upper warning limit for the channel. If enabled, the sensor will be set to a "Warning" status if this value is overrun and the LimitMode is activated.
        [Parameter(ParameterSetName="Unit",ValueFromPipelineByPropertyName)][Int]$LimitMaxWarning,
        #Define a lower warning limit for the channel. If enabled, the sensor will be set to a "Warning" status if this value is undercut and the LimitMode is activated.
        [Parameter(ParameterSetName="Unit",ValueFromPipelineByPropertyName)][Int]$LimitMinWarning,
        #Define an additional message. It will be added to the sensor's message when entering a "Warning" status that is triggered by a limit.
        [Parameter(ParameterSetName="Unit",ValueFromPipelineByPropertyName)][String]$LimitWarningMsg
    )

    process {
        #Strip Common Parameters
        $CommonPSParameters = "Debug","ErrorAction","ErrorVariable","InformationAction","InformationVariable","OutVariable","OutBuffer","PipelineVariable","Verbose","WarningAction","WarningVariable","Whatif","Confirm","PRTGResultSet"
        $PRTGParams = $PSCmdlet.MyInvocation.BoundParameters
        $PRTGParams.keys.clone() | Foreach-Object {
            if ($CommonPSParameters -contains $PSItem) {
                $PRTGParams.remove($PSItem) > $null
            }
        }

        #Convert Switch Parameters to Integers
        $PRTGParams.keys.clone() | Foreach-Object {
            if ($PRTGParams[$PSItem].gettype().fullname -eq 'System.Management.Automation.SwitchParameter') {
                $PRTGParams[$PSItem] = [int][bool]($PRTGParams[$PSItem])
            }
        }
        if (-not $PRTGResultSet) {
            $PRTGResultSet = New-PRTGResultSet
            $IsNewResultSet = $true
        }

        $PRTGResultSet.prtg.result.add($PRTGParams) > $null
        if ($passthru -or $IsNewResultSet) {
            $PRTGResultSet
        }

    }
}