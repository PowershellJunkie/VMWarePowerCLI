#---Use this section to Ignore invalid certificates in a non-web enabled VMWare environment---
#----To Create a PowerCLI trusted Certificate store, see info at this link: https://developer.vmware.com/docs/15315/GUID-9227B99D-405A-4B10-A550-C155C164E465.html
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope AllUsers -Confirm:$false

#---This command disables the CEIP (Customer Experience Improvement Program) in PowerCLI---
Set-PowerCLIConfiguration -ParticipateInCeip $false -Confirm:$false
