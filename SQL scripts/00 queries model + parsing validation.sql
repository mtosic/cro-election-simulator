--opæa statistika razdvojenog modela
SELECT * FROM dbo.Constituencies
SELECT * FROM dbo.ElectionLists
SELECT * FROM dbo.Counties
SELECT * FROM dbo.PollingStations  --9565
SELECT * FROM dbo.Parties
SELECT * FROM dbo.PollingStations
SELECT * FROM dbo.Cities
SELECT * FROM dbo.Candidates

--ukupno glasova
SELECT
	p.ShortName AS PartyName, SUM(el.TotalVotes) AS TotalVotes
FROM
	dbo.ElectionLists el
	INNER JOIN dbo.Parties p on el.PartyId = p.Id
GROUP BY
	p.ShortName
ORDER by 
	SUM(el.TotalVotes) DESC

--preferencijalni glasovi
SELECT
	SUM(cv.Total) AS Votes,
	const.Id, const.Name
FROM
	dbo.Candidates c
	INNER JOIN dbo.CandidateVote cv on cv.CandidateId = c.Id
	INNER JOIN dbo.ElectionLists el on cv.ElectionListId = el.Id	
	INNER JOIN dbo.PollingStations ps on ps.Id = el.PollingStationId
	INNER JOIN dbo.Constituencies const on ps.ConstituencyId = const.Id
GROUP BY
	const.Id, const.Name

-- po županijama
SELECT
	p.ShortName AS PartyName, county.Name AS CountyName, SUM(el.TotalVotes) AS TotalVotes
FROM
	dbo.ElectionLists el
	INNER JOIN dbo.Parties p on el.PartyId = p.Id
	INNER JOIN dbo.PollingStations ps on el.PollingStationId = ps.Id
	INNER JOIN dbo.Cities city on ps.CityId = city.Id
	INNER JOIN dbo.Counties county on county.Id = city.CountyId
GROUP BY
	p.ShortName, county.Name
ORDER by 
	SUM(el.TotalVotes) DESC

--verifikacija svih parametara za BM za I IJ
SELECT
	const.Name AS ConstituencyName,
	SUM(ps.VotingPopulation) AS VotingPopulation, --341 023
	SUM(ps.TotalVotes) AS TotalVotes, --235 854
	SUM(ps.TotalVotesByBallot) AS TotalVotesByBallot, --235 553
	SUM(ps.ValidVotes) AS ValidVotes, --230 550
	SUM(ps.InvalidVotes) AS InvalidVotes -- 5 003
FROM
	dbo.PollingStations ps
	INNER JOIN dbo.Constituencies const on const.Id = ps.ConstituencyId
WHERE
	const.Id = 1
GROUP BY
	const.Name
ORDER by 
	SUM(ps.TotalVotes) DESC

--verifikacija rezultata za možemo
SELECT
	p.ShortName AS PartyName, const.Name AS ConstituencyName, SUM(el.TotalVotes) AS TotalVotes
FROM
	dbo.ElectionLists el
	INNER JOIN dbo.Parties p on el.PartyId = p.Id
	INNER JOIN dbo.PollingStations ps on el.PollingStationId = ps.Id
	INNER JOIN dbo.Constituencies const on const.Id = ps.ConstituencyId
WHERE
	p.ShortName = 'MOŽEMO'
GROUP BY
	p.ShortName, const.Name
ORDER by 
	SUM(el.TotalVotes) DESC

--broj biraèkih mjesta van inozemstva
SELECT *
FROM 
	dbo.PollingStations ps
	INNER JOIN dbo.Cities c ON c.Id = ps.CityId
	INNER JOIN dbo.Counties co on c.CountyId = co.Id
WHERE
	co.Name <> 'inozemstvo'

--kandidati s više od 10000 preferencijalnih glasova
SELECT
	c.Name, p.name, SUM(cv.Total) 
FROM 
	dbo.CandidateVote cv
	INNER JOIN dbo.Candidates c on c.Id = cv.CandidateId
	INNER JOIN dbo.Parties p on c.PartyId = p.Id
GROUP BY 
	c.Name, p.Name
HAVING
	SUM(cv.Total) > 10000
ORDER BY 
	SUM(cv.Total) DESC



