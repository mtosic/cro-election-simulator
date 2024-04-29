--1 DIP results
INSERT INTO dbo.VotingSimulations([SimulationId], [SimulationName], [ConstituencyNumber], [ConstituencyName], [ConstituencyDescription], [PartyName], [Votes], [TotalVotes], [VotesPercentage])
SELECT
	cs.SimulationId AS SimulationId,
	cs.SimulationName AS SimulationName,
	cs.ConstituencyNumber AS ConstituencyNumber,
	cs.ConstituencyName as ConstituencyName, 
	cs.ConstituencyDescription AS ConstituencyDescription,
	p.ShortName AS PartyName, 
	SUM(el.TotalVotes) AS Votes, 
	cs.ValidVotes AS TotalVotes,
	CAST(CAST(SUM(el.TotalVotes) AS float)/CAST(cs.ValidVotes AS float)*100 AS decimal(10,2)) AS VotesPercentage
FROM
	dbo.ElectionLists el
	INNER JOIN dbo.Parties p on el.PartyId = p.Id
	INNER JOIN dbo.PollingStations ps on el.PollingStationId = ps.Id
	INNER JOIN dbo.ConstituencySimulations cs on ps.ConstituencyId = cs.ConstituencyNumber AND cs.SimulationId = 1
GROUP BY
	cs.SimulationId, cs.SimulationName, cs.ConstituencyNumber, cs.ConstituencyName, cs.ConstituencyDescription, p.ShortName, cs.ValidVotes
ORDER by 
	cs.ConstituencyNumber, SUM(el.TotalVotes) DESC

--2 GONG RB results
INSERT INTO dbo.VotingSimulations([SimulationId], [SimulationName], [ConstituencyNumber], [ConstituencyName], [ConstituencyDescription], [PartyName], [Votes], [TotalVotes], [VotesPercentage])
SELECT
	cs.SimulationId AS SimulationId,
	cs.SimulationName AS SimulationName,
	cs.ConstituencyNumber AS ConstituencyNumber,
	cs.ConstituencyName as ConstituencyName, 
	cs.ConstituencyDescription AS ConstituencyDescription,
	p.ShortName AS PartyName, 
	SUM(el.TotalVotes) AS Votes, 
	cs.ValidVotes AS TotalVotes,
	CAST(CAST(SUM(el.TotalVotes) AS float)/CAST(cs.ValidVotes AS float)*100 AS decimal(10,2)) AS VotesPercentage
FROM
	dbo.ElectionLists el
	INNER JOIN dbo.Parties p on el.PartyId = p.Id
	INNER JOIN dbo.PollingStations ps on el.PollingStationId = ps.Id
	INNER JOIN dbo.Cities city on city.Id = ps.CityId
	INNER JOIN dbo.GongCountyMapping gcm on gcm.CountyId = city.CountyId
	INNER JOIN dbo.ConstituencySimulations cs on gcm.GongConstituencyNumber = cs.ConstituencyNumber AND cs.SimulationId = 2
GROUP BY
	cs.SimulationId, cs.SimulationName, cs.ConstituencyNumber, cs.ConstituencyName, cs.ConstituencyDescription, p.ShortName, cs.ValidVotes
ORDER by 
	cs.ConstituencyNumber, SUM(el.TotalVotes) DESC

--3 GONG PS results
INSERT INTO dbo.VotingSimulations([SimulationId], [SimulationName], [ConstituencyNumber], [ConstituencyName], [ConstituencyDescription], [PartyName], [Votes], [TotalVotes], [VotesPercentage])
SELECT
	cs.SimulationId AS SimulationId,
	cs.SimulationName AS SimulationName,
	cs.ConstituencyNumber AS ConstituencyNumber,
	cs.ConstituencyName as ConstituencyName, 
	cs.ConstituencyDescription AS ConstituencyDescription,
	p.ShortName AS PartyName, 
	SUM(el.TotalVotes) AS Votes, 
	cs.ValidVotes AS TotalVotes,
	CAST(CAST(SUM(el.TotalVotes) AS float)/CAST(cs.ValidVotes AS float)*100 AS decimal(10,2)) AS VotesPercentage
FROM
	dbo.ElectionLists el
	INNER JOIN dbo.Parties p on el.PartyId = p.Id
	INNER JOIN dbo.PollingStations ps on el.PollingStationId = ps.Id
	INNER JOIN dbo.Cities city on city.Id = ps.CityId
	INNER JOIN dbo.GongCountyMapping gcm on gcm.CountyId = city.CountyId
	INNER JOIN dbo.ConstituencySimulations cs on gcm.GongConstituencyNumber = cs.ConstituencyNumber AND cs.SimulationId = 3
GROUP BY
	cs.SimulationId, cs.SimulationName, cs.ConstituencyNumber, cs.ConstituencyName, cs.ConstituencyDescription, p.ShortName, cs.ValidVotes
ORDER by 
	cs.ConstituencyNumber, SUM(el.TotalVotes) DESC

SELECT * FROM dbo.VotingSimulations ORDER BY SimulationId, ConstituencyNumber, Votes DESC