using System.Runtime.Serialization;

namespace IIS2CSV
{
    class IISLog
    {
        [DataMember(Name = "date")]
        public string date { get; set; }

        [DataMember(Name = "time")]
        public string time { get; set; }

        [DataMember(Name = "s-ip")]
        public string sIP { get; set; }
        [DataMember(Name = "cs-method")]
        public string csMethod { get; set; }
        [DataMember(Name = "cs-uri-stem")]
        public string csuristem { get; set; }
        [DataMember(Name = "cs-uri-query")]
        public string csuriquery { get; set; }
        [DataMember(Name = "s-port")]
        public int? sport { get; set; }
        [DataMember(Name = "cs-username")]
        public string csusername { get; set; }
        [DataMember(Name = "c-ip")]
        public string cIP { get; set; }
        [DataMember(Name = "cs-user-agent")]
        public string csuseragent { get; set; }
        [DataMember(Name = "sc-status")]
        public int? scStatus { get; set; }
        [DataMember(Name = "sc-substatus")]
        public int? scsubstatus { get; set; }
        [DataMember(Name = "sc-win32-status")]
        public long? scwin32status { get; set; }
        [DataMember(Name = "sc-bytes")]
        public int? scbytes { get; set; }
        [DataMember(Name = "cs-bytes")]
        public int? csbytes { get; set; }
        [DataMember(Name = "time-taken")]
        public int? timetaken { get; set; }
    }
}
