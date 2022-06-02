connect-azAccount
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"Tenent_ID,SUBSCRIPTION_NAME,SUBSCRIPTION_ID,RESOURCE_GROUP_NAME,VM_NAME" | Out-File $oFile -Append -Encoding ascii
 
    Get-AzSubscription | ForEach-Object{
    $subscriptionId = $_.Id
    $subscriptionName = $_.Name
    $subscriptionTags = $_.Tags
    $TenentID = $_.TenantId
    $tagcount = $_.Tags.Count
    Set-AzContext -SubscriptionId $subscriptionId

    Get-AzResourceGroup | ForEach-Object{
        $resourceGroupName = $_.ResourceGroupName
        
         Get-AzVM -ResourceGroupName  $resourceGroupName | ForEach-Object{
          
          $VMName = $_.Name
          $OsType = $_.OsName
      
        
    "$TenentID,$subscriptionName,$subscriptionId,$resourceGroupName,$VMName" | Out-File $oFile -Append -Encoding ascii
        }
     }
}
Write-Host "script executed successfully" -ForegroundColor Green
