# MetadataGen
This is a handy .NET tool I wrote for my team to consolidate database tables based on Excel spreadsheet. 

## Scenario
There are more than thousands of metadata settings on our two Oracle EBS boxes respectively. We need to consolidate the metadata settings and load them into a global single EBS box. The FNDLOAD tool provided by Oracle doesn't support merging metdata from two ERP boxes. This tool can save hundreds of hours of manual business setup by business analysts.

## Using App
1. Prepare Excel spreadsheets and put them under *input* folder. You can find the Excel templates in the *templates* folder.
2. Prepare the 
2. Run the app
3. Choose the input file
4. Click "Generate"
5. ldt files will be generated in the *ldt* folder