<#
    Gets a list of logons with timestamp, logon type, username, client name, client IP address, server name

    EventID   description
    4624      An account was successfully logged on
    4625      An account failed to log on
    4740      A user account was locked out

    Code slightly refactored from page 89 of "PowerShell Deep Dives"
    Chapter by Mike F. Robbins
#>

param ( $ComputerName = $env:COMPUTERNAME, $EventID = 4624, $Records = 10 )
foreach ($Computer in $ComputerName) {
    Get-WinEvent -Computer $Computer -LogName 'Security' -MaxEvents $Records -FilterXPath "*[System[EventID=$EventID]]" |

        Select-Object @{Label = 'Time';Expression={$_.TimeCreated.ToString('g')}},
            @{Label="Logon Type"; 
                Expression={switch 
                    (foreach {$_.properties[8].value}) {
                        0 {"System"; break;}
                        2 {"Interactive"; break;}
                        3 {"Network"; break;}
                        4 {"Batch"; break;}
                        5 {"Service"; break;}
                        6 {"Proxy"; break;}
                        7 {"Unlock"; break;}
                        8 {"NetworkCleartext"; break;}
                        9 {"NewCredentials"; break;}
                        10 {"RemoteInteractive"; break;}
                        11 {"CachedInteractive"; break;}
                        12 {"CachedRemoteInteractive"; break;}
                        12 {"CachedUnlock"; break;}
                        default {"Other"; break;}
                    } #foreach
                } #switch
            }, #Label
            @{Label='Authentication';
                Expression={
                    $_.Properties[10].Value
                } 
            },
            @{Label='User Name'; Expression={$_.Properties[5].value}},
            @{Label='Client Name'; Expression={$_.Properties[11].value}},
            @{Label='Client Address'; Expression={$_.Properties[18].value}},
            @{Label='Server Name'; Expression={$_.Properties.MachineName}} |

                sort @{Expression="Server Name";Descending=$false},
                @{Expression="Time";Descending=$true}
}
