connect-azAccount
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"Tenent_ID,SUBSCRIPTION_NAME,SUBSCRIPTION_ID,RESOURCE_GROUP_NAME,STORAGE_ACC_NAME,CONTAINER_NAME,CREATIONDATE" | Out-File $oFile -Append -Encoding ascii
 
    Get-AzSubscription | ForEach-Object{
    $subscriptionId = $_.Id
    $subscriptionName = $_.Name
    $subscriptionTags = $_.Tags
    $TenentID = $_.TenantId
    $tagcount = $_.Tags.Count
    Set-AzContext -SubscriptionId $subscriptionId

    Get-AzResourceGroup | ForEach-Object{
    $resourceGroupName = $_.ResourceGroupName
    Get-AzStorageAccount -ResourceGroupName $resourceGroupName | ForEach-Object{
    $storageaccname = $_.StorageAccountName
    $ctx=$_.Context 
    Get-AzStorageContainer -Context $ctx | Where-Object {$_.PublicAccess -eq "Blob"} | ForEach-Object{
    $containername = $_.Name
    $createddate = $_.LastModified
   
    
    
    
        
    "$TenentID,$subscriptionName,$subscriptionId,$resourceGroupName,$storageaccname,$containername,$createddate" | Out-File $oFile -Append -Encoding ascii
        }
        
     }
   }
 }
Write-Host "script executed successfully" -ForegroundColor Green
