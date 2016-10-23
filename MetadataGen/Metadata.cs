using System.Collections.Generic;

namespace MetadataGen
{
    public class Metadata
    {
        public string applicationShortName { get;  set; }
        public string metadataName { get;  set; }
        public string name { get;  set; }
        public string description { get; set; }
        public string lastUpdateDate { get; set; }
        public string lastUpdatedBy { get; set; }
        public string creationDate { get; set; }
        public string createdBy { get; set; }
        public string enabledFlag { get; set; }
        public List<MetadataSetting> metadataSettings { get; set; }
    }
}