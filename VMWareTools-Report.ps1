#---Setup your creds and servername---
$creds = Get-Credential -Message "Input VMWare login creds"
$server = "<your vcenter server FQDN>"

#---Connect to vCenter---
Connect-VIServer -Server $server -Credential $creds


#---Gather VM's and create a report of machines with old versions of VMWare tools installed---
$report = Get-View -ViewType VirtualMachine -Property Name,Guest |`
Select Name,@{N='ToolsStatus';E={$_.Guest.ToolsStatus}},

    @{N='ToolsType';E={$_.Guest.ToolsInstallType}},

    @{N='ToolsVersion';E={$_.Guest.ToolsVersion}},

    @{N='ToolsRunningStatus';E={$_.Guest.ToolsRunningStatus}},

    @{N='vCenter';E={([uri]$_.Client.ServiceUrl).Host}} |`

Sort-Object -Property Name

#---Setup Array as HTML table, sorting only for the relevant properties---
$toolsrp = $report | Select-Object -Property Name,ToolsStatus | Where {$_.ToolsStatus -like "*toolsOld*"} | ConvertTo-Html -As Table -Fragment

# Create HTML output for email
 $htmlbod = @"
<html> 
<head>
<style>
body {
    Color: #252525;
    font-family: Verdana,Arial;
    font-size:11pt;
}
table {border: 1px solid rgb(104,107,112); text-align: left;}
th {background-color: #d2e3f7;border-bottom:2px solid rgb(79,129,189);text-align: left;}
tr {border-bottom:2px solid rgb(71,85,112);text-align: left;}
td {border-bottom:1px solid rgb(99,105,112);text-align: left;}
h1 {
    text-align: left;
    color:#5292f9;
    Font-size: 14pt;
    font-family: Verdana, Arial;
}
h2 {
    text-align: left;
    color:#323a33;
    Font-size: 20pt;
}

</style>
</head>
<body style="font-family:verdana;font-size:13">
Hello, <br><br>

The following list of require a VMWare tools upgrade. Please remediate this as soon as possible.<br>
<br>
<h2>VMWare Tools Report</h2>
$toolsrp

<br>
<br>
Thank you,<br>
Systems Administration<br><br>

</body> 
</html> 
"@ 

#---Send the report via email---
Send-MailMessage -From '<somesender@yourdomain.com>' -To '<somerecipient@yourdomain.com>' -Subject 'VMWare Tools Upgrades Needed' -BodyAsHtml $htmlbod -SmtpServer '<your-mail-relay-server>'
