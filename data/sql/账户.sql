CREATE TABLE "账户" (
    "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
    "IP" text DEFAULT '',
    "状态" integer DEFAULT 0,
    "时间" integer NOT NULL,
    "账号" text NOT NULL DEFAULT '',
    "密码" text NOT NULL DEFAULT '',
    "安全" text NOT NULL DEFAULT '',
    "QQ" text NOT NULL DEFAULT '',
    "体验" text NOT NULL DEFAULT '',
    "仙玉" INTEGER DEFAULT 0
);
CREATE UNIQUE INDEX "_账户账号" ON "账户" ("账号" ASC);