CREATE TABLE IF NOT EXISTS NORM_CUMUL_EXIST_COMM AS 
SELECT 
  AREA,
  TYPE,
  SUBTYPE,
  UNITYPE,
  OWNER_NAME,
  SIMILAR_AUTHOR,
  1.0 * LEN/2500 AS LEN_POST,
  (ER - 0.000308832612723904)/(23.6413597733711 - 0.000308832612723904) AS ER_NORM,
  LIKES_2/FOLLOWERS/0.405572755417957 AS LIKES_NORM,
  REPOSTS_2/FOLLOWERS/0.0631728045325779 AS REPOSTS_NORM,
  COMMENTS_2/FOLLOWERS/0.108403623867541 AS COMMENTS_NORM,
  VIEWS_2/FOLLOWERS/23.4501416430595 AS VIEWS_NORM,
  EXTERNAL_SOURCE,
  1.0 * EXCLAMATION_2/10 AS EXCLAMATION_NORM,
  1.0 * QUESTION_2/15 AS QUESTION_NORM,
  1.0 * ELLIPSIS_2/15 AS ELLIPSIS_NORM,
  1.0 * IMPERATIV_2/30 AS IMPERATIV_NORM,
  1.0 * PAST_2/200 AS PAST_NORM,
  POSITIVITY,
  NEUTRALITY,
  NEGAVITITY,
  ABS,
  NUM_COMMENTS_2/100 as NUM_COMMENTS_NORM,
  NUM_AUTHORS/336 as NUM_AUTHORS_NORM,
  COUNT_APPEAL_2/250 AS COUNT_APPEAL_NORM,
  AVG_COM_LIKES_2/25 AS AVG_COM_LIKES_NORM,
  AVG_COM_LENGTH_2/2000 AS AVG_COM_LENGTH_NORM,
  PER_COM_EXCLAMATION/46.154 AS PER_COM_EXCLAMATION_NORM,
  PER_COM_QUESTION/100 AS PER_COM_QUESTION_NORM,
  PER_COM_ELLIPSIS/12 AS PER_COM_ELLIPSIS_NORM,
  AVG_POSITIVITY,
  AVG_NEGATIVITY,
  AVG_NEUTRALITY/3 as AVG_NEUTRALITY,
  AVG_TIME_POST/1500 as AVG_TIME_POST_NORM
FROM
(SELECT *,
CASE 
	WHEN LIKES > 750
	THEN 750
	ELSE LIKES
END LIKES_2,
CASE 
	WHEN REPOSTS > 750
	THEN 750
	ELSE REPOSTS
END REPOSTS_2,
CASE 
	WHEN IMPERATIV > 30
	THEN 30
	ELSE IMPERATIV
END IMPERATIV_2,
CASE 
	WHEN QUESTION > 15
	THEN 15
	ELSE QUESTION
END QUESTION_2,
CASE 
	WHEN ELLIPSIS > 15
	THEN 15
	ELSE ELLIPSIS
END ELLIPSIS_2,
CASE 
	WHEN EXCLAMATION > 10
	THEN 10
	WHEN EXCLAMATION  = 0
	THEN 1
	ELSE EXCLAMATION 
END EXCLAMATION_2,
CASE 
	WHEN LENGTH > 2500
	THEN 2500
	WHEN LENGTH = 0
	THEN 1
	ELSE LENGTH
END LEN,
CASE 
	WHEN AVG_COM_LIKES > 25
	THEN 25
	ELSE AVG_COM_LIKES
END AVG_COM_LIKES_2,
CASE 
	WHEN AVG_COM_LENGTH > 2000
	THEN 2000
	ELSE AVG_COM_LENGTH
END AVG_COM_LENGTH_2,
CASE 
	WHEN PER_COM_ELLIPSIS > 12
	THEN 12
	ELSE PER_COM_ELLIPSIS
END PER_COM_ELLIPSIS,
CASE 
	WHEN COMMENTS > 500
	THEN 500
	ELSE COMMENTS
END COMMENTS_2,
CASE 
	WHEN VIEWS > 150000
	THEN 150000
	ELSE VIEWS
END VIEWS_2,
CASE 
	WHEN PAST > 200
	THEN 200
	ELSE PAST
END PAST_2,
CASE 
	WHEN NUM_COMMENTS > 100
	THEN 100
	ELSE NUM_COMMENTS
END NUM_COMMENTS_2,
CASE 
	WHEN COUNT_APPEAL > 250
	THEN 250
	ELSE COUNT_APPEAL
END COUNT_APPEAL_2,
  1.0 * (LIKES + REPOSTS+ COMMENTS + VIEWS)/ FOLLOWERS AS ER
FROM CUMUL_EXIST_COMM)


