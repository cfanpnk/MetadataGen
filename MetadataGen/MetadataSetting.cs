using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MetadataGen
{
    public class MetadataSetting
    {
        public string applicationShortName { get; set; }
        public string metadataName { get; set; }
        public string settingName { get; set; }
        public string description { get; set; }
        public string lastUpdateDate { get; set; }
        public string lastUpdatedBy { get; set; }
        public string creationDate { get; set; }
        public string createdBy { get; set; }
        public string enabledFlag { get; set; }
        public List<MetadataValue> metadataValues { get; set; }
    }
}
