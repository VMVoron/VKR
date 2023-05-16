CREATE TABLE IF NOT EXISTS ALL_POSTS AS
SELECT *,
	TYPE || SUBTYPE as UNITYPE,
	'KALIN' AS AREA,
    CASE 
    WHEN strftime('%H', 0 || TIME) * 1 BETWEEN 0 AND 9
    THEN strftime('%H', 0 || TIME) * 60 + strftime('%M', 0 || TIME) * 1
    ELSE strftime('%H', TIME) * 60 + strftime('%M', TIME) *1
    END mins
FROM POST_KALIN
	UNION
SELECT *,
	TYPE || SUBTYPE as UNITYPE,
	'CENTR' AS AREA,
    CASE 
    WHEN strftime('%H', 0 || TIME) * 1 BETWEEN 0 AND 9
    THEN strftime('%H', 0 || TIME) * 60 + strftime('%M', 0 || TIME) * 1
    ELSE strftime('%H', TIME) * 60 + strftime('%M', TIME) *1
    END mins
FROM POST_CENTR
	UNION
SELECT *,
	TYPE || SUBTYPE as UNITYPE, 
	'VAS' AS AREA,
    CASE 
    WHEN strftime('%H', 0 || TIME) * 1 BETWEEN 0 AND 9
    THEN strftime('%H', 0 || TIME) * 60 + strftime('%M', 0 || TIME) * 1
    ELSE strftime('%H', TIME) * 60 + strftime('%M', TIME) *1
    END mins
FROM POST_VAS
ORDER BY AREA;