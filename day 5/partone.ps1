class Line {
	[int]$x1
	[int]$y1
	[int]$x2
	[int]$y2
	
	Line() {
		$this.x1=0
		$this.y1=0
		$this.x2=0
		$this.y2=0
	}
}

$inputs = Get-Content input.txt

$biggestx = 0
$biggesty = 0
$inputlines = [Line[]]@()
# determine dimensions of map
foreach ($line in $inputs) {
	$coordinates = [int[]]($line.Replace(" -> ",",") -split ",") # coordinates are x1,y1,x2,y2
	if ($coordinates[0] -gt $biggestx) {
		$biggestx = $coordinates[0]
	}
	if ($coordinates[1] -gt $biggesty) {
		$biggesty = $coordinates[1]
	}
	if ($coordinates[2] -gt $biggestx) {
		$biggestx = $coordinates[2]
	}
	if ($coordinates[3] -gt $biggesty) {
		$biggesty = $coordinates[3]
	}
	$thisline = New-Object Line
	$thisline.x1 = $coordinates[0]
	$thisline.y1 = $coordinates[1]
	$thisline.x2 = $coordinates[2]
	$thisline.y2 = $coordinates[3]
	if ($thisline.x1 -eq $thisline.x2 -or $thisline.y1 -eq $thisline.y2) {
		# add line to be considered
		$inputlines += $thisline
	}
}
$biggestx++
$biggesty++
$map = New-Object 'int[,]' $biggestx,$biggesty
# initialise map
for ($y=0;$y -lt $biggesty;$y++) {
	for ($x=0;$x -lt $biggestx;$x++) {
		$map[$x,$y]=0
	}
}
# iterate through lines
$line = $null
foreach ($line in $inputlines) {
	if ($line.x1 -eq $line.x2) {
		$x = $line.x1
		if ($line.y2 -gt $line.y1) {
			$start = $line.y1
			$end = $line.y2
		} else {
			$start = $line.y2
			$end = $line.y1
		}
		for ($y=$start;$y -le $end;$y++) {
			$map[$x,$y]++
		}
	} elseif ($line.y1 -eq $line.y2) {
		$y = $line.y1
		if ($line.x2 -gt $line.x1) {
			$start = $line.x1
			$end = $line.x2
		} else {
			$start = $line.x2
			$end = $line.x1
		}
		for ($x=$start;$x -le $end;$x++) {
			$map[$x,$y]++
		}
	}
}
# now see how many are 2 or more
$count = 0
foreach ($point in $map) {
	if ($point -gt 1) {
		$count++
	}
}

$count