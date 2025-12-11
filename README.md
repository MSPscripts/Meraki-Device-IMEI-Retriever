# Meraki-Device-IMEI-Retriever
A powershell script that leverages the Meraki API to retrieve the IMEI of a Meraki device. The IMEI is not currently exposed in the dashboard, for reasons (???)

Why?

If you are a Meraki administrator, you may need the IMEI of your Meraki devices that have cell modems (e.g., MX67C models). The IMEI is printed physically on the devices, but is not exposed in the dashboard.
If you ask Meraki support, they can tell you, but only if the product was ordered in the last 40 days. I invite speculation on what shenanigans exist to cause that situation.
However, the IMEI is accessible to you via the API. Instructions for getting your API key are here: https://developer.cisco.com/meraki/api-v1/authorization/#obtaining-your-meraki-api-key

Using the script

The script is very simple. There are two necessary parameters: the serial of the device (e.g. "1234-ABCD-5678"), and your API key. You can paste your API key each time you use the script, or you can set an environmental variable called "MerakiKey". If you omit the "APIKey" parameter, the script will default to looking for that environmental variable.

Copying that IMEI into an order page? Retrieve it in one line for maximum efficiency! Something like this in your powershell terminal will run the script and pipe the IMEI into your clipboard -
> (& '.\Get-MerakiIMEI.ps1' -DeviceSerial "1234-ABCD-5678").imei | Clip
