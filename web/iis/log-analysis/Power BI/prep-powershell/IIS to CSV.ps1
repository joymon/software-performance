cls
$inputPath = "<folder which contains .log files>"
$outExt = ".csv" 
$pathToLogParser= "C:\Program Files (x86)\Log Parser 2.2\logparser"
Get-ChildItem $inputPath -Filter *.log | 
Foreach-Object {
 $inFile = $_.FullName
 "Starting " + $inFile
 $outFile =  $_.FullName -replace "\.log",".csv"
 $outFile
 $cmd = "SELECT date, time, s-ip, cs-method, cs-uri-stem, cs-uri-query, s-port, cs-username, c-ip, cs(User-Agent) as cs-user-agent, sc-status, sc-substatus, sc-win32-status,sc-bytes,cs-bytes, time-taken INTO '"+$outFile+"' FROM '"+$inFile+"'"
 #$cmd
 $output =  & "C:\Program Files (x86)\Log Parser 2.2\logparser" -i:W3C -o:csv $cmd | Out-String
 "Output of first conversion " +$output.Length + ". If it is 0, it will rerun with less fields. This takes long time based on log size. Make sure sc-bytes or cs-bytes columns available in IISLogs."
 
 # Hack in case the log file dont have  as those are not enabled by default.
 # TODO move the default logic to PowerBI if possible.
 
 if ($output.Length -eq 0) {
    #There may be missing columns such as sc-bytes, cs-bytes. Rerun without those fields & Add default value 0
    $cmd = "SELECT date, time, s-ip, cs-method, cs-uri-stem, cs-uri-query, s-port, cs-username, c-ip, cs(User-Agent) as cs-user-agent, sc-status, sc-substatus, sc-win32-status, time-taken INTO '"+$outFile+"' FROM '"+$inFile+"'"
    $output =  & $pathToLogParser -i:W3C -o:csv $cmd | Out-String
    "output of rerun is " +$output.Length + ". Starting addition of missing columns"
    $csv = Import-Csv -Path $outFile 
    "Parsed CSV into PowerShell"
    $csv =  $csv | Select-Object date,time, s-ip,cs-method,cs-uri-stem, cs-uri-query, s-port, cs-username, c-ip, cs-User-Agent, sc-status, sc-substatus, sc-win32-status,sc-bytes,cs-bytes,time-taken 
    "Added missing columns"
    $csv | Export-Csv $outFile -NoTypeInformation
    "Completed column addition " + $inFile
    
 }else {
 "Completed file " + $inFile
 }
}
"completed all files"
