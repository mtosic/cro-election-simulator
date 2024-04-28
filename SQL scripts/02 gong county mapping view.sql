
CREATE VIEW [dbo].[GongCountyMapping]
AS
SELECT
	CASE Id
	WHEN 8 THEN 1 --Me�imurska
	WHEN 16 THEN 1 -- Vara�dinska
	WHEN 18 THEN 1 -- Krapinsko-zagorska
	WHEN 11 THEN 1 --KOPRIVNI�KO-KRI�EVA�KA �UPANIJA
	WHEN 2 THEN 2 -- GRAD ZAGREB
	WHEN 22 THEN 2 -- inozemstvo
	WHEN 14 THEN 3 --VUKOVARSKO-SRIJEMSKA �UPANIJA
	WHEN 3 THEN 3 -- OSJE�KO-BARANJSKA �UPANIJA
	WHEN 21 THEN 3 -- VIROVITI�KO-PODRAVSKA �UPANIJA
	WHEN 19 THEN 3 --PO�E�KO-SLAVONSKA �UPANIJA
	WHEN 20 THEN 3 --BRODSKO POSAVSKA
	WHEN 5 THEN 4 --BJELOVARSKO-BILOGORSKA �UPANIJA
	WHEN 1 THEN 4 --ZAGREBA�KA �UPANIJA
	WHEN 12 THEN 4 --SISA�KO-MOSLAVA�KA �UPANIJA
	WHEN 17 THEN 4 --KARLOVA�KA �UPANIJA
	WHEN 7 THEN 5 --PRIMORSKO-GORANSKA �UPANIJA
	WHEN 6 THEN 5 --ISTARSKA �UPANIJA
	WHEN 13 THEN 5 --LI�KO-SENJSKA �UPANIJA
	WHEN 4 THEN 6 --ZADARSKA �UPANIJA
	WHEN 9 THEN 6 --�IBENSKO-KNINSKA �UPANIJA
	WHEN 15 THEN 6 --SPLITSKO-DALMATINSKA �UPANIJA
	WHEN 10 THEN 6 --DUBROVA�KO-NERETVANSKA �UPANIJA
	END AS GongConstituencyNumber,
	Id AS CountyId,
	Name AS CountyName,
	Code AS CountyCode
FROM
	dbo.Counties
GO



