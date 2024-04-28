
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;

namespace ExcelParser;

public static class ExcelHelper
{
    public static string GetCellValue(Cell c, WorkbookPart workbookPart)
    {
        var value = String.Empty;

        if (c is null || c.InnerText.Length < 0)
        {
            return String.Empty;
        }
        value = c.InnerText;
        // If the cell represents an integer number, you are done. 
        // For dates, this code returns the serialized value that 
        // represents the date. The code handles strings and 
        // Booleans individually. For shared strings, the code 
        // looks up the corresponding value in the shared string 
        // table. For Booleans, the code converts the value into 
        // the words TRUE or FALSE.
        if (c.DataType is not null)
        {
            if (c.DataType.Value == CellValues.SharedString)
            {
                // For shared strings, look up the value in the
                // shared strings table.
                var stringTable = workbookPart.GetPartsOfType<SharedStringTablePart>().FirstOrDefault();
                // If the shared string table is missing, something 
                // is wrong. Return the index that is in
                // the cell. Otherwise, look up the correct text in 
                // the table.
                if (stringTable is not null)
                {
                    value = stringTable.SharedStringTable.ElementAt(int.Parse(value)).InnerText;
                }
            }
            else if (c.DataType.Value == CellValues.Boolean)
            {
                switch (value)
                {
                    case "0":
                        value = "FALSE";
                        break;
                    default:
                        value = "TRUE";
                        break;
                }
            }
        }

        return value;
    }
}
