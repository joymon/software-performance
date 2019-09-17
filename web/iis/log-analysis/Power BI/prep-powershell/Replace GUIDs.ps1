$input = "C:\temp\KCw\Aug2019\Load Testing\TOR 9\Run 3 After Web205 restart"

$guid_regex = "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"
Get-ChildItem $input -Filter *.log | 
Foreach-Object {
    $inputFile = $_.FullName
    ((Get-Content -path $inputFile -Raw) -replace  $guid_regex,'{guid}') | Set-Content -Path $inputFile
    "Replaced GUIDs with {guid} in " + $inputFile
} 

