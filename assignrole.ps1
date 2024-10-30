## 從 YAML 內建立的 ResourceGroup 找出 VM 並儲存資訊 ## 
$vm = "TEST ECHO"
echo $vm

$vm = Get-AzVM -ResourceGroupName ${env:RGNAME} 

echo "vm info here"
echo $vm

## 指派 Role 給特定帳號 ##
$AssignAccount = "Guest1@virex.online"

echo "Account info here"
echo $AssignAccount

## 計算 vm 數量 ##
$vmnum = $vm.id.count

echo "vm numbers here"
echo $vmnum

## 指派 Role ##
for($i = 0; $i -le $vmnum ; $i++)
{
    New-AzRoleAssignment -SignInName $AssignAccount -RoleDefinitionName "Contributor" -Scope $vm.id[$i] 
    echo "i number is..."
    echo $i
}
