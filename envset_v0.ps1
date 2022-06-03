$first, $rest = $env:Path -split ';'
if ($first -eq "C:\Windows\system32"){
write-host "correct path $first already added" -ForegroundColor Green
}
else{
##___________________________
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
$envpatha = $env:Path | Where-Object {$_."C:\Windows\system32"}
Write-Host $path


###Adding###
$mpath = $Env:PATH -split ';'
Write-Output $mpath 
$Env:PATH >> Env_Path.txt
$Env:PATH += ";C:\Windows\system32"
$Env:PATH = "C:\Windows\system32;$Env:PATH"
[Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";", [EnvironmentVariableTarget]::Machine)
$envPaths = $env:Path -split ';'

}







