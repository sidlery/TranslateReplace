$path = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

$original_file = $path+'\*.asc'
$destination_file =  $path+'\replaced.txt'

$csvImport = Import-Csv -Path $path'\*.csv' -Header "col1","col2" -Delimiter ";"
$HashTable = @{}
foreach($r in $csvImport)
{
	$HashTable[$r.col1] = $r.col2
}


Get-Content -Path $original_file | ForEach-Object {
    $line = $_
    $HashTable.GetEnumerator() | ForEach-Object {
        $pattern = "(?<code>\\[abcdABCD]{1})"+"(?<key>"+$_.Key+"{1})"       
        #es ist ein translate code und nichts anderes.
        if ($line -match $pattern)             
  
            {
                $line = $line -replace "($matches.code.ToString()$matches.key.ToString())","($matches.code.ToString()$_.Value.ToString())"
                Write-Host $matches.code.ToString()$_.Value.ToString()
            }
    }
   $line
} | Set-Content -Path $destination_file