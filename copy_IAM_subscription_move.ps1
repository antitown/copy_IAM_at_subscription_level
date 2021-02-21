#testing parameters, Value should be ignore
$sub_id = "123456789"
$rs_maping = import-csv -path .\rs_mapping.csv
$export = import-Csv -path .\input.csv

if ($args.Count -lt 3)
{
    write-host "please include the followings as parameters
    1) destination subscription ID
    2) Resource Name mapping CSV
    3) Export IAM in CSV from the original subscription
    4) optional - put execute if you wan to the script to execute the command on Azure.
        *You need to authenticate on Azure with the right privallege"
    exit
 }


foreach ($e in $export)
{
   
   # get Scope
   $scope = ($e | Select -ExpandProperty Scope)
   $org_sub = $scope.substring(15, 36)
   $rstype = $scope.substring(0, $scope.lastindexof('/'))
   $rstype = $rstype.substring($rstype.lastindexof('/')+1,($rstype.Length-$rstype.lastindexof('/')-1))
  
   $rsname = $scope.substring($scope.lastindexof('/')+1, ($scope.Length - $scope.lastindexof('/')-1))

   $scope= $scope -replace $org_sub,$sub_id
   #get new RS Name & replace scope String
  
   foreach ($N in $rs_maping)
   {

        
        if ($rsname -eq ($N | Select -ExpandProperty Org))
        {
            $rsname = ($N | Select -ExpandProperty New)
            $scope = $scope -replace ($N | Select -ExpandProperty Org),($N | Select -ExpandProperty New)
            break
        }
   }

   

    # get SignInName
   $signinname = ($e | Select -ExpandProperty SignInName)

   
   # get Role Definition Nmae 
   $Role = ($e | Select -ExpandProperty RoleDefinitionName)
 

   #Generating output or execute the assignment
   if  ($rstype -eq "resourceGroups")
   {
       write-host "New-AzRoleAssignment -SignInName " $signinname "-RoleDefinitName " $Role "-ResourceGroup " $rsname
       if ($args.Length -lt 3) 
       {
           if($args[3] -eq "execute"){
           New-AzRoleAssignment -SignInName $signinname -RoleDefinitName $Role -ResourceGroup $rsname }
        }
    }else
    {    
        
       write-host "New-AzRoleAssignment -SignInName " $signinname "-RoleDefinitName " $Role "-Scope " $str $rstype
       if ($args.Length -lt 3) 
       {
           if($args[3] -eq "execute"){
       New-AzRoleAssignment -SignInName $signinname -RoleDefinitName $Role -Scope $str $rstype}
       }
    } 
    
}
