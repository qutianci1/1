/*
* @Author: Administrator
* @Date:   2023-05-08 19:32:35
* @Last Modified by:   baidwwy
* @Last Modified time: 2023-05-10 02:12:32
*/
CREATE TABLE "法宝" (
    "nid" text NOT NULL,
    "rid" INTEGER,
    "名称" TEXT,
	"属性" TEXT,
    "等级" integer DEFAULT 0,
	"灵气" integer DEFAULT 0,
	"灵气上限" integer DEFAULT 0,
	"参战" TEXT,
	"数据" blob,
    PRIMARY KEY ("nid")
);
CREATE UNIQUE INDEX "_法宝nid" ON "法宝" ("nid" ASC);
CREATE INDEX "_法宝rid" ON "法宝" ("rid" ASC);