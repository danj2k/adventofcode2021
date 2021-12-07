$inputs = [int[]]((Get-Content input.txt) -split ',')

# determine the maximum position
$maxpos = ($inputs | Measure-Object -Maximum).Maximum

$bestfuel = [int32]::MaxValue
$bestpos = -999
for ($i = 0;$i -le $maxpos;$i++) {
	# calculate fuel expenditure of current position
	$fuel = 0
	foreach ($crab in $inputs) {
		$n = [Math]::Abs($crab - $i)
		# using the formula n * (n+1) / 2
		$fuel += $n * ($n + 1) / 2
	}
	# is it better than the best previously detected outcome?
	if ($fuel -lt $bestfuel) {
		$bestfuel = $fuel
		$bestpos = $i
	}
}

$bestfuel