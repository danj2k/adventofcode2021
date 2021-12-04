$ograting = $inputs; $co2rating = $inputs; $newograting = $null; $newco2rating = $null
for ($i = 0;$i -lt 12; $i++) {
  $ogzeroes = ($ograting | Where-Object {$_.SubString($i,1) -eq "0"}).Count
  if ($ogzeroes -eq $null) {$ogzeroes = 0}
  $ogones = ($ograting | Where-Object {$_.SubString($i,1) -eq "1"}).Count
  if ($ogones -eq $null) {$ogones = 0}
  if ($ograting.Count -gt 1) {
    if ($ogones -ge $ogzeroes) {
      $newograting = $ograting | Where-Object {$_.SubString($i,1) -eq "1"}
    } elseif ($ogzeroes -gt $ogones) {
      $newograting = $ograting | Where-Object {$_.SubString($i,1) -eq "0"}
    }
  }
  $co2zeroes = ($co2rating | Where-Object {$_.SubString($i,1) -eq "0"}).Count
  if ($co2zeroes -eq $null) {$co2zeroes = 0}
  $co2ones = ($co2rating | Where-Object {$_.SubString($i,1) -eq "1"}).Count
  if ($co2ones -eq $null) {$co2zeroes = 0}
  if ($co2rating.Count -gt 1) {
    if ($co2ones -lt $co2zeroes) {
      $newco2rating = $co2rating | Where-Object {$_.SubString($i,1) -eq "1"}
    } elseif ($co2zeroes -le $co2ones) {
      $newco2rating = $co2rating | Where-Object {$_.SubString($i,1) -eq "0"}
    }
  }
  if ($newograting -ne $null) { $ograting = $newograting }
  if ($newco2rating -ne $null) { $co2rating = $newco2rating }
}
[Convert]::ToInt32($ograting,2) * [Convert]::ToInt32($co2rating,2)
