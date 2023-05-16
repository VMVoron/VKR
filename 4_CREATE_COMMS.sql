CREATE TABLE IF NOT EXISTS ALL_COMMS AS
SELECT *,
	substr(LINK_COMMENT, 1, instr(LINK_COMMENT, "r")-2) AS LINK_POST,
	'KALIN' AS AREA,
    CASE 
    WHEN strftime('%H', 0 || TIME) * 1 BETWEEN 0 AND 9
    THEN strftime('%H', 0 || TIME) * 60 + strftime('%M', 0 || TIME) * 1
    ELSE strftime('%H', TIME) * 60 + strftime('%M', TIME) *1
    END mins
FROM COMM_KALIN
	UNION
SELECT *,
	substr(LINK_COMMENT, 1, instr(LINK_COMMENT, "r")-2) AS LINK_POST,
	'CENTR' AS AREA,
    CASE 
    WHEN strftime('%H', 0 || TIME) * 1 BETWEEN 0 AND 9
    THEN strftime('%H', 0 || TIME) * 60 + strftime('%M', 0 || TIME) * 1
    ELSE strftime('%H', TIME) * 60 + strftime('%M', TIME) *1
    END mins
FROM COMM_CENTR
	UNION
SELECT *,
	substr(LINK_COMMENT, 1, instr(LINK_COMMENT, "r")-2) AS LINK_POST,
	'VAS' AS AREA,
    CASE 
    WHEN strftime('%H', 0 || TIME) * 1 BETWEEN 0 AND 9
    THEN strftime('%H', 0 || TIME) * 60 + strftime('%M', 0 || TIME) * 1
    ELSE strftime('%H', TIME) * 60 + strftime('%M', TIME) *1
    END mins
FROM COMM_VAS
ORDER BY AREA;