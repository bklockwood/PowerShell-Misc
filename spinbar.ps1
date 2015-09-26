function spinbar($job) {
    $saveY = [console]::CursorTop
    $saveX = [console]::CursorLeft   
    $str = '|','/','-','\','*'  
    do {
        $str | ForEach-Object { Write-Host -Object $_ -NoNewline
            Start-Sleep -Milliseconds 100
            [console]::setcursorposition($saveX,$saveY)
        }

        if ((Get-Job -Name $job).state -eq 'Running') {
            $running = $true
        } else {
            $running = $false
        }
    } 
    while ($running)
}
#the console class is not supported in the ISE, http://goo.gl/jj8N8I
#but this works fine in the 'regular' PowerShell console.
Start-Job -ScriptBlock {Start-Sleep 10} -Name j1 |out-null
spinbar j1
remove-job j1
