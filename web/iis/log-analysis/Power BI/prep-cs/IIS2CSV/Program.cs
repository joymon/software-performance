using IISLogParser;
using ServiceStack.Text;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace IIS2CSV
{
    partial class Program
    {


        static void Main(string[] args)
        {

            CsvSerializer serializer = new CsvSerializer();

            //string FilePath = @"C:\temp\KCw\Sep 2019\IIS Analysis\us-wclclaweb03\W3SVC8989\u_ex190901.log";
            //IIS2CSV(FilePath);
            string folderPath = @"<folder which contains .log files>";
            foreach (string filePath in Directory.GetFiles(folderPath, "*.log"))
            {
                IIS2CSV(filePath);
            }
            Console.WriteLine("Hello World!");
        }

        private static void IIS2CSV(string FilePath)
        {

            string outPath = Path.ChangeExtension(FilePath, "csv");
            Console.WriteLine($"Starting {outPath}");
            using (ParserEngine parser = new ParserEngine(FilePath))
            {
                IList<IISLog> logs = null;
                while (parser.MissingRecords)
                {
                    logs = parser.ParseLog().Select(rec => new IISLog()
                    {
                        date = rec.DateTimeEvent.ToString("yyyy-MM-dd"),
                        time = rec.DateTimeEvent.ToString("HH:mm:ss"),
                        sIP = rec.sIp,
                        csMethod = rec.csMethod,
                        csuristem = rec.csUriStem,
                        csuriquery = rec.csUriQuery,
                        sport = rec.sPort,
                        csusername = rec.csUsername,
                        cIP = rec.cIp,
                        csuseragent = rec.csUserAgent,
                        scStatus = rec.scStatus,
                        scsubstatus = rec.scSubstatus,
                        scwin32status = rec.scWin32Status,
                        scbytes = rec.scBytes,
                        csbytes = rec.csBytes,
                        timetaken = rec.timeTaken
                    }).ToList();
                    Console.WriteLine($"Length {logs.Count}");
                }
                Console.WriteLine($"Writing to {outPath}");
                using (TextWriter writer = File.CreateText(outPath))
                {
                    CsvSerializer.SerializeToWriter<IList<IISLog>>(logs, writer);
                }
            }
        }
    }
}
