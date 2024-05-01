--opæa statistika razdvojenog modela
SELECT * FROM dbo.Constituencies
SELECT * FROM dbo.ElectionLists
SELECT * FROM dbo.Counties
SELECT * FROM dbo.PollingStations  --9565
SELECT * FROM dbo.Parties
SELECT * FROM dbo.PollingStations where CityId IN (2,105,106)
SELECT * FROM dbo.Cities where CountyId = 2
SELECT * FROM dbo.Candidates

--biraèka mjesta u gradu zagrebu
SELECT city.Name AS CityName, ps.Name, ps.Code, ps.Location, ps.Address, ps.VotingPopulation, ps.TotalVotes, ps.TotalVotesByBallot, ps.ValidVotes, ps.InvalidVotes 
FROM 
	dbo.PollingStations ps
	INNER JOIN dbo.Cities city on city.Id = ps.CityId
where 
	CityId IN (2,105,106)

SELECT DISTINCT city.Name AS CityName, ps.Name as PollingStationName
FROM 
	dbo.PollingStations ps
	INNER JOIN dbo.Cities city on city.Id = ps.CityId
where 
	CityId IN (2,105,106)

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
WHERE
	county.Id = 2
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

--verifikacija rezultata za možemo po gè u gradu zagrebu
SELECT
	p.ShortName AS PartyName, 
	city.Name AS CityName, 
	district.Name AS DistrictName, 
	SUM(el.TotalVotes) AS TotalVotes
FROM
	dbo.ElectionLists el
	INNER JOIN dbo.Parties p on el.PartyId = p.Id
	INNER JOIN dbo.PollingStations ps on el.PollingStationId = ps.Id
	INNER JOIN dbo.Cities city on city.Id = ps.CityId
	INNER JOIN dbo.CityDistrict district on city.Name = district.ConstituencyName AND district.PollingStationCode = ps.Code
WHERE
	p.ShortName = 'MOŽEMO' AND ConstituencyId IN (1) AND CityId IN (2,105,106) --2 je 2, 6 je 6 -- 45831 je I IJ, 40389 glasova u IJ i Gradu Zagrebu
GROUP BY
	p.ShortName, city.Name, district.Name
ORDER by 
	SUM(el.TotalVotes) DESC

--verifikacija rezultata po gè u gradu zagrebu
SELECT
	p.ShortName AS PartyName, 
	city.Name AS CityName, 
	district.Name AS DistrictName, 
	SUM(el.TotalVotes) AS TotalVotes
FROM
	dbo.ElectionLists el
	INNER JOIN dbo.Parties p on el.PartyId = p.Id
	INNER JOIN dbo.PollingStations ps on el.PollingStationId = ps.Id
	INNER JOIN dbo.Cities city on city.Id = ps.CityId
	INNER JOIN dbo.CityDistrict district on city.Name = district.CityName AND district.PollingStationCode = ps.Code AND ps.ConstituencyId = district.ConstituencyId
WHERE
	ConstituencyId IN (1,2,6) AND CityId IN (2,105,106) --2 je 2, 6 je 6 -- 45831 je I IJ, 40389 glasova u IJ i Gradu Zagrebu
GROUP BY
	p.ShortName, city.Name, district.Name
ORDER by 
	SUM(el.TotalVotes) DESC

--verifikacija glasova za M! u IJ
SELECT
	p.ShortName AS PartyName, 
	city.Name AS CityName, 
	district.Name AS DistrictName, 
	SUM(el.TotalVotes) AS TotalVotes
FROM
	dbo.ElectionLists el
	INNER JOIN dbo.Parties p on el.PartyId = p.Id
	INNER JOIN dbo.PollingStations ps on el.PollingStationId = ps.Id
	INNER JOIN dbo.Cities city on city.Id = ps.CityId
	INNER JOIN dbo.CityDistrict district on city.Name = district.ConstituencyName AND district.PollingStationCode = ps.Code
WHERE
	p.ShortName = 'MOŽEMO' AND ConstituencyId IN (1) AND CityId IN (2) --2 je 2, 6 je 6 -- 45831 je I IJ, 40389 glasova u IJ i Gradu Zagrebu
GROUP BY
	p.ShortName, city.Name, district.Name
ORDER by 
	SUM(el.TotalVotes) DESC

--verifikacija rezultata za možemo po MO u gradu zagrebu
SELECT
	p.ShortName AS PartyName, 
	city.Name AS CityName, 
	ps.Name AS PollingStationName, 
	SUM(el.TotalVotes) AS TotalVotes
FROM
	dbo.ElectionLists el
	INNER JOIN dbo.Parties p on el.PartyId = p.Id
	INNER JOIN dbo.PollingStations ps on el.PollingStationId = ps.Id
	INNER JOIN dbo.Cities city on city.Id = ps.CityId
WHERE
	CityId IN (2,105,106) --2 je 2, 6 je 6 -- 45831 je I IJ, 40389 glasova u IJ i Gradu Zagrebu
GROUP BY
	p.ShortName, city.Name, ps.Name
ORDER by 
	SUM(el.TotalVotes) DESC

--koja BM fale
SELECT
*
FROM
	dbo.PollingStations ps
	INNER JOIN dbo.Cities city on ps.CityId = city.Id
	LEFT JOIN dbo.CityDistrict district on city.Name = district.ConstituencyName AND district.PollingStationCode = ps.Code
WHERE
	ps.CityId = 2
	AND district.Name IS NULL

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



