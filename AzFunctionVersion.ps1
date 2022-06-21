$subsc_name = 'Azure subscription 1'
connect-azAccount -Subscription $subsc_name
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"SUBSCRIPTION_NAME,SUBSCRIPTION_ID,RESOURCE_GROUP_NAME,HOSTNAME,STATE,FUNCTION_APP_VERSION,TLS_VERSION" | Out-File $oFile -Append -Encoding ascii
 
$subs = Get-AzSubscription -SubscriptionName $subsc_name 
    $subscriptionId = $subs.Id
    $subscriptionName = $subs.Name
    Set-AzContext -SubscriptionId $subscriptionId
    
    
    Get-AzResourceGroup | ForEach-Object{
        $resourceGroupName = $_.ResourceGroupName
       
    Get-AzFunctionApp -ResourceGroupName $resourceGroupName | ForEach-Object{

    $hostname = $_.DefaultHostName
    $State = $_.State
    $functionappVersion = $_.ApplicationSettings.FUNCTIONS_EXTENSION_VERSION
    $TLS_Version = $_.SiteConfig.MinTlsVersion

    

    "$subscriptionName,$subscriptionId,$resourceGroupName,$hostname,$State,$functionappVersion,$TLS_Version" | Out-File $oFile -Append -Encoding ascii
       
       }
        }

        
    Write-Host "script executed successfully"

 #(Get-AzFunctionApp).ApplicationSettings.FUNCTIONS_EXTENSION_VERSION
 #(Get-AzFunctionApp).SiteConfig.MinTlsVersion
 #(Get-AzFunctionApp).ApplicationSettings
