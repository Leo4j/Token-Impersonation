# Invoke-Impersonation
Make_Token function written in powershell. Create a token with the provided credentials

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
