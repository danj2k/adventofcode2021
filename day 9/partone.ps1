$inputs = Get-Content input.txt

# find dimensions of map
$maxy = [int]($inputs.Count)
$maxx = [int](($inputs | Foreach-Object {$_.Length}) | Measure-Object -Maximum).Maximum

# initialise map
$map = New-Object 'int[,]' $maxx,$maxy
for ($y=0;$y -lt $maxy;$y++) {
	$line = $inputs[$y].ToCharArray()
	for ($x=0;$x -lt $maxx;$x++) {
		$map[$x,$y] = [System.Convert]::ToInt32($line[$x].ToString())
	}
}

# check for low points
Add-Type -AssemblyName System.Drawing
$lowpoints = @()
for ($y=0;$y -lt $maxy;$y++) {
	for ($x=0;$x -lt $maxx;$x++) {
		$isLowPoint = $true
		# check left
		if ($x -gt 0 -and $map[($x - 1),$y] -le $map[$x,$y]) {
			$isLowPoint = $false
		}
		# check right
		if ($x -lt ($maxx - 1) -and $map[($x + 1),$y] -le $map[$x,$y]) {
			$isLowPoint = $false
		}
		# check above
		if ($y -gt 0 -and $map[$x,($y - 1)] -le $map[$x,$y]) {
			$isLowPoint = $false
		}
		# check below
		if ($y -lt ($maxy - 1) -and $map[$x,($y + 1)] -le $map[$x,$y]) {
			$isLowPoint = $false
		}
		# is it a low point?
		if ($isLowPoint) {
			$point = New-Object System.Drawing.Point($x,$y)
			$lowpoints += $point
		}
	}
}

# compute risk level sum
$risklevelsum = 0
foreach ($point in $lowpoints) {
	$risklevel = $map[$point.X,$point.Y]+1
	$risklevelsum += $risklevel
}

$risklevelsum
