#---Setup your creds and servername---
$creds = Get-Credential -Message "Input VMWare login creds"
$server = "<your vCenter FQDN>"

#---Connect to vCenter---
Connect-VIServer -Server $server -Credential $creds

#---Get list of all VM's---
$vms = Get-VM | Select-Object -Property Name

#---Print to screen all VM's and their snapshots---
$vms | ForEach-Object{

    $vm = $_.Name
    $snaps = Get-Snapshot -VM $vm | Select-Object -ExpandProperty Name

<#---If Snapshots exist, for any VM, select that VM and remove the snapshot without confirmation
     This command runs syncronously, meaning that, as written, each snapshot will be removed in turn before the next snapshot removal is started.
     If you desire to confirm each snapshot removal, or deny as needed, simply remove the '-Confirm:$false' switch
---#>
If($snaps){
        Get-Snapshot -VM $vm | Remove-Snapshot -RemoveChildren -Confirm:$false
     }

    }

#---Clean up connection session---
Disconnect-VIServer -Server $server -Confirm:$false
