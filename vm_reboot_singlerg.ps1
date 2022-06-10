connect-azAccount
$RG = "DEMO-JUMP-RG"
$sub = Get-AzSubscription -SubscriptionId 'ed4b07b6-a9ea-407f-b280-fb9008f2d861' 
$subscriptionId = $sub.Id
$subscriptionName = $sub.Name
Set-AzContext -SubscriptionId $subscriptionId
$res = Get-AzResourceGroup -Name $RG
$resourceGroupName = $res.ResourceGroupName
#Restart Azure VMs
$vms = Get-AzVM -ResourceGroupName $resourceGroupName 
foreach ($vm in $vms){
Write-host ""$vm.name" is restart rebooting" -ForegroundColor Green
Start-Sleep 900
Restart-AzVM -Name "$vm.name" -ResourceGroupName $resourceGroupName

}

Write-host "script executed successfully" -ForegroundColor Cyan

