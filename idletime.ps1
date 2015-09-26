#script for Arrick by Mota, 2014/12/03
#basic idea: if no keyboard/mouse input for more than 3 minutes, 
#kill all processes with open windows. some logging for troubleshooting.
#(the whole thing is meant to be run once every minute via Task Scheduler)
#borrowed much code from here: http://stackoverflow.com/questions/15845508/

Add-Type @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

namespace PInvoke.Win32 {

    public static class UserInput {

        [DllImport("user32.dll", SetLastError=false)]
        private static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

        [StructLayout(LayoutKind.Sequential)]
        private struct LASTINPUTINFO {
            public uint cbSize;
            public int dwTime;
        }

        public static DateTime LastInput {
            get {
                DateTime bootTime = DateTime.UtcNow.AddMilliseconds(-Environment.TickCount);
                DateTime lastInput = bootTime.AddMilliseconds(LastInputTicks);
                return lastInput;
            }
        }

        public static TimeSpan IdleTime {
            get {
                return DateTime.UtcNow.Subtract(LastInput);
            }
        }

        public static int LastInputTicks {
            get {
                LASTINPUTINFO lii = new LASTINPUTINFO();
                lii.cbSize = (uint)Marshal.SizeOf(typeof(LASTINPUTINFO));
                GetLastInputInfo(ref lii);
                return lii.dwTime;
            }
        }
    }
}
'@

$host.UI.RawUI.WindowTitle = "DontKillMe"
$Last = [PInvoke.Win32.UserInput]::LastInput
$Idle = [PInvoke.Win32.UserInput]::IdleTime
$IdleStr = $Idle.Days.ToString() + ":" + $Idle.Hours + ":" + $Idle.Minutes + ":" + `
    $Idle.Seconds + " Days:Hours:Mins:Secs Idle"
$CurrDate = get-date
$CurrDateUTC = $CurrDate.ToUniversalTime()
$3MinsAgoUTC = $CurrDateUTC.AddMinutes(-3)
$LastUserInputUTC = $Last.ToUniversalTime()
$LogFilePath = "C:\temp\idletestlog.txt"

out-file -FilePath $LogFilepath -InputObject "$CurrDateUTC .. Last input $LastUserInputUTC .. $IdleStr" -Append -NoClobber

if ($LastUserInputUTC -lt $3MinsAgoUTC) {
    out-file -FilePath $LogFilepath -InputObject "Idle time is greater than 3 minutes" -Append -NoClobber
    #the DontKillMe thing is because the script was killing ITSELF before  it could launch IE! hah!
    get-process | where {$_.MainWindowHandle -ne 0} | where {$_.MainWindowTitle -ne "DontKillMe"} | stop-process | out-null
    start-process "C:\Program Files\Internet Explorer\iexplore.exe"
    }
