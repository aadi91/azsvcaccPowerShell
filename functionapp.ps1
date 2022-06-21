$subsc_name = 'Azure subscription 1'
connect-azAccount -Subscription $subsc_name
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
 
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
 
"SUBSCRIPTION_NAME,SUBSCRIPTION_ID,RESOURCE_GROUP_NAME,HOSTNAME,STATE,ClientAffinity,Client_Certificate,HTTP_only,KIND,VIRTUAL_APPLIANCE,HTTP_LOGIN_ENABLE,VNET,LOAD_BALANCING,RemoteDebuggingEnabled,APPSERVICE_PLAN" | Out-File $oFile -Append -Encoding ascii
 
$subs = Get-AzSubscription -SubscriptionName $subsc_name 
    $subscriptionId = $subs.Id
    $subscriptionName = $subs.Name
    Set-AzContext -SubscriptionId $subscriptionId
    
    
    Get-AzResourceGroup | ForEach-Object{
        $resourceGroupName = $_.ResourceGroupName
       
    Get-AzFunctionApp -ResourceGroupName $resourceGroupName | ForEach-Object{

    $hostname = $_.HostNames
    $State = $_.State
    $ClientAffinityEnabled = $_.ClientAffinityEnabled
    $ClientCertEnabled = $_.ClientCertEnabled
    $HttpsOnly = $_.HttpsOnly
    $kind = $_.Kind
    $va = $_.SiteConfig.VirtualApplication.PreloadEnabled
    $httploginenable = $_.SiteConfig.HttpLoggingEnabled
    $vnet = $_.SiteConfig.VnetName
    $lb = $_.SiteConfig.LoadBalancing
    $rDebugg =$_.SiteConfig.RemoteDebuggingEnabled
    $appplanename = $_.AppServicePlan
    

    "$subscriptionName,$subscriptionId,$resourceGroupName,$hostname,$State,$ClientAffinityEnabled,$ClientCertEnabled,$HttpsOnly,$kind,$va,$httploginenable,$vnet,$lb,$rDebugg,$appplanename" | Out-File $oFile -Append -Encoding ascii
       
       }
        }

        
    Write-Host "script executed successfully"

 (Get-AzFunctionApp).SiteConfig
 (Get-AzFunctionApp).SiteConfig.VirtualApplication.PreloadEnabled
