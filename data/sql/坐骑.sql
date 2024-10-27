/*
* @Author: Administrator
* @Date:   2023-05-08 19:32:35
* @Last Modified by:   baidwwy
* @Last Modified time: 2023-05-10 02:12:32
*/
CREATE TABLE "坐骑" (
    "nid" text NOT NULL,
    "rid" INTEGER,
    "名称" TEXT,
    "等级" integer DEFAULT 0,
    "几座" integer DEFAULT 0,
    "获得时间" integer,
    "数据" blob,
    PRIMARY KEY ("nid")
);
CREATE UNIQUE INDEX "_坐骑nid" ON "坐骑" ("nid" ASC);
CREATE INDEX "_坐骑rid" ON "坐骑" ("rid" ASC);