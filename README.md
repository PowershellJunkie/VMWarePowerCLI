Simple tools designed for the purposes of interacting with VMWare PowerCLI to automate otherwise arduous/tedious tasks.



You will need to install the VMWare PowerCLI to your powershell environment in order to use these tools. Here's how:

Run Powershell (or ISE) as admin

Enable scripting with this command: Set-ExecutionPolicy Unrestricted -Force

Try this command: Install-Module VMWare.PowerCLI -Scope AllUsers

-- If this doesn't work and you get a connection error indicating that the repository cannot be found, yet you are connected to the internet, you likely need to force your TLS version to 1.2 or higher

--- if the above is true, use this command FIRST: [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

Once PowerCLI is successfully installed, use the ConfigurePowerCLIOnce.ps1 script before using any other scripts, making any necessary or appropriate edits.


Enjoy!
