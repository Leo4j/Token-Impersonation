<#

.SYNOPSIS
Invoke-Impersonation Author: Rob LP (@L3o4j)
https://github.com/Leo4j/Invoke-Impersonation

.DESCRIPTION
Make_Token function written in powershell. Create a token with the provided credentials

.PARAMETER Domain
Specify the domain info

.PARAMETER UserName
Specify a UserName

.PARAMETER Password
Provide a password for the specified UserName

.PARAMETER Rev2Self
Stops impersonating a token and reverts to previous one

.EXAMPLE
Invoke-Impersonation -Username "Administrator" -Domain "ferrari.local" -Password "P@ssw0rd!"
Invoke-Impersonation -RevertToSelf
#>

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
	
    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern bool RevertToSelf();

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool CloseHandle(IntPtr hToken);
}
"@ -Language CSharp

function Invoke-Impersonation {
    param (
        [Parameter(Mandatory=$false)]
        [string]$Username,

        [Parameter(Mandatory=$false)]
        [string]$Password,

        [Parameter(Mandatory=$false)]
        [string]$Domain,
		
        [Parameter(Mandatory=$false)]
        [switch]$RevertToSelf
    )
	
    begin {
        # Check if RevertToSelf switch is NOT provided
        if (-not $RevertToSelf) {
            # If any of the mandatory parameters are missing, throw an error
            if (-not $Username -or -not $Password -or -not $Domain) {
                Write-Output "[-] Username, Password, and Domain are mandatory unless the RevertToSelf switch is provided."
				$PSCmdlet.ThrowTerminatingError((New-Object -TypeName System.Management.Automation.ErrorRecord -ArgumentList (New-Object Exception), "ParameterError", "InvalidArgument", $null))
            }
        }
    }

    process {
        if ($RevertToSelf) {
            if ([Advapi32]::RevertToSelf()) {
                Write-Output "[+] Successfully reverted to original user context."
            } else {
                Write-Output "[-] Failed to revert to original user. Error: $($Error[0].Exception.Message)"
            }
            return
        }

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
            Write-Output "[-] Failed to obtain user token. Error: $($Error[0].Exception.Message)"
            return
        }

        # Impersonate the user
        if (-not [Advapi32]::ImpersonateLoggedOnUser($tokenHandle)) {
            [Advapi32]::CloseHandle($tokenHandle)
            Write-Output "[-] Failed to impersonate user. Error: $($Error[0].Exception.Message)"
            return
        }

        Write-Output "[+] Impersonation successful"
    }
}
