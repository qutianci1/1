CREATE TABLE "好友" (
    "nid" text NOT NULL,
    "rid" INTEGER,
    "fid" INTEGER,
    "名称" TEXT,
    "头像" integer,
    "数据" blob,
    PRIMARY KEY ("nid")
);
CREATE UNIQUE INDEX "_好友nid" ON "好友" ("nid" ASC);
CREATE INDEX "_好友rid" ON "好友" ("rid" ASC);