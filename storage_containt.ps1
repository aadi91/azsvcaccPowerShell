connect-azAccount
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"Tenent_ID,SUBSCRIPTION_NAME,SUBSCRIPTION_ID,RESOURCE_GROUP_NAME,STORAGE_ACC_NAME,CONTAINER_NAME,FILENAME" | Out-File $oFile -Append -Encoding ascii
 
    Get-AzSubscription | ForEach-Object{
    $subscriptionId = $_.Id
    $subscriptionName = $_.Name
    $subscriptionTags = $_.Tags
    $TenentID = $_.TenantId
    $tagcount = $_.Tags.Count
    Set-AzContext -SubscriptionId $subscriptionId

    Get-AzResourceGroup | ForEach-Object{
    $resourceGroupName = $_.ResourceGroupName
   
   #$Context = (Get-AzStorageAccount -ResourceGroupName $resourceGroupName -AccountName $storageaccname).Context
   #$container = Get-AzStorageContainer -Context $Context
   #$blockBlobs = Get-AzStorageBlob -Container $container.Name -Context $Context | Where-Object {$_.name -like "*.zip"}

   Get-AzStorageAccount -ResourceGroupName $resourceGroupName -AccountName $storageaccname | ForEach-Object{
   $Context = $_.Context
   
   Get-AzStorageContainer -Context $Context | ForEach-Object{
   $container = $_.Name
   Get-AzStorageBlob -Container $container -Context $Context | Where-Object {$_.name -like "*.zip"} | ForEach-Object{
   $fileName = $_.Name
    

        
    "$TenentID,$subscriptionName,$subscriptionId,$resourceGroupName,$storageaccname,$container,$fileName" | Out-File $oFile -Append -Encoding ascii
        }
       } 
     }
   }
 }
Write-Host "script executed successfully" -ForegroundColor Green
