CREATE VIEW [dbo].[GongConstituencies]
AS
SELECT
    GongConstituencyNumber,
    STRING_AGG(CountyName, ', ') AS CountyNames
FROM
	dbo.GongCountyMapping
GROUP BY
    GongConstituencyNumber