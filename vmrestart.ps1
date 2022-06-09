connect-azAccount
Get-AzSubscription | ForEach-Object{
$subscriptionId = $_.Id
$subscriptionName = $_.Name
Set-AzContext -SubscriptionId $subscriptionId
Get-AzResourceGroup | ForEach-Object{
$resourceGroupName = $_.ResourceGroupName
#Restart Azure VMs
$vms = Get-AzVM -ResourceGroupName $resourceGroupName 
foreach ($vm in $vms){

Start-Sleep 900
Restart-AzVM -Name $vm -ResourceGroupName $resourceGroupName

}


}
}
