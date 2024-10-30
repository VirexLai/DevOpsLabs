$vm = Get-AzVM -ResourceGroupName  ${env:RGNAME} 

## 指派 Role 給特定帳號 ##
$AssignAccount = "Guest1@virex.online"

## 計算 vm 數量 ##
$vmnum = $vm.id.count

## 指派 Role ##
for($i = 0; $i -le $vmnum ; $i++)
{
    New-AzRoleAssignment -SignInName $AssignAccount -RoleDefinitionName "Contributor" -Scope $vm.id[$i]
}
