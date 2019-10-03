################################# Input to be changed ###########################################
$inputPath = "<folder which contains .log files>"


########################### Change only if needed in environment ################################
$pathToLogParserExe= "C:\Program Files (x86)\Log Parser 2.2\logparser"

################################ DO NOT CHANGE ##################################################
$outExt = ".csv"
Get-ChildItem $inputPath -Filter *.log | 
Foreach-Object {
    $inFile = $_.FullName
    "Starting " + $inFile
    $outFile =  $_.FullName -replace "\.log",".csv"
    $cmd = "SELECT date, time, s-ip, cs-method, cs-uri-stem, cs-uri-query, s-port, cs-username, c-ip, cs(User-Agent) as cs-user-agent, sc-status, sc-substatus, sc-win32-status,sc-bytes,cs-bytes, time-taken INTO '"+$outFile+"' FROM '"+$inFile+"'"
    
    $output =  & $pathToLogParserExe -i:W3C -o:csv $cmd | Out-String
    
    "Output of first conversion " +$output.Length + ". If it is 0, it will rerun to include missing fields with default values. Make sure sc-bytes or cs-bytes columns available in IISLogs."
 
    # Hack in case the log file dont have all fields it will rerun to include those with default values. Mainly it happens for sc-bytes, cs-bytes as those are not enabled by default.
    # TODO move the default logic to PowerBI if possible.
 
    if ($output.Length -eq 0) {
        #There may be missing columns such as sc-bytes, cs-bytes. Rerun without those fields & Add default value 0
        $cmd = "SELECT date, time, s-ip, cs-method, cs-uri-stem, cs-uri-query, s-port, cs-username, c-ip, cs(User-Agent) as cs-user-agent, sc-status, sc-substatus, sc-win32-status,0 as sc-bytes,0 as cs-bytes, time-taken INTO '"+$outFile+"' FROM '"+$inFile+"'"
        
        $output =  & $pathToLogParserExe -i:W3C -o:csv $cmd | Out-String
        
        "Output of rerun is " +$output.Length
    } else {
        "Completed file " + $inFile
    }
    "-"*100
}
"Completed all files"

