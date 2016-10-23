using NPOI.XSSF.UserModel;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;
using System.Xml.Serialization;
using System.Xml.Xsl;

namespace MetadataGen
{
    public partial class Form1 : Form
    {
        String fileName = "";
        public Form1()
        {
            InitializeComponent();
        }

        private void buttonBrowseFile_Click(object sender, EventArgs e)
        {

            using (var dialog = new OpenFileDialog())
            {
                //dialog.InitialDirectory = "c:\\";
                dialog.Filter = "Excel files(*.xls;*.xlsx)|*.xls;*.xlsx|All files (*.*)|*.*";
                dialog.FilterIndex = 1;
                dialog.RestoreDirectory = true;

                if (dialog.ShowDialog() == DialogResult.OK)
                {
                    textBoxSelectedFile.Text = dialog.FileName;
                    fileName = Path.GetFileNameWithoutExtension(dialog.FileName);
                }
            }
        }

        private void buttonPreview_Click(object sender, EventArgs e)
        {
            var lines = new List<Line>();
            var metadata = new Metadata();
            using (var fs = new FileStream(this.textBoxSelectedFile.Text, FileMode.Open))
            {
                var workbook = new XSSFWorkbook(fs);

                workbook.MissingCellPolicy = NPOI.SS.UserModel.MissingCellPolicy.CREATE_NULL_AS_BLANK;
                var cover = workbook.GetSheet("Sheet1");
                var sheet = workbook.GetSheet("Sheet2");

                if (cover != null)
                {
                    var rows = cover.GetRowEnumerator();
                    // Skipp first row
                    rows.MoveNext();

                    var row = (XSSFRow)rows.Current;
                    while (rows.MoveNext())
                    {
                        row = (XSSFRow)rows.Current;

                        if (!string.IsNullOrEmpty(row.GetCell(1).StringCellValue))
                        {
                            metadata.applicationShortName = row.GetCell(0).ToString();
                            metadata.metadataName = row.GetCell(1).ToString();
                            metadata.name = row.GetCell(2).ToString();
                            metadata.description = row.GetCell(3).ToString();
                            metadata.createdBy = row.GetCell(4).ToString();
                        }
                    }
                }

                if (sheet != null)
                {

                    var rows = sheet.GetRowEnumerator();

                    //first row
                    rows.MoveNext();
                    var row = (XSSFRow)rows.Current;

                    while (rows.MoveNext())
                    {
                        row = (XSSFRow)rows.Current;

                        if (!string.IsNullOrEmpty(row.GetCell(1).StringCellValue))
                        {
                            var line = new Line()
                            {
                                shortName = row.GetCell(1).ToString(),
                                setting = row.GetCell(2).ToString(),
                                description = row.GetCell(3).ToString(),
                                usedBy = row.GetCell(4).ToString(),
                                value = row.GetCell(5).ToString()
                                
                            };
                            lines.Add(line);
                        }
                    }
                }
                
                var allSettings = lines.GroupBy(line => line.setting)
                   .Select(grp => grp.First())
                   .ToList();
                var metadataSettings = new List<MetadataSetting>();
                foreach(var s in allSettings)
                {
                    var metadataSetting = new MetadataSetting()
                    {
                        settingName = s.setting,
                        description = s.description
                    };
                    var metadataValues = new List<MetadataValue>();
                    var allValues = from line in lines
                                   where line.setting == s.setting
                                   select line;
                    foreach (var v in allValues)
                    {
                        var metadataValue = new MetadataValue()
                        {
                            settingName = v.setting,
                            usedBy = v.usedBy,
                            value = v.value
                        };
                        metadataValues.Add(metadataValue);
                    }
                    metadataSetting.metadataValues = metadataValues;
                    metadataSettings.Add(metadataSetting);
                }
                metadata.metadataSettings = metadataSettings;
            }


            XslCompiledTransform transformer;
            transformer = new XslCompiledTransform();
            transformer.Load(@"D:\MetadataGen\templates\MetadataMapping.xslt");


            var xmlFileName = @"D:\MetadataGen\xml\" + fileName + ".xml";
            var ldtFileName = @"D:\MetadataGen\ldt\" + fileName + ".ldt";

            using (Stream fs = new FileStream(xmlFileName, FileMode.Create))
            {
                var serializer = new XmlSerializer(typeof(Metadata));
                var writer = new XmlTextWriter(fs, new UTF8Encoding(false));
                // Serialize using the XmlTextWriter.
                serializer.Serialize(writer, metadata);

                writer.Close();
            }
            using (Stream fs = new FileStream(ldtFileName, FileMode.Create))
            {
                var sw = new XmlTextWriter(fs, new UTF8Encoding(false));

                XsltArgumentList args = null;
                transformer.Transform(xmlFileName, args, sw);
            }
                
            
            MessageBox.Show(lines.Count.ToString());
        }
    }
}
