# copy_IAM_at_subscription_level
This scripts generate the neccesary command to perform IAM assignment from an IAM export of a subscription that including the childs.
This will handy when moving resources from one subscripition to another as IAM would not be carry over during the move.
Here is the parameters required to run the scripts

    1) destination subscription ID
    2) Resource Name mapping CSV - As resourceGroup name cannot retain the same in the new subscription, this file provide the updated name.
    3) Export IAM in CSV from the original subscription - simply export from the source subscription on the Azure portal
    4) optional - put execute if you wan to the script to execute the command on Azure.
        *You need to authenticate on Azure with the right privallege 



 
