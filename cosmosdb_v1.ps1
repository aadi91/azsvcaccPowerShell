connect-azAccount
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"Tenent_ID,SUBSCRIPTION_NAME,SUBSCRIPTION_ID,RESOURCE_GROUP_NAME,COSMOS_DB_NAME,MATRIC_AVG,MATRIC_MAX" | Out-File $oFile -Append -Encoding ascii
 
    Get-AzSubscription | ForEach-Object{
    $subscriptionId = $_.Id
    $subscriptionName = $_.Name
    $subscriptionTags = $_.Tags
    $TenentID = $_.TenantId
    $tagcount = $_.Tags.Count
    Set-AzContext -SubscriptionId $subscriptionId

    Get-AzResourceGroup | ForEach-Object{
        $resourceGroupName = $_.ResourceGroupName
        
         Get-AzCosmosDBAccount -ResourceGroupName  $resourceGroupName | ForEach-Object{
          
          $cdbName = $_.Name
          $cdbid = $_.Id
          $name = (Get-AzResource -ResourceId $cdbid).Name
          $metricdata = Get-AzMetric -ResourceId $cdbid -TimeGrain 00:05:00 -MetricName "NormalizedRUConsumption" -AggregationType Maximum -WarningAction Ignore -StartTime (Get-Date).adddays(-30) -EndTime (Get-Date) -DetailedOutput
           $metricdata | ForEach-Object{
            $metric_used = $_.Data.Maximum | measure -Maximum
             $metric_maximum = $_.Maximum


           
        
    "$TenentID,$subscriptionName,$subscriptionId,$resourceGroupName,$cdbName,$metricAvg,$metricMax" | Out-File $oFile -Append -Encoding ascii
        }
     }
    }
}
Write-Host "script executed successfully" -ForegroundColor Green
