$first, $pathContent = [Environment]::GetEnvironmentVariable('path', 'Machine') -split ';'
$myPath = "C:\WINDOWS\system32"
if ($pathContent -ne $null)
 {
  if ($pathContent -split ';'  -contains  $myPath) 
           
          {
          Write-Host "$myPath exists" -ForegroundColor Cyan

          if ($first  -contains $myPath)
          
              {
              Write-Host "Adding $myPath in first position " -ForegroundColor Green
              $Env:PATH >> Env_Path.txt
               $Env:PATH += ";C:\Windows\system32"
               $Env:PATH = "C:\Windows\system32;$Env:PATH"
              [Environment]::SetEnvironmentVariable("PATH", "$Env:PATH", [EnvironmentVariableTarget]::Machine)

              }

          else
              {
                 Write-host "Removing the path $myPath"

		         # Get it
                    $path = [System.Environment]::GetEnvironmentVariable(
                        'PATH',
                        'Machine'
                    )
                    # Remove unwanted elements
                    $path = ($path.Split(';') | Where-Object { $_ -ne 'C:\Windows\system32' }) -join ';'
                    # Set it
                    [System.Environment]::SetEnvironmentVariable(
                        'PATH',
                        $path,
                        'Machine'
                    )
                   
               ############################################
               Write-Host "Adding $myPath in first position after deleteing  " -ForegroundColor Yellow
               #$Env:PATH >> Env_Path.txt
               $Env:PATH += ";C:\Windows\system32"
               #$Env:PATH = "C:\Windows\system32;$Env:PATH"
              [Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";", [EnvironmentVariableTarget]::Machine)
              #[System.Environment]::SetEnvironmentVariable("PATH", "$Env:PATH" + ";",[System.EnvironmentVariableTarget]::Machine)
              
              
             }
        }
    }
else
{Write-Host "NO Value present in environment variable" }
