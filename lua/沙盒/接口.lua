-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-12 04:25:54
-- @Last Modified time  : 2024-08-29 21:41:17
local GGF = require('GGE.函数')
local require = require
local setmetatable = setmetatable
local __世界 = __世界
local __脚本 = __脚本
local __地图 = __地图
local __存档 = __存档
local __副本地图 = __副本地图
local ggexpcall = ggexpcall
local _装备生成 = require('数据库/装备生成')
local _召唤库 = require('数据库/召唤库')
local _坐骑库 = require('数据库/坐骑信息库')
local _法宝库 = require('数据库/法宝库')
local _机器人生成 = require('数据库/机器人生成')

local _ENV = require('沙盒/沙盒')
_随机名称 = require('数据库/随机名称')
_大理寺题库 = require('数据库/大理寺题库')
_仙器名称表 = require('数据库/装备信息库').仙器名称表
function 复制表(t)
    return GGF.复制表(t)
end

function 是否白天()
    return __世界:是否白天()
end

function 是否黑夜()
    return not __世界:是否白天()
end

function 发送系统(...)
    __世界:发送系统(...)
end

function 发送世界(...)
    __世界:发送世界(...)
end

function 检测名称(名称)
    return __存档.检测名称(名称)
end


function 遍历帮派(...)
    return __世界:遍历帮派()
end

function 生成物品(t, ...)
    if type(t) == 'table' then
        t = GGF.复制表(t)
        local r = require('对象/物品/物品')(t)
        local 脚本 = __脚本[r.脚本]
        if 脚本 and 脚本.初始化 then
            ggexpcall(脚本.初始化, r.接口, ...)
        end
        return r.接口
    end
end

function 批量生成物品(t, ...)
    if type(t) == 'table' then
        local 物品表 = {}
        for k, v in pairs(t) do
            table.insert(物品表, 生成物品(v))
        end
        return 物品表
    end
end

function 取召唤外形(名称)
    for k,v in pairs(_召唤库) do
        if 名称 == v.名称 then
            return v.外形
        end
    end
    return nil
end

function 生成召唤(t)
    local 技能格子
    if type(t) == 'table' then
        if not _召唤库[t.名称] then
            print('召唤不存在', t.名称)
            return
        end
        if _召唤库[t.名称].类型 > 5 then
            技能格子 = {已开 = 2 , 封印 = 2 , 未开启 = 4 }
        else
            技能格子 = {已开 = 1 , 封印 = 2 , 未开启 = 5 }
        end
        local 数据 = {原名 = t.名称, 染色 = t.染色, 名称颜色 = 3077448959, 技能格子 = 技能格子,领悟技能 = {}}--橙色
        if t.初血 then
            数据.初血 = t.初血
        end
        if t.初法 then
            数据.初法 = t.初法
        end
        if t.初攻 then
            数据.初攻 = t.初攻
        end
        if t.初敏 then
            数据.初敏 = t.初敏
        end
        if t.成长 then
            数据.成长 = t.成长
        end
        if t.名称颜色 then
            数据.名称颜色 = t.名称颜色
        end
        数据.原形 = t.名称
        t = setmetatable( 数据, { __index = _召唤库[t.名称] })
        return require('对象/召唤/召唤')(t).接口
    end
end

function 生成坐骑(t) --{种族=1,几座=1}
    if type(t) == 'table' then
        if not _坐骑库[t.种族] then
            print('坐骑种族不存在')
            return
        end
        t = setmetatable({}, { __index = _坐骑库[t.种族][t.几座] })
        return require('对象/坐骑/坐骑')(t).接口
    end
end

function 生成装备(t)
    if type(t) == 'table' then
        local r = _装备生成.生成装备(t.名称, t.等级, t.序号)
        if r then
            return require('对象/物品/物品')(r).接口
        end
    end
end

function 生成指定装备(t)
    if type(t) == 'table' then
        local r = _装备生成.生成装备(t.名称, t.等级, t.序号)
        table.print(r)
        if r then
            return r
        end
    end
end

function 生成任务(t, ...)
    if type(t) == 'table' then
        local r = require('对象/任务/任务')(t)
        local 脚本 = __脚本[r.脚本]
        if 脚本 and 脚本.任务初始化 then
            ggexpcall(脚本.任务初始化, r.接口, ...)
        end
        return r.接口
    end
end

function 生成战斗怪物(t)
    if type(t) == 'table' then
        if not t.魔法 then --标记1
            t.魔法 = 1000
        end
        assert(type(t.气血) == 'number', '气血不存在')
        assert(type(t.魔法) == 'number', '魔法不存在')
        assert(type(t.攻击) == 'number', '攻击不存在')
        assert(type(t.速度) == 'number', '速度不存在')
        return require('战斗/对象/怪物')(t)
    end
end

function 生成地图(id)
    if __地图[id] then
        local map = __地图[id]:生成副本()
        __副本地图[map.id] = map
        return map
    end
end

function 取默认五行(外形)
    local 五行={金=0,木=0,水=0,火=0,土=0}
    for k,v in pairs(_召唤库) do
        if v.外形==外形 then
            for q,w in pairs(五行) do
                五行[q]=v[q]
            end
        end
    end
    return 五行
end

function 取随机外形()
    local 返回={名称='兔妖',外形=2001}
    for k,v in pairs(_召唤库) do
        if math.random(100)>=50 then
            返回={名称=v.名称,外形=v.外形}
        end
    end
    return 返回
end

function 生成机器人(t)
    local 机器人 = _机器人生成.生成机器人(t)
    机器人:上线()
    return 机器人
end