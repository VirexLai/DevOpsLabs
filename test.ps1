## 設定變數 ##
$location = "Japan East" 
$RGName = "TestRG"
$VNetName = "TestVNet"
$VNetRagne = "11.0.0.0/16"
$NSGName = "TestNSG"
$VSubNetName = "TestVSubNet"
$VSubNetRange = "11.0.0.0/24"

## 新增資源群組 ##
New-AzResourceGroup -Name "TestRG" -Location "Japan East"

## 新增虛擬網路 ##
New-AzVirtualNetwork -ResourceGroupName $RGName -Name $VNetName -Location $location -AddressPrefix $VNetRagne

## 紀錄 VNetID ##
$VNet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $RGName
$VNetID = $VNet.ID

## 新增子網路 ##
Add-AzVirtualNetworkSubnetConfig -Name $VSubNetName -VirtualNetwork $VNet -AddressPrefix $VSubNetRange

## 將子網路與虛擬網路建立關聯 ##
Set-AzVirtualNetwork -VirtualNetwork $VNet

## 建立網路安全群組 ##
New-AzNetworkSecurityGroup -Name $NSGName -ResourceGroupName $RGName  -Location $location

## 紀錄網路安全組 ID ##
$NSGID = Get-AzNetworkSecurityGroup -Name $NSGName -ResourceGroupName $RGName

## 將網路安全組與子網建立關聯 ##
Set-AzVirtualNetworkSubnetConfig -Name $VSubNetName -VirtualNetwork $VNet -AddressPrefix $VSubNetRange -NetworkSecurityGroup $NSGID
Set-AzVirtualNetwork -VirtualNetwork $VNet

## 紀錄子網路 ID ##???????????????
$VSubNet = $VNet.Subnets[0]
## $VSubNetID = $VSubNet.ID
$VSubNetID = (Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $RGName).subnets.id
echo $VSubNetID

## 設定 VM 參數##

$VMName = "TestVM"
$VMSize = "Standard_D2s_v3"
$ComputerName = "TestPC"
$SecurityTypeStnd = "Standard"
        
## 設定 VM 本機端帳號密碼 ##
$user = "Virex"
$securePassword = ConvertTo-SecureString -String "Def@ultPassw0rd" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword)
        
## Creating a VMConfig ## 
$vmconfig = New-AzVMConfig -VMName $VMName -VMSize $VMSize -SecurityType $SecurityTypeStnd

## 設定 OS 映像檔 ##
$publisherName = "microsoftwindowsdesktop"
$offer = "windows-11"
$sku = "win11-22h2-entn"
$vmconfig = Set-AzVMSourceImage -VM $vmconfig -PublisherName $publisherName -Offer $offer -Skus $sku -Version 'latest'

## 建立 Public IP ##
$PubIPName = "TestPIP"
$PubIP = New-AzPublicIpAddress -Force -Name $PubIPName -ResourceGroupName $RGName -Location $location -AllocationMethod Static
$PubIP = Get-AzPublicIpAddress -Name $PubIPName -ResourceGroupName $RGName
$PubIPID = $PubIP.ID

## 建立 NIC ##
$VSubNetID = (Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $RGName).subnets.id
echo $VSubNetID
$NICName = "TestNIC"
$NIC = New-AzNetworkInterface -Force -Name $NICName -ResourceGroupName $RGName -Location $location -SubnetID $VSubNetID -PublicIpAddressID $PubIPID
$NIC = Get-AzNetworkInterface -Name $NICName -ResourceGroupName $RGName
$NICID = $NIC.ID

$vmconfig = Add-AzVMNetworkInterface -VM $vmconfig -ID $NICID
$vmconfig = Set-AzVMOperatingSystem -VM $vmconfig -Windows -ComputerName $ComputerName -Credential $cred

## 建立 VM ##
New-AzVM -ResourceGroupName $RGName -Location $location -Vm $vmconfig
$vm = Get-AzVM -ResourceGroupName $RGName -Name $VMName
echo $vm

## 指派 Role 給特定帳號 ##
$AssignAccount = "Guest1@virex.online"
# New-AzRoleAssignment -SignInName $AssignAccount -RoleDefinitionName "Contributor" -ResourceGroupName $RGName
New-AzRoleAssignment -SignInName $AssignAccount -RoleDefinitionName "Contributor" -Scope $vm.id 
echo "ok!"
