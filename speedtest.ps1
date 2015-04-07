#a very rough network bandwidth test
#will not give results like iperf or the speedtest.net website,
#since it doesn't attempt to pack the NIC with multiple 
#download streams. 

#Speedtest server list - http://c.speedtest.net/speedtest-servers-static.php

<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Get-DownloadSpeed
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true, Position=0)]
        $SpeedtestServer,

        # Param2 help description
        [Parameter(Mandatory=$true, Position=1)]
        $DownLoad
    )

    Process
    {
        $ProgressPreference = "SilentlyContinue"
        [string]$testurl = $SpeedtestServer + $DownLoad
        try {
            $Error = $null
            $time = measure-command `
                {$dl = Invoke-WebRequest -uri $testurl -TimeoutSec 1 `
                 -UserAgent ([Microsoft.PowerShell.Commands.PSUserAgent]::Chrome)}
        } catch {
            write-host "Error downloading $testurl "
            write-host $dl
            break
        }
        $result = $($dl.RawContentLength) / $($time.totalseconds)
        $resultmb = $result / 1000000
        $resultmb = [math]::Round($resultmb,2) #round to 2 decimal places
        $dlmb = $($dl.RawContentLength) / 1000000
        $dlmb = [math]::Round($dlmb,2)
        $secs = $($time.totalseconds)
        $secs = [math]::Round($secs,2)
        Write-host "$testurl downloaded $dlmb Mbit in $secs seconds at $resultmb Mbit/s"

    }
}

$dl500 = "/speedtest/random500x500.jpg" 
$dl1000 = "/speedtest/random1000x1000.jpg" 
$dl2000 = "/speedtest/random2000x2000.jpg"
$dltest10 = "/downloads/test10.zip" 
$dltest100 = "/downloads/test100.zip"
$dltest500 = "/downloads/test500.zip"

<#$testserver = "www.irongoat.net/speedtest"
Get-DownloadSpeed $testserver $dltest1000
Get-DownloadSpeed $testserver $dl1000 
Get-DownloadSpeed $testserver $dl2000
Get-DownloadSpeed $testserver $dl2000
Get-DownloadSpeed $testserver $dl2000
Get-DownloadSpeed $testserver $dl2000
Get-DownloadSpeed $testserver $dl2000
#>

$testserver = "http://speedtest.sea01.softlayer.com"

#Get-DownloadSpeed $testserver $dltest100
Get-DownloadSpeed $testserver $dltest10
Get-DownloadSpeed $testserver $dltest10
Get-DownloadSpeed $testserver $dltest10
Get-DownloadSpeed $testserver $dltest10
<#
Get-DownloadSpeed $testserver $dltest100
Get-DownloadSpeed $testserver $dltest100

#>

