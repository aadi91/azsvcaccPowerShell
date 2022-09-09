connect-azAccount
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"Tenent_ID,SUBSCRIPTION_NAME,SUBSCRIPTION_ID,RESOURCE_GROUP_NAME,AKS_NAME,AKS_FQDN,USER_NAME,AKS_ROLES" | Out-File $oFile -Append -Encoding ascii
 
    Get-AzSubscription | ForEach-Object{
    $subscriptionId = $_.Id
    $subscriptionName = $_.Name
    $subscriptionTags = $_.Tags
    $TenentID = $_.TenantId
    $tagcount = $_.Tags.Count
    Set-AzContext -SubscriptionId $subscriptionId

    Get-AzResourceGroup | ForEach-Object{
    $resourceGroupName = $_.ResourceGroupName

    Get-AzAksCluster -ResourceGroupName $resourceGroupName -WarningAction SilentlyContinue | ForEach-Object{

    $aksName = $_.Name
    $aksFDQN = $_.Fqdn
    $aksID = $_.Id
    
    Get-AzRoleAssignment -Scope "$aksID" | Where{($_.RoleDefinitionName -eq 'Contributor') -or ($_.RoleDefinitionName -like 'WBA Contributor' )} | ForEach-Object{
    $UserName = $_.DisplayName
    $ROlesDefination = $_.RoleDefinitionName

        
    "$TenentID,$subscriptionName,$subscriptionId,$resourceGroupName,$aksName,$aksFDQN,$UserName,$ROlesDefination" | Out-File $oFile -Append -Encoding ascii
        }
       } 
      }
 }
Write-Host "script executed successfully" -ForegroundColor Green
