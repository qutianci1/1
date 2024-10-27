CREATE TABLE "角色" (
    "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
    "uid" integer NOT NULL,
    "nid" text NOT NULL,
    "xid" integer,
    "创建时间" integer NOT NULL,
    "登录时间" integer DEFAULT 0,
    "登出时间" integer DEFAULT 0,
    "删除时间" integer DEFAULT 0,
    "登录地址" text DEFAULT '',
    "名称" text NOT NULL,
    "外形" integer NOT NULL,
    "原形" integer,
    "头像" integer NOT NULL,
    "等级" integer DEFAULT 0,
    "转生" integer DEFAULT 0,
    "飞升" integer DEFAULT 0,
    "性别" integer DEFAULT 0,
    "种族" integer NOT NULL DEFAULT 0,
    "声望" integer DEFAULT 0,
    "最大声望" integer DEFAULT 0,
    "战绩" integer DEFAULT 0,
    "最大战绩" integer DEFAULT 0,
    "杀人数" integer DEFAULT 0,
    "银子" integer DEFAULT 0,
    "存银" integer DEFAULT 0,
    "数据" blob
);
CREATE UNIQUE INDEX "_角色id" ON "角色" ("id" ASC);
CREATE UNIQUE INDEX "_角色nid" ON "角色" ("nid" ASC);
CREATE UNIQUE INDEX "_角色名称" ON "角色" ("名称" ASC);