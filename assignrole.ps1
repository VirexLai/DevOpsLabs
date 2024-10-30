## 從 YAML 內建立的 ResourceGroup 找出 VM 並儲存資訊 ## 
$vm = Get-AzVM -ResourceGroupName ${env:RGNAME} 

## 指派 Role 給特定帳號 ##
$AssignAccount = "Guest1@virex.online"

## 計算 vm 數量 ##
$vmnum = $vm.id.count

## 指派 Role ##
if (1 -eq $vmnum) {New-AzRoleAssignment -SignInName $AssignAccount -RoleDefinitionName "Contributor" -Scope $vm.id} else{for ( $i=0 ; $i -lt $vmnum ; $i++ ){New-AzRoleAssignment -SignInName $AssignAccount -RoleDefinitionName "Contributor" -Scope $vm.id[$i]}}

echo "DONE"
