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
        $pattern = "(\\[abcdABCD]{1})"+"("+$_.Key+"{1})"       
        #es ist ein translate code und nichts anderes.
        if ($line -match $pattern)             
            
            {
                $line = $line -replace $_.Key , $_.Value  
            }
    }
   $line
} | Set-Content -Path $destination_file