#IMEI retrieval script

[CmdletBinding(DefaultParameterSetName = 'IMEI')]
param (
    [parameter (Mandatory, ParameterSetName = 'IMEI')]
    [string]$DeviceSerial,

    [PSDefaultValue(Help='user Env variable MerakiKey')]
    [string]$APIKey = $env:MerakiKey
)

if (!$APIKey) {
    Write-Error "Meraki API key required. Either supply one to the -APIKey parameter, or define an environmental variable `"MerakiKey`" which is used by default."
    Exit
}


$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("X-Cisco-Meraki-API-Key", "$APIKey")

$URI = "https://api.meraki.com/api/v1"

#Stupid friggin API doesn't return IMEI if you just query one device status, but if you get all devices in an org, it will include it then? So I have to take the 
# stupid serial and find the stupid network ID and then find the stupid org ID and then get all the stupid devices and then return the one we actually want

try {
    $DeviceInfo = Invoke-RestMethod -Method Get -Headers $headers -Uri "$URI/devices/$DeviceSerial" -ErrorAction Stop
}
catch {
    Write-Error "No result for that serial"
    Exit
}

$NetworkID = $DeviceInfo.NetworkID

$NetworkInfo = Invoke-RestMethod -Headers $headers -Method Get -uri "$URI/networks/$NetworkID"

$OrgID = $NetworkInfo.organizationId

$AllDevices = Invoke-RestMethod -Method Get -Headers $headers -Uri "$URI/organizations/$OrgID/devices"

$Device = $AllDevices | Where-Object {$_.serial -like $DeviceSerial}

$Device | Select-Object name,serial,IMEI
