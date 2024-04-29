--model for Simulations
--SimulationId, SimulationName, ConstituencyOrdinal, ConstituencyName, Constituency description, VotingPopulation, TotalVotes, TotalVotesByBallot, ValidVotes, InvalidVotes, NumberOfMandates
-- 1, DIP, 1, I izborna jedinica, I IJ by HDZ gerrymandering, 350 000, 200 000, 199 000, 198 500, 198 500, 500
--DIP simulation
INSERT INTO dbo.ConstituencySimulations([SimulationId], [SimulationName], [ConstituencyNumber], [ConstituencyName], [ConstituencyDescription], [VotingPopulation], [TotalVotes], [TotalVotesByBallot], [ValidVotes], [InvalidVotes], [NumberOfMandates])
SELECT
	1 AS SimulationId,
	'DIP' AS SimulationName,
	const.Id as ConstituencyNumber,
	const.Name AS ConstituencyName,
	const.Name + ' by HDZ gerrymandering' AS ConstituencyDescription,
	SUM(ps.VotingPopulation) AS VotingPopulation,
	SUM(ps.TotalVotes) AS TotalVotes,
	SUM(ps.TotalVotesByBallot) AS TotalVotesByBallot,
	SUM(ps.ValidVotes) AS ValidVotes,
	SUM(ps.InvalidVotes) AS InvalidVotes,
	14 AS NumberOfMandates
FROM
	dbo.PollingStations ps
	INNER JOIN dbo.Constituencies const on const.Id = ps.ConstituencyId
GROUP BY
	const.Id, const.Name
ORDER by 
	const.Id

--GONGov model prema registru biraèa
INSERT INTO dbo.ConstituencySimulations([SimulationId], [SimulationName], [ConstituencyNumber], [ConstituencyName], [ConstituencyDescription], [VotingPopulation], [TotalVotes], [TotalVotesByBallot], [ValidVotes], [InvalidVotes], [NumberOfMandates])
SELECT
	2 AS SimulationId,
	'GONG registar biraèa' AS SimulationName,
	gong.GongConstituencyNumber as ConstituencyNumber,
	CONVERT(varchar(10), gong.GongConstituencyNumber) + '. IZBORNA JEDINICA GONG RB' AS ConstituencyName,
	gong_const.CountyNames AS ConstituencyDescription,
	SUM(ps.VotingPopulation) AS VotingPopulation,
	SUM(ps.TotalVotes) AS TotalVotes,
	SUM(ps.TotalVotesByBallot) AS TotalVotesByBallot,
	SUM(ps.ValidVotes) AS ValidVotes,
	SUM(ps.InvalidVotes) AS InvalidVotes,
	CASE gong.GongConstituencyNumber
		WHEN 1 THEN 17
		WHEN 2 THEN 26
		WHEN 3 THEN 25
		WHEN 4 THEN 24
		WHEN 5 THEN 19
		WHEN 6 THEN 29
	END AS NumberOfMandates
FROM
	dbo.PollingStations ps
	INNER JOIN dbo.Cities city on ps.CityId = city.Id
	INNER JOIN dbo.Counties county on county.Id = city.CountyId
	INNER JOIN dbo.GongCountyMapping gong on gong.CountyId = county.Id
	INNER JOIN dbo.GongConstituencies gong_const on gong.GongConstituencyNumber = gong_const.GongConstituencyNumber
GROUP BY
	gong.GongConstituencyNumber, gong_const.CountyNames
ORDER by 
	gong.GongConstituencyNumber

--GONGov model prema popisu stanovništva
INSERT INTO dbo.ConstituencySimulations([SimulationId], [SimulationName], [ConstituencyNumber], [ConstituencyName], [ConstituencyDescription], [VotingPopulation], [TotalVotes], [TotalVotesByBallot], [ValidVotes], [InvalidVotes], [NumberOfMandates])
SELECT
	3 AS SimulationId,
	'GONG popis stanovništva' AS SimulationName,
	gong.GongConstituencyNumber as ConstituencyNumber,
	CONVERT(varchar(10), gong.GongConstituencyNumber) + '. IZBORNA JEDINICA GONG PS' AS ConstituencyName,
	gong_const.CountyNames AS ConstituencyDescription,
	CASE gong.GongConstituencyNumber
		WHEN 1 THEN 488730
		WHEN 2 THEN 769944
		WHEN 3 THEN 669781
		WHEN 4 THEN 656646
		WHEN 5 THEN 505190
		WHEN 6 THEN 798238
	END AS VotingPopulation,
	SUM(ps.TotalVotes) AS TotalVotes,
	SUM(ps.TotalVotesByBallot) AS TotalVotesByBallot,
	SUM(ps.ValidVotes) AS ValidVotes,
	SUM(ps.InvalidVotes) AS InvalidVotes,
	CASE gong.GongConstituencyNumber
		WHEN 1 THEN 17
		WHEN 2 THEN 27
		WHEN 3 THEN 25
		WHEN 4 THEN 24
		WHEN 5 THEN 18
		WHEN 6 THEN 29
	END AS NumberOfMandates
FROM
	dbo.PollingStations ps
	INNER JOIN dbo.Cities city on ps.CityId = city.Id
	INNER JOIN dbo.Counties county on county.Id = city.CountyId
	INNER JOIN dbo.GongCountyMapping gong on gong.CountyId = county.Id
	INNER JOIN dbo.GongConstituencies gong_const on gong.GongConstituencyNumber = gong_const.GongConstituencyNumber
GROUP BY
	gong.GongConstituencyNumber, gong_const.CountyNames
ORDER by 
	gong.GongConstituencyNumber

--županije, ne ubacujemo u model, ali ako želimo dobiti info po županijama
SELECT
	4 AS SimulationId,
	'Županije' AS SimulationName,
	county.Id as ConstituencyOrdinal,
	county.Name AS ConstituencyName,
	county.Name AS ConstituencyDescription,
	SUM(ps.VotingPopulation) AS VotingPopulation,
	SUM(ps.TotalVotes) AS TotalVotes,
	SUM(ps.TotalVotesByBallot) AS TotalVotesByBallot,
	SUM(ps.ValidVotes) AS ValidVotes,
	SUM(ps.InvalidVotes) AS InvalidVotes,
	14 AS NumberOfMandates
FROM
	dbo.PollingStations ps
	INNER JOIN dbo.Cities city on ps.CityId = city.Id
	INNER JOIN dbo.Counties county on county.Id = city.CountyId
GROUP BY
	county.Id, county.Name
ORDER by 
	county.Id

--raèunanje broja mandata za gong izborne jedinice
SELECT
	gong.GongConstituencyNumber as ConstituencyNumber,
	CONVERT(varchar(10), gong.GongConstituencyNumber) + '. IZBORNA JEDINICA GONG RB' AS ConstituencyName,
	gong_const.CountyNames AS ConstituencyDescription,
	SUM(ps.VotingPopulation) AS VotingPopulation,
	FLOOR(SUM(CAST(ps.VotingPopulation AS DECIMAL(10, 2))) / (SELECT SUM(CAST(VotingPopulation AS DECIMAL(10, 2))) FROM dbo.PollingStations) * 140) AS NumberOfMandates,
	PARSENAME(SUM(CAST(ps.VotingPopulation AS DECIMAL(10, 2))) / (SELECT SUM(CAST(VotingPopulation AS DECIMAL(10, 2))) FROM dbo.PollingStations) * 140, 1) AS Fraction
FROM
	dbo.PollingStations ps
	INNER JOIN dbo.Cities city on ps.CityId = city.Id
	INNER JOIN dbo.Counties county on county.Id = city.CountyId
	INNER JOIN dbo.GongCountyMapping gong on gong.CountyId = county.Id
	INNER JOIN dbo.GongConstituencies gong_const on gong.GongConstituencyNumber = gong_const.GongConstituencyNumber
GROUP BY
	gong.GongConstituencyNumber, gong_const.CountyNames
ORDER by 
	PARSENAME(SUM(CAST(ps.VotingPopulation AS DECIMAL(10, 2))) / (SELECT SUM(CAST(VotingPopulation AS DECIMAL(10, 2))) FROM dbo.PollingStations) * 140, 1) DESC

--



