# Define the required constants and structs
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public enum LogonType : int {
    LOGON32_LOGON_NEW_CREDENTIALS = 9,
}

public enum LogonProvider : int {
    LOGON32_PROVIDER_DEFAULT = 0,
}

public class Advapi32 {
    [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    public static extern bool LogonUser(
        String lpszUsername,
        String lpszDomain,
        String lpszPassword,
        LogonType dwLogonType,
        LogonProvider dwLogonProvider,
        out IntPtr phToken
    );

    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern bool ImpersonateLoggedOnUser(IntPtr hToken);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool CloseHandle(IntPtr hToken);
}
"@ -Language CSharp

function Invoke-Impersonation {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Username,

        [Parameter(Mandatory=$true)]
        [string]$Password,

        [Parameter(Mandatory=$true)]
        [string]$Domain
    )

    $tokenHandle = [IntPtr]::Zero

    # Use the LogonUser function to get a token
    $result = [Advapi32]::LogonUser(
        $Username,
        $Domain,
        $Password,
        [LogonType]::LOGON32_LOGON_NEW_CREDENTIALS,
        [LogonProvider]::LOGON32_PROVIDER_DEFAULT,
        [ref]$tokenHandle
    )

    if (-not $result) {
        throw "Failed to obtain user token. Error: $($Error[0].Exception.Message)"
    }

    # Impersonate the user
    if (-not [Advapi32]::ImpersonateLoggedOnUser($tokenHandle)) {
        [Advapi32]::CloseHandle($tokenHandle)
        throw "Failed to impersonate user. Error: $($Error[0].Exception.Message)"
    }

    Write-Host "Impersonation successful. To revert, close this PowerShell session or call [Advapi32]::RevertToSelf()"
}
