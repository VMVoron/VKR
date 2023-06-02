CREATE TABLE IF NOT EXISTS AVG_ALL_POSTS_UNITYPES AS
SELECT
	UNITYPE, 
	COUNT(ID) AS CNT, 
	SUM(SIMILAR_AUTHOR) AS SUM_SIM, 
	ROUND(1.0 * SUM(SIMILAR_AUTHOR)/COUNT(ID), 3) as "% SIMILAR_AUTHOR", 
	ROUND(AVG(LIKES), 3) as AVG_LIKES, 
	ROUND(AVG(REPOSTS), 3) AS AVG_REPOSTS, 
	ROUND(AVG(COMMENTS), 3) AS AVG_COMMENTS,
	ROUND(AVG(VIEWS), 3) AS AVG_VIEWS,
	ROUND(AVG(LENGTH), 3) AS AVG_LENGTH,
	ROUND(AVG(FOLLOWERS), 3) AS FOLLOWERS,
	ROUND(1.0 * (AVG(LIKES) + AVG(REPOSTS) + AVG(COMMENTS)+ AVG(VIEWS)) / AVG(FOLLOWERS), 3) AS ER,
	ROUND(1.0 * SUM(EXCLAMATION)/COUNT(ID), 3) as "%_EXCLAMATION",
	ROUND(1.0 * SUM(QUESTION)/COUNT(ID), 3) as "%_QUESTION",
	ROUND(1.0 * SUM(ELLIPSIS)/COUNT(ID), 3) as "%_ELLIPSIS", 
	ROUND(1.0 * SUM(EXTERNAL_SOURCE)/COUNT(ID), 3) as "% EXT_SRC",
	ROUND(1.0 * SUM(IMPERATIV)/COUNT(ID), 3) as "% IMPERATIV",
	ROUND(1.0 * SUM(PAST)/COUNT(ID), 3) as "% PAST",
	ROUND(AVG(POSITIVITY), 3) AS AVG_POSITIVITY,
	ROUND(AVG(NEGAVITITY), 3) AS AVG_NEGATIVITY,
	ROUND(AVG(NEUTRALITY), 3) AS AVG_NEUTRALITY,
	ROUND(AVG(mins), 3) AS AVG_TIME_POST
FROM
	ALL_POSTS
GROUP BY 
	UNITYPE;