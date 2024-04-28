SELECT
	SUM(cv.Total) AS Votes,
	const.Id, const.Name
FROM
	dbo.Candidates c
	INNER JOIN dbo.CandidateVote cv on cv.CandidateId = c.Id
	INNER JOIN dbo.ElectionLists el on cv.ElectionListId = el.Id	
	INNER JOIN dbo.PollingStations ps on ps.Id = el.PollingStationId
	INNER JOIN dbo.Cities cty on ps.CityId = cty.Id
	INNER JOIN dbo.Counties cnty on cnty.Id = cty.CountyId
	INNER JOIN dbo.Constituencies const on cnty.ConstituencyId = const.Id
GROUP BY
	const.Id, const.Name

SELECT * FROM dbo.Constituencies
SELECT * FROM dbo.ElectionLists
SELECT * FROM dbo.Counties

-- po županijama
SELECT
	p.ShortName AS PartyName, county.Name AS CountyName, SUM(el.TotalVotes) AS TotalVotes
FROM
	dbo.ElectionLists el
	INNER JOIN dbo.Parties p on el.PartyId = p.Id
	INNER JOIN dbo.PollingStations ps on el.PollingStationId = ps.Id
	INNER JOIN dbo.Cities city on ps.CityId = city.Id
	INNER JOIN dbo.Counties county on county.Id = city.CountyId
--WHERE
--	county.
GROUP BY
	p.ShortName, county.Name
ORDER by 
	SUM(el.TotalVotes) DESC

SELECT
	p.ShortName AS PartyName, const.Name AS ConstituencyName, SUM(el.TotalVotes) AS TotalVotes
FROM
	dbo.ElectionLists el
	INNER JOIN dbo.Parties p on el.PartyId = p.Id
	INNER JOIN dbo.PollingStations ps on el.PollingStationId = ps.Id
	INNER JOIN dbo.Constituencies const on const.Id = ps.ConstituencyId
WHERE
	const.Id = 1
GROUP BY
	p.ShortName, const.Name
ORDER by 
	SUM(el.TotalVotes) DESC

SELECT 118749 + 61650 + 11407

SELECT * FROM dbo.Parties
select * from dbo.PollingStations
select * from dbo.Cities
select * from dbo.Candidates
select * from dbo.ElectionLists

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

SELECT * FROM dbo.Parties

