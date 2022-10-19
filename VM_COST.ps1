$StartDay="2022-10-10"
 $EndDay="2022-10-19"
$subscription = "ae0e4f48-d135-461b-9843-7fedb6491d49"
connect-azAccount
$subscription = "ae0e4f48-d135-461b-9843-7fedb6491d49"
$file="C:\temp\GeneratedCost-short.csv"
$costTotal=0
$VMs = @()
$Subscriptions = Get-AzSubscription -SubscriptionId $subscription
foreach ($sub in $Subscriptions) {
    Get-AzSubscription -SubscriptionName $sub.Name | az account set -s $sub.Name
    $VMs += (az consumption usage list --start-date $StartDay --end-date $EndDay | ConvertFrom-Json)
    }

$Costs = $VMs.PretaxCost
 $VMs.UsageQuantity
    
 foreach ($Cost in $Costs) { $CostTotal += $Cost} 

$VMs | Where-Object {$_.consumedService -Match "Microsoft.Compute"} |
    Sort-Object -Property instanceName -Descending |
        Select-Object instanceName, subscriptionName, PretaxCost, UsageQuantity |
            Get-Unique -AsString | ConvertTo-Csv -NoTypeInformation |
                Set-Content $file
Write-Host "total cost is  $CostTotal"
