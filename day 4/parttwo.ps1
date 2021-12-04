$inputs = Get-Content input.txt

$callednumbers = [int[]](($inputs | Select-Object -First 1) -split ",")

$boardtext = $inputs | Select-Object -Skip 2

class BingoBoard {
	[int[,]]$board = (New-Object 'int[,]' 5,5)
	[bool[,]]$called = (New-Object 'bool[,]' 5,5)
	
	BingoBoard() {
		for ($j = 0;$j -lt 5;$j++) {
			for ($i = 0;$i -lt 5;$i++) {
				$this.board[$i,$j] = 0
				$this.called[$i,$j] = $false
			}
		}
	}
	
	[void]CallNumber([int]$number) {
		for ($j = 0;$j -lt 5;$j++) {
			for ($i = 0;$i -lt 5;$i++) {
				if ($this.board[$i,$j] -eq $number) {
					$this.called[$i,$j] = $true
				}
			}
		}
	}
	
	[bool]IsBingo() {
		$returnvalue = $false
		for ($i = 0;$i -lt 5;$i++) {
			if ($this.called[$i,0] -and $this.called[$i,1] -and $this.called[$i,2] -and $this.called[$i,3] -and $this.called[$i,4]) {
				$returnvalue = $true
			}
			if ($this.called[0,$i] -and $this.called[1,$i] -and $this.called[2,$i] -and $this.called[3,$i] -and $this.called[4,$i]) {
				$returnvalue = $true
			}
		}
		return $returnvalue
	}
}

$inputboards = [BingoBoard[]]@()

$firstline = $true
foreach ($line in $boardtext) {
	# is it the first line of a board?
	if ($firstline) {
		$currentboard = $null
		$currentboard = New-Object BingoBoard
		$firstline = $false
		$j = 0
	}
	# is it a blank line?
	if ($line -eq "") {
		# board complete
		$inputboards += $currentboard
		$firstline = $true
		continue
	}
	$array = [int[]]($line.Trim() -replace "  "," " -split " ")
	for ($i = 0;$i -lt 5;$i++) {
		$currentboard.board[$i,$j] = $array[$i]
	}
	$j++
}

# call the numbers
$result = 0
$winsequence = [int[]]@()
$numwinners = 0
foreach ($number in $callednumbers) {
	for ($i = 0;$i -lt $inputboards.Count;$i++) {
		$inputboards[$i].CallNumber($number)
	}
	for ($i = 0;$i -lt $inputboards.Count;$i++) {
		if ($inputboards[$i].IsBingo()) {
			if ($winsequence -notcontains $i) {
				$winsequence += $i
				$numwinners++
			}
		}
	}
	if ($numwinners -eq $inputboards.Count) {
		break
	}
	# $bingo = $null
	# $bingo = $inputboards | Where-Object {$_.IsBingo()}
	# if ($bingo -ne $null) {
		# # sum of all uncalled numbers
		# $uncalled = 0
		# for ($j = 0;$j -lt 5;$j++) {
			# for ($i = 0;$i -lt 5;$i++) {
				# if (!$bingo.called[$i,$j]) {
					# $uncalled += $bingo.board[$i,$j]
				# }
			# }
		# }
		# # times the number that was just called
		# $result = $uncalled * $number
		# break
	# }
}

$lastwinner = $inputboards[($winsequence | Select-Object -Last 1)]
# sum of all uncalled numbers
$uncalled = 0
for ($j = 0;$j -lt 5;$j++) {
	for ($i = 0;$i -lt 5;$i++) {
		if (!$lastwinner.called[$i,$j]) {
			$uncalled += $lastwinner.board[$i,$j]
		}
	}
}
# times the number that was just called
$result = $uncalled * $number

$result