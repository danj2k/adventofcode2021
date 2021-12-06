$inputs = Get-Content input.txt

$fisharray = [int[]]($inputs -split ",")

# group fish by timer
$shoal = New-Object 'int64[]' 9

# initialise shoal
for ($i = 0;$i -lt 9;$i++) {
	$shoal[$i] = 0
}

# read in fish input
foreach ($fish in $fisharray) {
	$shoal[$fish]++
}

# simulate 256 days
for ($day=0;$day -lt 256;$day++) {
	$daypercent = [int](($day+1)*100/256)
	$currentfishcount = ($shoal | Measure-Object -Sum).Sum
	Write-Progress -Activity "Simulating lanternfish..." -PercentComplete $daypercent -CurrentOperation "Day $($day+1) of 256 ($currentfishcount lanternfish)"
	$newfish = $shoal[0]
	for ($i = 1;$i -lt 9;$i++) {
		$shoal[$i-1]=$shoal[$i]
	}
	$shoal[8] = $newfish
	$shoal[6] += $newfish
}

Write-Progress -Activity "Simulating lanternfish..." -Completed
$finalfishcount = ($shoal | Measure-Object -Sum).Sum

$finalfishcount