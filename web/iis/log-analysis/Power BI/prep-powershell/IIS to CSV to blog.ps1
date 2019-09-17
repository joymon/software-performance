cls
$input = ":\temp\Test large IIS logs\Test Logs"
$input = "C:\temp\Test large IIS logs\IISLogs"
$input = "C:\inetpub\logs\LogFiles\W3SVC1"
$input = "C:\temp\KCw\Aug2019\Load Testing\TOR 9\Run 3 After Web205 restart"
$outExt = ".csv" 
Get-ChildItem $input -Filter *.log | 
Foreach-Object {
 $inFile = $_.FullName
 #$inFile

 $outFile =  $_.FullName -replace "\.log",".csv"
 $outFile
 $cmd = "SELECT Logfilename,date,OUT_ROW_NUMBER() AS RowNumber, time, s-ip, cs-method, cs-uri-stem, cs-uri-query, s-port, cs-username, c-ip, cs(User-Agent) as cs-user-agent, sc-status, sc-substatus, sc-win32-status,sc-bytes,cs-bytes, time-taken INTO '"+$outFile+"' FROM '"+$inFile+"'"
 #$cmd
 $output =  & "C:\Program Files (x86)\Log Parser 2.2\logparser" -i:W3C -o:csv $cmd | Out-String
 "output is " +$output.Length
 # Hack in case the log file dont have sc-bytes or cs-bytes columns as those are not enabled by default.
 # TODO move the default logic to PowerBI if possible.
 # Warning The below step takes time if the log size > 100 MB as PowerShell take time to write. Better make sure the IIS log files have cs-bytes & sc-bytes
 if ($output.Length -eq 0) {
    #There may be missing columns such as sc-bytes, cs-bytes. Rerun without those fields & Add default value 0
    $cmd = "SELECT Logfilename,date,OUT_ROW_NUMBER() AS RowNumber, time, s-ip, cs-method, cs-uri-stem, cs-uri-query, s-port, cs-username, c-ip, cs(User-Agent) as cs-user-agent, sc-status, sc-substatus, sc-win32-status, time-taken INTO '"+$outFile+"' FROM '"+$inFile+"'"
    $output =  & "C:\Program Files (x86)\Log Parser 2.2\logparser" -i:W3C -o:csv $cmd | Out-String
    "output of rerun is " +$output.Length
    $csv = Import-Csv -Path $outFile 
    $csv =  $csv | Select-Object LogFileName,RowNumber,time,date, s-ip,cs-method,cs-uri-stem, cs-uri-query, s-port, cs-username, c-ip, cs-User-Agent, sc-status, sc-substatus, sc-win32-status,sc-bytes,cs-bytes,time-taken 
    $csv | Export-Csv $outFile -NoTypeInformation
 }
}



