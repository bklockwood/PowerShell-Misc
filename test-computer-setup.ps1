#join domain or reset secure channel
#add-computer -domainname purgatory -localcredential Administrator -newname s1 -credential bryanda
Reset-ComputerMachinePassword -Credential purgatory\bryanda

#Enable Remote Desktop
$TSsetting = Get-WmiObject Win32_TerminalServiceSetting -Namespace root\cimv2\TerminalServices
$TSsetting.SetAllowTsConnections(1,1) | Out-Null
$TSGeneral = Get-WmiObject -Class "Win32_TSGeneralSetting" -Namespace root\cimv2\TerminalServices -Filter "TerminalName='RDP-tcp'"
$TSGeneral.SetUserAuthenticationRequired(0) | Out-Null
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

#do not start server manager at login
Set-ItemProperty -path HKLM:\SOFTWARE\Microsoft\ServerManager -name DoNotOpenServerManagerAtLogon -Value 1

#Allow ping responses
Enable-NetFirewallRule -Displayname "File and Printer Sharing (Echo Request - ICMPv4-In)"
Enable-NetFirewallRule -Displayname "File and Printer Sharing (Echo Request - ICMPv6-In)"

#Make sure DNS is registered
Set-DnsClient * -UseSuffixWhenRegistering $true
Clear-DnsClientCache
Register-DnsClient

#Update help, set execution policy, enable remoting
Update-Help
Set-ExecutionPolicy Unrestricted
Enable-PSRemoting

#pin psise to taskbar ??
