#Author: Jeff Miles
#Source: https://faultbucket.ca/2019/05/get-azure-vm-uptime-sorta/

Select-AzSubscription 
$comparedate = (get-date).AddDays(-14)
$rg = "resourcegroup"
#Get the Instance view of a collection of virtual machines (returns the PowerState property)
$vms = get-azvm -status -resourcegroup $rg
 
#Iterate through the collection
foreach ($vm in $vms)
{
	# only check if the VM is running, because if it's off we don't care
	if ($vm.powerstate -ceq "VM running")
	{
		# Get the instance view of a single virtual machine (returns the "statuses" object)
		$foundvm = get-azvm -resourcegroup $vm.ResourceGroupName -name $vm.Name -status
		    #$foundvm.Statuses.Time
                # check if time since it was provisioned (in Statuses[0]) is greater than a value
		if ($foundvm.Statuses.Time -le $comparedate)
		{
			write-output "$($foundvm.name) : running longer than 14 days"
		}
	}
}
