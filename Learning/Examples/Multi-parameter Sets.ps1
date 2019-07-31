[cmdletbinding(DefaultParameterSetName = 'Name')]

Param(
    [Parameter(
        ParameterSetName = 'Name',
        Mandatory = $true
    )]
    [Parameter(
        ParameterSetName = 'ID'
    )]
    [String]
    $Name,

    [Parameter(
        ParameterSetName = 'ID'
    )]
    [int]
    $ID
)

$PSCmdlet.ParameterSetName