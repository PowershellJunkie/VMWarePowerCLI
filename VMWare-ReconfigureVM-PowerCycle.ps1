#---Setup your creds and servername---
$creds = Get-Credential -Message "Input VMWare login creds"
$server = "<your vcenter server web address or IP address>"

#---Connect to vCenter---
Connect-VIServer -Server $server -Credential $creds

#---Setup the object in order to add the flag to powercycle the vm on the next guest OS reboot; this is not persistent after the reboot---
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
$spec.ExtraConfig += New-Object VMware.Vim.OptionValue
$spec.ExtraConfig[0].key = "vmx.reboot.powerCycle"
$spec.ExtraConfig[0].value = "TRUE"

#---Get all your vms----
$vms = Get-VM | Select-Object -Property Name

#---Loop through your vms, adding the new flag---
$vms | ForEach-Object{
    $vm = $_.Name
    (Get-View(Get-VM -Name $vm).ID).ReconfigVM_Task($spec)
    }

#---Clean up your session, like a proper admin---
Disconnect-VIServer -Server $server -Confirm:$false
