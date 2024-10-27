-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-05-14 08:56:30
-- @Last Modified time  : 2024-04-21 23:37:34
local MYF = require('我的函数')
local 角色 = require('角色')

function 角色:取简要数据() --地图对象
    return {
        type = 'play',
        nid = self.nid,
        名称 = self.名称,
        名称颜色 = self.名称颜色,
        称谓 = self.称谓,
        头像 = self.头像,
        外形 = self.外形,
        x = self.x,
        y = self.y,
        方向 = self.方向,
        是否战斗 = self.是否战斗,
        是否观战 = self.是否观战,
        是否交易 = self.是否交易,
        是否队长 = self.是否队长,
        是否移动 = self.是否移动,
        是否摆摊 = self.是否摆摊,
        离线角色 = self.离线角色 or 1,
        状态 = self.状态, --头顶
        队长 = self.队长,
        队伍位置 = self.队伍位置
    }
end

function 角色:取登录数据()
    local r = {
        nid = self.nid,
        id = self.id,
        名称 = self.名称,
        名称颜色 = self.名称颜色,
        称谓 = self.称谓,
        头像 = self.头像,
        原形 = self.头像,
        外形 = self.外形,
        x = self.x,
        y = self.y,
        地图 = self.地图,
        方向 = self.方向,
        气血 = self.气血,
        魔法 = self.魔法,
        经验 = self.经验,
        最大气血 = self.最大气血,
        最大魔法 = self.最大魔法,
        最大经验 = self.最大经验,
        是否队长 = self.是否队长,
        是否摆摊 = self.是否摆摊,
    }
    if self.参战召唤 then
        r.召唤 = self.参战召唤:取界面数据()
    end
    r.BUFF = self:任务_取BUFF列表()
    return r
end

function 角色:取人物状态数据()
    return {
        头像 = self.头像,
        气血 = self.气血,
        最大气血 = self.最大气血,
        魔法 = self.魔法,
        最大魔法 = self.最大魔法,
        经验 = self.经验,
        最大经验 = self.最大经验
    }
end

function 角色:取抗性数据()
    local r = {}
    for _, k in pairs(require('数据库/抗性库')) do
        if self.抗性[k] ~= 0 then
            r[k] = self.抗性[k]
        end
    end
    return r
end

function 角色:角色_取今生属性()
    local r = {
        名称 = self.名称,
        头像 = self.头像,
        性别 = self.性别,
        种族 = self.种族,
        根骨 = self.根骨,
        灵性 = self.灵性,
        力量 = self.力量,
        敏捷 = self.敏捷,
        转生 = self.转生,
        转生记录 = self.转生记录
    }
    return r
end

function 角色:角色_取战斗模型()
    local r = self:任务_获取("变身卡")
    if r and r.外形 then
        return r.外形
    end
    if self.武器 and self.武器 ~= 0 then
        return self.武器
    end
    return self.原形
end

function 角色:角色_取转生()
    return self.转生
end


function 角色:角色_取银子()
    return self.银子
end


function 角色:角色_取师贡()
    return self.师贡
end

function 角色:角色_取存银()
    return self.存银
end

local _存档表 = require('数据库/存档属性_角色')
function 角色:取存档数据()
    local r = {}
    for _, k in ipairs { 'id', 'uid', 'nid', 'xid', '创建时间', '登录时间', '登出时间', '删除时间',
        '登录地址', '名称', '外形', '头像', '原形', '等级', '转生', '飞行', '性别', '种族', '声望',
        '最大声望', '战绩', '最大战绩', '杀人数', '银子', '存银' } do
        r[k] = self[k]
    end
    r.数据 = self.数据
    for _, k in ipairs { '宠物', '好友', '技能', '任务', '物品', '召唤', '坐骑', '法宝' } do
        local t = {}
        for _, v in pairs(self[k]) do
            t[v.nid] = v:取存档数据(self)
        end
        r[k] = t
    end

    for _, v in pairs(self.装备) do
        local t = v:取存档数据(self)
        t.位置 = t.位置 | 256
        r.物品[v.nid] = t
    end

    for _, v in pairs(self.仓库) do
        local t = v:取存档数据(self)
        t.位置 = t.位置 | 512
        r.物品[v.nid] = t
    end

    for _, v in pairs(self.孩子装备) do
        local t = v:取存档数据(self)
        t.位置 = t.位置 | 1024
        r.物品[v.nid] = t
    end
    return r
end

function 角色:加载存档(t) --加载存档的表
    rawset(self, '数据', t.数据)
    t.数据 = nil
    for k, v in pairs(t) do
        self[k] = v
    end

    for k, v in pairs(_存档表) do
        if type(v) == 'table' and type(self[k]) ~= 'table' then
            self[k] = {}
        end
    end
    self.其它 = MYF.容错表(self.其它)
    setmetatable(self.数据, { __index = _存档表 })
    if not next(self.作坊) then
        self.作坊 = {
            { 名称 = "步摇坊", 熟练度 = 0, 段位 = 0, 等级 = 0, 成就 = 0 },
            { 名称 = "湛卢坊", 熟练度 = 0, 段位 = 0, 等级 = 0, 成就 = 0 },
            { 名称 = "七巧坊", 熟练度 = 0, 段位 = 0, 等级 = 0, 成就 = 0 },
            { 名称 = "生莲坊", 熟练度 = 0, 段位 = 0, 等级 = 0, 成就 = 0 },
            { 名称 = "同心坊", 熟练度 = 0, 段位 = 0, 等级 = 0, 成就 = 0 },
            { 名称 = "炼器坊", 熟练度 = 0, 段位 = 0, 等级 = 0, 成就 = 0 },
        }
    end
    if self.等级 <= 30 then
        self.体力上限 = 90
    else
        self.体力上限 = 10 * ( 60 + self.等级 + 50 * self.转生 )
    end
    if self.孩子 then
        for k,v in pairs(self.孩子) do
            if v.参战 then
                self.孩子参战 = v
            end
        end
    end

    return t
end
