#---Setup your creds and server connection---
$creds = Get-Credential -Message "Input VMWare login creds"
$server = "<your vcenter server web address or IP address>"

#---Connect to vCenter---
Connect-VIServer -Server $server -Credential $creds

#---Get Powered On VMs running Microsoft Server---
$vms = Get-VM | Select-Object -Property Name,Guest,PowerState | Where {$_.Guest -like "*Microsoft Windows Server*" -and $_.PowerState -eq "PoweredOn"}
#---Uncomment to see output of your query---
#$vms | Write-Output | ft

#---Mount VMWare Tools---
$vms | ForEach-Object{
    $vm = $_.Name
    Get-VMGuest $vm | Mount-Tools
    }

#---Clean up connection session---
Disconnect-VIServer -Server $server -Confirm:$false
