## 指派 Role 給特定帳號 ##
$AssignAccount = "Guest1@virex.online"
# New-AzRoleAssignment -SignInName $AssignAccount -RoleDefinitionName "Contributor" -ResourceGroupName $RGName
New-AzRoleAssignment -SignInName $AssignAccount -RoleDefinitionName "Contributor" -Scope $vm.id 
echo "ok!"