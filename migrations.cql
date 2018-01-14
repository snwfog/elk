CREATE KEYSPACE "tracking" WITH REPLICATION = {'class':'SimpleStrategy', 'replication_factor':1};

USE "tracking";

DROP TABLE "visitors";
DROP TABLE "page_views";

CREATE TABLE "visitors" (
  id         TIMEUUID,
  session_id TEXT,
  ip_address BIGINT,
  user_agent TEXT,

  PRIMARY KEY ((id, session_id))
);

CREATE TABLE "page_views" (
  id         TIMEUUID,
  session_id TEXT,
  timestamp  TIMESTAMP,
  url        TEXT,
  referer    TEXT,

  PRIMARY KEY ((id, session_id), timestamp)
);
