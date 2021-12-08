$inputs = Get-Content input.txt

# we only care about stuff after the break
$outputs = $inputs | Foreach-Object {($_ -split " \| ")[1]}

# string lengths for digits 1, 4, 7, 8
$lengths = 2, 4, 3, 7

$count = 0
foreach ($line in $outputs) {
	foreach ($digit in ($line -split ' ')) {
		if ($lengths -contains $digit.Length) {
			$count++
		}
	}
}

$count