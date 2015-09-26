#function returns true if current session runs with Admin rights; false if not.

function isAdmin { 
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent() 
    $principal = new-object System.Security.Principal.WindowsPrincipal($identity) 
    $admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator 
    $principal.IsInRole($admin) 
} 
