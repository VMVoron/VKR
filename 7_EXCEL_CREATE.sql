CREATE TABLE IF NOT EXISTS EXCEL AS
SELECT * FROM ALL_POSTS
JOIN
CUMUL_EXIST_COMM
ON ALL_POSTS.LINK_POST = CUMUL_EXIST_COMM.LINK_POST;