$reportName = "List_Of_All_Azure_Resources_$($date).csv"
if(Test-Path $reportName){
    Remove-Item $reportName -Force
}
(Get-AzSubscription)|ForEach-Object{
 
 Select-AzSubscription $_

$report = @()
$vms = Get-AzVM
$publicIps = Get-AzPublicIpAddress 
$nics = Get-AzNetworkInterface | ?{ $_.VirtualMachine -NE $null}
foreach ($nic in $nics) { 
    $info = "" | Select-Object SubscriptionName, VmName, ResourceGroupName, Region, VirturalNetwork, Subnet, PrivateIpAddress, NIC, NSG, OsType, PublicIPAddress, VmSize, OsDiskName, OsDiskSize, OsPublisher, OsOffer, OsSku, Osversion, OsExactVersion, cpu, RAM
    $vm = $vms | ? -Property Id -eq $nic.VirtualMachine.id 
    foreach($publicIp in $publicIps) { 
        if($nic.IpConfigurations.id -eq $publicIp.ipconfiguration.Id) {
            $info.PublicIPAddress = $publicIp.ipaddress
            } 
        }
        $info.SubscriptionName=$_.Name 
        $info.OsType = $vm.StorageProfile.OsDisk.OsType 
        $info.VMName = $vm.Name 
        $info.ResourceGroupName = $vm.ResourceGroupName 
        $info.Region = $vm.Location 
        $info.VirturalNetwork = $nic.IpConfigurations.subnet.Id.Split("/")[-3] 
        $info.Subnet = $nic.IpConfigurations.subnet.Id.Split("/")[-1] 
        $info.PrivateIpAddress = $nic.IpConfigurations.PrivateIpAddress
        $info.NIC=$nic.Name
        $info.NSG = $nic.NetworkSecurityGroup
        $info.VmSize = $vm.HardwareProfile.VmSize
        $info.OsDiskName = $vm.StorageProfile.OsDisk.Name
        $info.OsDiskSize = $vm.StorageProfile.OsDisk.DiskSizeGB
        $info.OsPublisher = $vm.StorageProfile.ImageReference.Publisher
        $info.OsOffer = $vm.StorageProfile.ImageReference.Offer
        $info.OsSku = $vm.StorageProfile.ImageReference.Sku
        $info.Osversion = $vm.StorageProfile.ImageReference.Version
        $info.OsExactVersion = $vm.StorageProfile.ImageReference.ExactVersion
        Get-AzVMSize -VMName $vm.Name -ResourceGroupName $vm.ResourceGroupName | where{$_.Name -eq $($vm.HardwareProfile.VmSize)} | ForEach-Object{
        $info.cpu = $_.NumberOfCores
        $info.RAM = $($_.MemoryInMB)/1024
        }
        $report+=$info 
    } 
    
$report | Export-CSV "$home\$reportName" -NoTypeInformation -Append

}
