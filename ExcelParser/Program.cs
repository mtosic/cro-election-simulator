// See https://aka.ms/new-console-template for more information
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using ExcelParser;
using Infrastructure;
using Model;

Console.WriteLine("Hello, World!");
var fileName = @"C:\Git\Izbori2024\ExcelData\02_01.xlsx";

using var db = new ElectionContext();

using (SpreadsheetDocument spreadsheetDocument = SpreadsheetDocument.Open(fileName, false))
{
    WorkbookPart workbookPart = spreadsheetDocument.WorkbookPart ?? spreadsheetDocument.AddWorkbookPart();
    var worksheetParts = workbookPart.WorksheetParts;
    
    foreach (var worksheetPart in worksheetParts)
    {
        SheetData sheetData = worksheetPart.Worksheet.Elements<SheetData>().FirstOrDefault();

        //make a list of party/cantidate names and its column index in row so we can assign row data to correct party/candidate
        var partyColumnIndex = new Dictionary<int, string>();
        foreach (Row r in sheetData.Elements<Row>())
        {
            Party party = null;
            var rowCells = r.Elements<Cell>().ToList();
            //first row has Election list and Candidate data, we need to parse it from headers
            if (r.RowIndex == 1)
            {
                for (int i = 15; i < rowCells.Count; i++)
                {
                    //column P and latter have in first column party name, than 14 columns for candidates
                    if (i % 15 == 0)
                    {
                        var partyName = ExcelHelper.GetCellValue(rowCells[i], workbookPart);
                        //check if we have party by name, if not create new one
                        party = db.Parties.FirstOrDefault(x => x.Name == partyName);
                        if (party is null)
                        {
                            party = new Party { Name = partyName };
                            db.Parties.Add(party);
                        }
                        partyColumnIndex.Add(i, partyName);
                    }
                    //else we have candidate name
                    else
                    {
                        var candidateName = ExcelHelper.GetCellValue(rowCells[i], workbookPart);
                        //check if we have candidate by name, if not create new one
                        var candidate = db.Candidates.FirstOrDefault(x => x.Name == candidateName);
                        if (candidate is null)
                        {
                            candidate = new Candidate { Name = candidateName, Party = party };
                            db.Candidates.Add(candidate);
                        }
                        partyColumnIndex.Add(i, candidateName);
                    }
                }
                db.SaveChanges();
            }
            else
            {
                //A is constituency index, check if we have it
                var constituencyCode = ExcelHelper.GetCellValue(rowCells[0], workbookPart);
                //excel has empty rows at the end, if we have empty cell in first column, break
                if (String.IsNullOrEmpty(constituencyCode)) break;

                var constituency = db.Constituencies.FirstOrDefault(x => x.Code == constituencyCode);
                //if we don't have it, create new one and save it
                if (constituency is null)
                {
                    //B is constituency name
                    var constituencyName = ExcelHelper.GetCellValue(rowCells[1], workbookPart);
                    constituency = new Constituency { Name = constituencyName, Code = constituencyCode };
                    db.Constituencies.Add(constituency);
                }

                //C and D is county code and name
                var countyCode = ExcelHelper.GetCellValue(rowCells[2], workbookPart);
                var countyName = ExcelHelper.GetCellValue(rowCells[3], workbookPart);
                //check if we have county, if not add it, code can be duplicated with abroad "county", get by name
                var county = db.Counties.FirstOrDefault(x => x.Name == countyName);
                if (county is null)
                {
                    county = new County { Code = countyCode, Name = countyName, Constituency = constituency };
                    db.Counties.Add(county);
                }

                //E and F is city type and name
                var cityType = ExcelHelper.GetCellValue(rowCells[4], workbookPart);
                var cityName = ExcelHelper.GetCellValue(rowCells[5], workbookPart);
                //check if we have city, if not add it
                var city = db.Cities.FirstOrDefault(x => x.Name == cityName);
                if (city is null)
                {
                    city = new City { Name = cityName, Type = cityType, County = county };
                    db.Cities.Add(city);
                }

                //G, H, I and J are polling station code, name, location and address
                var pollingStationCode = ExcelHelper.GetCellValue(rowCells[6], workbookPart);
                var pollingStationName = ExcelHelper.GetCellValue(rowCells[7], workbookPart);
                var pollingStationLocation = ExcelHelper.GetCellValue(rowCells[8], workbookPart);
                var pollingStationAddress = ExcelHelper.GetCellValue(rowCells[9], workbookPart);
                //check if we have polling station, if not add it, code can be duplicated because of abroad polling stations, use name
                var pollingStation = db.PollingStations.FirstOrDefault(x => x.Name == pollingStationName);
                if (pollingStation is null)
                {
                    pollingStation = new PollingStation
                    {
                        Name = pollingStationName,
                        Code = pollingStationCode,
                        Location = pollingStationLocation,
                        Address = pollingStationAddress,
                        City = city
                    };
                    db.PollingStations.Add(pollingStation);
                }

                //K, L, M, N, O are voting population, total votes, total votes by ballot, valid votes and invalid votes
                var votingPopulation = ExcelHelper.GetCellValue(rowCells[10], workbookPart);
                var totalVotes = ExcelHelper.GetCellValue(rowCells[11], workbookPart);
                var totalVotesByBallot = ExcelHelper.GetCellValue(rowCells[12], workbookPart);
                var validVotes = ExcelHelper.GetCellValue(rowCells[13], workbookPart);
                var invalidVotes = ExcelHelper.GetCellValue(rowCells[14], workbookPart);

                //create voting population result and assing it to polling station
                pollingStation.VotingPopulation = int.Parse(votingPopulation);
                pollingStation.TotalVotes = int.Parse(totalVotes);
                pollingStation.TotalVotesByBallot = int.Parse(totalVotesByBallot);
                pollingStation.ValidVotes = int.Parse(validVotes);
                pollingStation.InvalidVotes = int.Parse(invalidVotes);

                //from column 15 we have party votes, then 14 columns for candidate votes, it repeats till end of row
                //we can find party/candidate by name and column index in dictionary
                ElectionList electionList = null;
                for (int i = 15; i < rowCells.Count; i++)
                {
                    var cellValue = ExcelHelper.GetCellValue(rowCells[i], workbookPart);
                    if (partyColumnIndex.TryGetValue(i, out var partyOrCandidateName))
                    {
                        if (i % 15 == 0)
                        {
                            party = db.Parties.FirstOrDefault(x => x.Name == partyOrCandidateName);
                            if (party is not null)
                            {
                                electionList = new ElectionList { Party = party, PollingStation = pollingStation, TotalVotes = int.Parse(cellValue), CandidateVotes = new List<CandidateVote>() };

                            }
                        }
                        else
                        {
                            var candidate = db.Candidates.FirstOrDefault(x => x.Name == partyOrCandidateName);
                            if (candidate is not null)
                            {
                                var candidateVote = new CandidateVote { Candidate = candidate, ElectionList = electionList, Total = int.Parse(cellValue) };
                                electionList.CandidateVotes.Add(candidateVote);
                            }
                            //check if it's last candidate of 14 and add election list to db
                            if (i % 15 == 14)
                            {
                                db.ElectionLists.Add(electionList);
                            }
                        }

                    }
                }
                db.SaveChanges();
            }
        }
        Console.WriteLine("Sheet processing finished");
    }


    Console.WriteLine("Parsing done");
    Console.ReadKey();
}
