CREATE KEYSPACE "tracking" WITH REPLICATION = {'class':'SimpleStrategy', 'replication_factor':1};

USE "tracking";

DROP TABLE "visitors";
DROP TABLE "page_views";

CREATE TABLE "visitors" (
  id         TIMEUUID PRIMARY KEY,
  session_id TEXT,
  ip_address BIGINT,
  user_agent TEXT
);

CREATE TABLE "page_views" (
  id          TIMEUUID PRIMARY KEY,
  session_id  TEXT,
  url         TEXT,
  referer_url TEXT
);
