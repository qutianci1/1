-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-10 03:55:38
-- @Last Modified time  : 2023-11-05 20:10:35
local ENV = setmetatable({}, { __index = _G })
local 装备库 = require('数据库/装备库')
local 神兵属性库 = require('数据库/神兵库')
local 仙器属性库 = require('数据库/仙器库')
local 配饰属性库 = require('数据库/配饰库')
local GGF = require('GGE.函数')
require("数据库/配饰默契属性")
function 生成装备(名称, 等级, 序号)
    local t = 装备库[名称]
    if not t then
        return
    end
    if t.神兵 then
        return 生成神兵(名称, 等级, 序号)
    elseif t.仙器 then
        return 生成仙器(名称, 等级, 序号)
    elseif t.配饰 then
        if 序号 then
            if 序号 == 9999999 then
                return 升级配饰(名称, 等级, 序号)
            end
        end
        return 生成配饰(名称, 等级, 序号)
    end

    if t.装备类别 == '武器' then
        return 生成武器(名称,等级)
    elseif t.装备类别 == '帽子' then
        return 生成帽子(名称,等级)
    elseif t.装备类别 == '衣服' then
        return 生成衣服(名称,等级)
    elseif t.装备类别 == '鞋子' then
        return 生成鞋子(名称,等级)
    elseif t.装备类别 == '项链' then
        return 生成项链(名称,等级)
    end
end


function 生成配饰(名称, 等级, 默契)
    if not 装备库[名称] then return end
    local 部位 = 装备库[名称].装备类别
    if not 配饰属性库['无默契'..部位] or not 配饰属性库[部位] then return end
    local 道具数据=配饰属性库[部位][名称]
    local 生成默契 = 1
    if 默契 == 0 then
        道具数据=配饰属性库['无默契'..部位][名称]
    else
        if 默契 then
            生成默契 = 默契
        end
    end
    local t = setmetatable({}, { __index = 装备库[名称] })
    local 需求表 = {"根骨","灵性","力量","敏捷"}
    local 随机类型 = math.random(4)
    t.名称 = 名称
    t.等级 = 等级
    t.等级需求 = {道具数据.等级需求, 道具数据.转生需求}
    t.属性要求 = {需求表[随机类型], 道具数据.属性需求[随机类型]}
    t.基本属性 = {}
    t.默契属性 = {}
    t.耐久 = t.最大耐久
    t.装备部位 = 部位

    -- 统一加上附加属性
    local 对应属性 = {'附加气血','附加魔法','附加攻击','附加气血'}
    local 附加属性数值
    if 部位 == '挂件' then
        附加属性数值 = 道具数据.附加属性
    else
        附加属性数值 = 道具数据.附加属性[随机类型]
    end
    if 附加属性数值 then
        if 部位 == "挂件" then
            local 临时属性 = '附加气血'
            if math.random(100) >= 50 then 临时属性 = '附加魔法' end
            t.基本属性[#t.基本属性 + 1] = {临时属性,附加属性数值}
            if 默契 == 0 then
                t.基本属性[#t.基本属性] = {临时属性,math.floor(math.random(math.floor(附加属性数值 * 0.5 * 100),附加属性数值 * 100) / 100)}
            end
        else
            t.基本属性[#t.基本属性 + 1] = {对应属性[随机类型],附加属性数值}
            if 默契 == 0 then
                t.基本属性[#t.基本属性] = {对应属性[随机类型],math.floor(math.random(math.floor(附加属性数值 * 0.5 * 100),附加属性数值 * 100) / 100)}
            end
        end
    end

    -- 统一随机一种属性提升
    local 属性提升={"根骨","灵性","力量","敏捷"}
    local 随机属性=math.random(4)
    if 部位 ~= '挂件' and 部位 ~= '戒指' then
        t.基本属性[#t.基本属性 + 1] = {[1] = 属性提升[随机属性] , [2] = 道具数据.属性提升[随机类型]}
        if 默契 == 0 then
            t.基本属性[#t.基本属性] = {[1] = 属性提升[随机属性] , [2] = math.floor(math.random(math.floor(道具数据.属性提升[随机类型] * 0.5 * 100),道具数据.属性提升[随机类型] * 100) / 100)}
        end
    end
    -- 统一添加默契属性
    local 全局 = '默契'..部位..'属性'
    if 默契 == 0 then
        全局 = '无默契'..部位..'属性'
    end
    local 默契属性数据 = _G[全局]()
    local 默契属性数量 = math.random(2,4)
    --无默契参数
    local 默契上限=0
    if 等级<=2 then
        默契上限=1000*等级
    else
        默契上限=2000+(等级-2)*2000
    end
    local result = {}
    while #t.默契属性 < 默契属性数量 do
        local idx = math.random(1, #默契属性数据)
        local value = 默契属性数据[idx]
        if not result[value] then
            table.insert(result, value)
            result[value] = true
            t.默契属性[#t.默契属性 + 1] = {value,取默契属性(value,生成默契,默契属性数量)}
            if 默契 == 0 then
                t.默契属性[#t.默契属性] = {value,取默契属性(value,默契上限 / 2,默契属性数量)}
            end
        end
    end
    if 部位 == '面具' then
        local 抗性 = {"抗混乱","抗封印","抗昏睡","抗遗忘","抗鬼火"}
        local 随机抗性 = math.random(5)
        if 随机抗性 == 5 then
            t.基本属性[#t.基本属性 + 1] = {抗性[随机抗性] , 道具数据.鬼火属性[随机类型]}
            if 默契 == 0 then
                t.基本属性[#t.基本属性] = {抗性[随机抗性] , math.random(math.floor(道具数据.鬼火属性[随机类型] * 0.7 * 10),道具数据.鬼火属性[随机类型] * 10) / 10}
            end
        else
            t.基本属性[#t.基本属性 + 1] = {抗性[随机抗性] , 道具数据.人法属性[随机类型]}
            if 默契 == 0 then
                t.基本属性[#t.基本属性] = {抗性[随机抗性] , math.random(math.floor(道具数据.人法属性[随机类型] * 0.7 * 10),道具数据.人法属性[随机类型] * 10) / 10}
            end
        end
    elseif 部位 == '披风' or 部位 == '腰带' then
        if math.random() <= 50 then
            t.基本属性[#t.基本属性 + 1] = {'抗遗忘',道具数据.人法属性[随机类型]}
            if 默契 == 0 then
                t.基本属性[#t.基本属性] = {'抗遗忘',math.random(math.floor(道具数据.人法属性[随机类型] * 0.7 * 10),道具数据.人法属性[随机类型] * 10) / 10}
            end
        else
            t.基本属性[#t.基本属性 + 1] = {'抗鬼火',道具数据.鬼火属性[随机类型]}
            if 默契 == 0 then
                t.基本属性[#t.基本属性] = {'抗鬼火',math.random(math.floor(道具数据.鬼火属性[随机类型] * 0.7 * 10),道具数据.鬼火属性[随机类型] * 10) / 10}
            end
        end
    elseif 部位 == '挂件' then
        local 抗性={"抗混乱","抗封印","抗昏睡","抗风","抗水","抗火","抗雷"}
        local 随机抗性=math.random(#抗性)
        if 随机抗性>3 then
            t.基本属性[#t.基本属性 + 1] = {抗性[随机抗性] , 道具数据.鬼火属性[随机类型]}
            if 默契 == 0 then
                t.基本属性[#t.基本属性] = {抗性[随机抗性] , math.random(math.floor(道具数据.鬼火属性[随机类型] * 0.7 * 10),道具数据.鬼火属性[随机类型] * 10) / 10}
            end
        else
            t.基本属性[#t.基本属性 + 1] = {抗性[随机抗性] , 道具数据.人法属性[随机类型]}
            if 默契 == 0 then
                t.基本属性[#t.基本属性] = {抗性[随机抗性] , math.random(math.floor(道具数据.人法属性[随机类型] * 0.7 * 10),道具数据.人法属性[随机类型] * 10) / 10}
            end
        end
    elseif 部位 == '戒指' then
        local 属性 = 属性提升[math.random(4)]
        if 默契 == 0 then
            t.基本属性[#t.基本属性 + 1] = {属性,道具数据.属性提升}
        else
            t.基本属性[#t.基本属性 + 1] = {属性,道具数据.属性提升[属性][随机类型]}
        end
        local 左右="左"
        if 名称 == '灵草戒指' or 名称 == '盘古之戒' or 名称 == '黑木戒指' or 名称 == '珊瑚瓣' or 名称 == '冥灵戒指' or 名称 == '血瓷戒指' or 名称 == '翠玉扳指' then
            左右 = "右"
        end
        t.左右 = 左右
    end
    if 默契 ~= 0 then
        t.默契 = 生成默契
        if 等级 <= 2 then
            t.默契上限 = 1000 * 等级
        else
            t.默契上限 = 2000 + (等级 - 2) * 2000
        end
    end
    return t
end

function 升级配饰(名称,物品)
    local list = 物品
    local 默契 = 0
    local 默契上限=0
    local 等级 = list[1].等级 + 1
    local 部位 = list[1].装备部位

    local t = setmetatable({}, { __index = 装备库[名称] })
    local 随机类型 = 0
    local 需求表={"根骨","灵性","力量","敏捷"}
    for i=1,#需求表 do
        if list[1].属性要求[1] == 需求表[i] then
            随机类型 = i
        end
    end

    if list[1].默契 then
        默契 = 1
    else
        if 等级<=2 then
            默契上限=1000*等级
        else
            默契上限=2000+(等级-2)*2000
        end
        随机类型 = math.random(4)
    end
    local 道具数据=配饰属性库[部位][名称]
    if 默契 == 0 then
        道具数据=配饰属性库['无默契'..部位][名称]
    end

    t.名称 = 名称
    t.等级 = list[1].等级 + 1
    t.等级需求 = {道具数据.等级需求, 道具数据.转生需求}
    t.属性要求 = {需求表[随机类型], 道具数据.属性需求[随机类型]}
    t.基本属性 = {}
    t.默契属性 = {}
    t.耐久 = t.最大耐久
    t.装备部位 = 部位
    -- 统一加上附加属性
    local 对应属性 = {'附加气血','附加魔法','附加攻击','附加气血'}
    local 附加属性数值
    if 部位 == '挂件' then
        附加属性数值 = 道具数据.附加属性
    else
        附加属性数值 = 道具数据.附加属性[随机类型]
    end
    if 附加属性数值 then
        if 部位 == "挂件" then
            local 临时属性 = '附加气血'
            if list[1].基本属性.附加魔法 then 临时属性 = '附加魔法' end
            t.基本属性[#t.基本属性 + 1] = {临时属性,附加属性数值}
            if 默契 == 0 then
                t.基本属性[#t.基本属性] = {临时属性,math.floor(math.random(math.floor(附加属性数值 * 0.5 * 100),附加属性数值 * 100) / 100)}
            end
        else
            t.基本属性[#t.基本属性 + 1] = {对应属性[随机类型],附加属性数值}
            if 默契 == 0 then
                t.基本属性[#t.基本属性] = {对应属性[随机类型],math.floor(math.random(math.floor(附加属性数值 * 0.5 * 100),附加属性数值 * 100) / 100)}
            end
        end
    end
    -- 统一随机一种属性提升
    local 属性提升={"根骨","灵性","力量","敏捷"}
    local 随机属性=math.random(4)
    if 部位 ~= '挂件' and 部位 ~= '戒指' then
        for i=1,#list[1].基本属性 do
            for n=1,#属性提升 do
                if list[1].基本属性[i] == 属性提升[n] then
                    随机属性 = n
                end
            end
        end
        t.基本属性[#t.基本属性 + 1] = {[1] = 属性提升[随机属性] , [2] = 道具数据.属性提升[随机类型]}
        if 默契 == 0 then
            随机属性=math.random(4)
            t.基本属性[#t.基本属性] = {[1] = 属性提升[随机属性] , [2] = math.floor(math.random(math.floor(道具数据.属性提升[随机类型] * 0.5 * 100),道具数据.属性提升[随机类型] * 100) / 100)}
        end
    end
    -- 统一添加默契属性
    local 全局 = '默契'..部位..'属性'
    local 默契属性数据 = _G[全局]()
    local 默契属性数量 = #list[1].默契属性
    --还原默契属性
    if 默契 == 0 then
        local 临时数量 = math.random(2,4)
        while #t.默契属性 < 临时数量 do
            for k,v in pairs(默契属性数据) do
                if math.random() <= 10 and #t.默契属性 < 临时数量 then
                    t.默契属性[#t.默契属性 + 1] = {v,取默契属性(v,默契上限 / 2,临时数量)}
                    table.remove(默契属性数据,k)
                end
            end
        end
    else
        for i=1,默契属性数量 do
            local v = list[1].默契属性[i][1]
            t.默契属性[#t.默契属性+1] = {v,取默契属性(v,1,默契属性数量)}
        end
    end

    if 部位 == '面具' then
        local 抗性 = {"抗混乱","抗封印","抗昏睡","抗遗忘","抗鬼火"}
        if 默契 == 0 then
            local 随机抗性 = math.random(5)
            if 随机抗性 == 5 then
                t.基本属性[#t.基本属性 + 1] = {抗性[随机抗性] , math.random(math.floor(道具数据.鬼火属性[随机类型] * 0.7 * 10),道具数据.鬼火属性[随机类型] * 10) / 10}
            else
                t.基本属性[#t.基本属性 + 1] = {抗性[随机抗性] , math.random(math.floor(道具数据.人法属性[随机类型] * 0.7 * 10),道具数据.人法属性[随机类型] * 10) / 10}
            end
        else
            for i=1,#list[1].基本属性 do
                local 随机抗性 = 0
                for n=1,#抗性 do
                    if list[1].基本属性[i][1] == 抗性[n] then
                        随机抗性 = n
                    end
                end
                if 随机抗性 ~= 0 then
                    if 随机抗性 == 5 then
                        t.基本属性[#t.基本属性 + 1] = {抗性[随机抗性] , 道具数据.鬼火属性[随机类型]}
                    else
                        t.基本属性[#t.基本属性 + 1] = {抗性[随机抗性] , 道具数据.人法属性[随机类型]}
                    end
                end
            end
        end
    elseif 部位 == '披风' or 部位 == '腰带' then
        local 抗性 = {"抗遗忘","抗鬼火"}
        if 默契 == 0 then
            if math.random() >= 50 then
                t.基本属性[#t.基本属性 + 1] = {'抗遗忘',math.random(math.floor(道具数据.人法属性[随机类型] * 0.7 * 10),道具数据.人法属性[随机类型] * 10) / 10}
            else
                t.基本属性[#t.基本属性 + 1] = {'抗鬼火',math.random(math.floor(道具数据.鬼火属性[随机类型] * 0.7 * 10),道具数据.鬼火属性[随机类型] * 10) / 10}
            end
        else
            for i=1,#list[1].基本属性 do
                local 随机抗性 = 0
                for n=1,#抗性 do
                    if list[1].基本属性[i][1] == 抗性[n] then
                        随机抗性 = n
                    end
                end
                if 随机抗性 ~= 0 then
                    if 随机抗性 == 1 then
                        t.基本属性[#t.基本属性 + 1] = {'抗遗忘',道具数据.人法属性[随机类型]}
                    else
                        t.基本属性[#t.基本属性 + 1] = {'抗鬼火',道具数据.鬼火属性[随机类型]}
                    end
                end
            end
        end
    elseif 部位 == '挂件' then
        local 抗性={"抗混乱","抗封印","抗昏睡","抗风","抗水","抗火","抗雷"}
        if 默契 == 0 then
            local 随机抗性 = math.random(5)
            if 随机抗性>3 then
                t.基本属性[#t.基本属性 + 1] = {抗性[随机抗性] , math.random(math.floor(道具数据.鬼火属性[随机类型] * 0.7 * 10),道具数据.鬼火属性[随机类型] * 10) / 10}
            else
                t.基本属性[#t.基本属性 + 1] = {抗性[随机抗性] , math.random(math.floor(道具数据.人法属性[随机类型] * 0.7 * 10),道具数据.人法属性[随机类型] * 10) / 10}
            end
        else
            for i=1,#list[1].基本属性 do
                local 随机抗性 = 0
                for n=1,#抗性 do
                    if list[1].基本属性[i][1] == 抗性[n] then
                        随机抗性 = n
                    end
                end
                if 随机抗性 ~= 0 then
                    if 随机抗性>3 then
                        t.基本属性[#t.基本属性 + 1] = {抗性[随机抗性] , 道具数据.鬼火属性[随机类型]}
                    else
                        t.基本属性[#t.基本属性 + 1] = {抗性[随机抗性] , 道具数据.人法属性[随机类型]}
                    end
                end
            end
        end
    elseif 部位 == '戒指' then--需求表
        if 默契 == 0 then
            local 随机属性 = math.random(4)
            t.基本属性[#t.基本属性 + 1] = {需求表[随机属性],道具数据.属性提升}
        else
            for i=1,#list[1].基本属性 do
                local 随机属性 = 0
                for n=1,#需求表 do
                    if list[1].基本属性[i][1] == 需求表[n] then
                        随机属性 = n
                    end
                end
                if 随机属性 ~= 0 then
                    t.基本属性[#t.基本属性 + 1] = {需求表[随机属性],道具数据.属性提升[需求表[随机属性]][随机类型]}
                end
            end
        end
        t.左右 = list[1].左右
    end
    if 默契 ~= 0 then
        t.默契 = 1
        if 等级 <= 2 then
            t.默契上限 = 1000 * 等级
        else
            t.默契上限 = 2000 + (等级 - 2) * 2000
        end
    end
    return t
end

local _仙器等级要求 = { [1] = { 0, 60 }, [2] = { 0, 100 }, [3] = { 1, 120 }, [4] = { 2, 140 }, [5] = { 3, 160 },
    [6] = { 3, 180 }, }
_仙器等级要求2 = { [1] = { 0, 10 }, [2] = { 0, 30 }, [3] = { 0, 50 }, [4] = { 0, 80 }, [5] = { 1, 60 },
    [6] = { 1, 70 } }
function 生成仙器(名称, 等级, 序号)
    if not 装备库[名称] or not 仙器属性库[名称] then
        return
    end
    local js = 等级 or 1
    local r = 仙器属性库[名称][js][序号 or math.random(#仙器属性库[名称][js])]
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.原名 = 名称
    t.耐久 = t.最大耐久
    t.属性要求 = r.属性要求
    t.阶数 = js
    t.基本属性 = r.属性
    t.编号 = math.random(1000) + 10000
    t.名称 = 名称 .. "#" .. js
    t.等级需求 = { _仙器等级要求2[js][2], _仙器等级要求2[js][1] } --真实
    t.等级要求 = { _仙器等级要求2[js][2], _仙器等级要求2[js][1] } --显示
    if r.角色 then
        -- body
    end
    --编号
    --t.炼化属性 --绿字属性
    --t.追加属性 --绿字属性
    --t.炼器属性 --绿字属性
    --特技
    --开光次数

    -- print(t.名称, t.级别, t.属性要求 and t.属性要求[1], t.等级需求[1], t.耐久)
    -- for i, v in ipairs(t.基本属性) do
    --     print('\t', v[1], v[2])
    -- end

    return t
end

local _原形 = {
    剑侠客 = 2,
    骨精灵 = 11,
    幽梦影 = 64,
    虎头怪 = 9,
    墨衣行 = 65,
    逍遥生 = 1,
    夜溪灵 = 63,
    霓裳仙 = 55,
    剑祭魂 = 62,
    紫薇神 = 54,
    舞天姬 = 16,
    无崖子 = 61,
    龙战将 = 14,
    九尾狐 = 53,
    小蛮妖 = 12,
    玄天姬 = 45,
    狐美人 = 10,
    夺命妖 = 8,
    巨魔王 = 7,
    英女侠 = 6,
    混天魔 = 52,
    红拂女 = 51,
    飞燕女 = 5,
    猎魂引 = 60,
    武尊神 = 44,
    俏千金 = 4,
    媚灵狐 = 43,
    精灵仙 = 17,
    燕山雪 = 41,
    飞剑侠 = 40,
    纯阳子 = 50,
    猛壮士 = 3,
    玄剑娥 = 18,
    逆天魔 = 42,
    智圣仙 = 15,
    神天兵 = 13,




}

local 索引 = {
    盘古锤 = {
        {范围={1,12},名称='盘古锤#1_12'},
        {范围={13,32},名称='盘古锤#13_32'},
    },
    芭蕉扇 = {
        {范围={1,12},名称='芭蕉扇#1_12'},
    },
    宣花斧 = {
        {范围={1,4},名称='宣花斧#1_4'},
        {范围={5,32},名称='宣花斧#5_32'},
    },
    混天绫 = {
        {范围={1,20},名称='混天绫#1_20'},
    },
    毁天灭地 = {
        {范围={1,20},名称='毁天灭地#1_20'},
        {范围={21,32},名称='毁天灭地#21_32'},
    },
    枯骨刀 = {
        {范围={1,8},名称='枯骨刀#1_8'},
        {范围={9,36},名称='枯骨刀#9_36'},
        {范围={37,48},名称='枯骨刀#37_53'},
    },
    震天戟 = {
        {范围={1,4},名称='震天戟#1_4'},
        {范围={5,20},名称='震天戟#5_20'},
        {范围={21,44},名称='震天戟#21_44'},
    },
    生死簿 = {
        {范围={1,13},名称='生死簿#1_23'},
    },
    多情环 = {
        {范围={1,4},名称='多情环#1_4'},
        {范围={5,24},名称='多情环#5_24'},
    },
    赤炼鬼爪 = {
        {范围={1,8},名称='赤炼鬼爪#1_8'},
        {范围={9,24},名称='赤炼鬼爪#9_24'},
    },
    索魂幡 = {
        {范围={1,4},名称='索魂幡#1_4'},
        {范围={5,24},名称='索魂幡#5_24'},
    },
    缚龙索 = {
        {范围={1,4},名称='缚龙索#1_4'},
        {范围={5,36},名称='缚龙索#5_36'},
    },
    八景灯 = {
        {范围={1,20},名称='八景灯#1_20'},
    },
    斩妖剑 = {
        {范围={1,28},名称='斩妖剑#1_28'},
        {范围={29,49},名称='斩妖剑#29_49'},
        {范围={50,54},名称='斩妖剑#50_54'},
    },
    搜魂钩 = {
        {范围={1,4},名称='搜魂钩#1_4'},
        {范围={5,8},名称='搜魂钩#5_8'},
        {范围={9,20},名称='搜魂钩#9_28'},
    },
    金箍棒 = {
        {范围={1,4},名称='金箍棒#1_4'},
        {范围={5,32},名称='金箍棒#5_32'},
        {范围={33,52},名称='金箍棒#33_52'},
    },
    乾坤无定 = {
        {范围={1,20},名称='乾坤无定#1_20'},
    },


}

function 生成神兵(名称, 等级, 序号)
    if not 装备库[名称] or not 神兵属性库[名称] then
        return
    end
    local n = 序号 or math.random(#神兵属性库[名称])
    local r = 神兵属性库[名称][n]
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    for k, v in pairs(r.属性要求) do
        t.属性要求 = { k, v }
    end
    t.等级 = 等级 or 1
    t.基本属性 = {}
    local sz = 0
    local 固定属性 = {'物理吸收' , '附加速度' , '防御' , '忽视防御几率'}
    for k, v in ipairs(r.属性) do
        sz = v.数值
        local 固定 = false
        for k = 1 , #固定属性 do
            if v.类型 == 固定属性[k] then
                固定 = true
            end
        end
        if t.装备类别 ~= '武器' and v.类型 == '命中率' then
            固定 = true
        end
        if not 固定 then
            sz = sz * t.等级
        end
        table.insert(t.基本属性, { v.类型, sz })
    end
    t.种族 = r.种族
    --神兵 武器 名称#条数  帽子 衣服 名称#等级_条数    项链鞋子 名称
    t.原名 = 名称
    t.条数 = n
    if t.装备类别 == "武器" then
        for k, v in pairs(索引[名称]) do
            if n >= v.范围[1] and n <= v.范围[2] then
                t.名称 = v.名称
                break
            end
        end
        --t.名称 = 名称 .. "#" .. n
        t.角色 = {}

        local 角色 = GGF.分割文本(r.角色, '|')
        for k, v in pairs(角色) do
            if _原形[v] then
                t.角色[_原形[v]] = true
            end
        end

    elseif t.装备类别 == "帽子" or t.装备类别 == "衣服" then
        t.名称 = 名称 .. "#" .. t.等级 .. "_" .. n
    end

    --编号
    --t.炼化属性 --绿字属性
    --t.追加属性 --绿字属性
    --t.炼器属性 --绿字属性
    --特技
    --开光次数

    -- print(t.名称, t.级别, t.属性要求 and t.属性要求[1], t.等级需求[1], t.耐久)
    -- for i, v in ipairs(t.基本属性) do
    --     print('\t', v[1], v[2])
    -- end

    return t
end

function 生成武器(名称,等级)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_武器')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.属性要求 = T.取属性要求(t.级别, t.装备类型)
    local 属性 = t.属性要求 and t.属性要求[1]
    t.等级需求 = T.取等级需求(t.级别, 属性)
    t.基本属性 = {}
    if t.级别 < 11 then
        table.insert(t.基本属性, T.取攻击(t.级别))
        table.insert(t.基本属性, T.取物理(t.级别))
    elseif t.级别 < 15 then
         if 属性 ~= '力量' then
            table.insert(t.基本属性,T.取强法(t.级别, 属性, t.装备类型) )
        end
        local r = T.取物理(t.级别)
        table.insert(t.基本属性,r)
        table.insert(t.基本属性, T.取攻击(t.级别))
    else
        if 属性 == '根骨' then
            table.insert(t.基本属性, T.取强法(t.级别, 属性, t.装备类型))
        elseif 属性 == '灵性' then
            t.基本属性[1] = T.取强法(t.级别, 属性, t.装备类型)
            t.基本属性[2] = T.取强法(t.级别, 属性, t.装备类型, nil, 11) --用11级的范围
            local a, b = t.基本属性[1], t.基本属性[2]
            if a and b then
                if a[1] == '忽视抗水' and b[1] == '加强水' then
                    t.基本属性[2] = T.取强法(t.级别, 属性, t.装备类型, '加强雷')
                elseif a[1] == '忽视抗火' and b[1] == '加强火' then
                    t.基本属性[2] = T.取强法(t.级别, 属性, t.装备类型, ({ '加强雷', '加强水' })[
                        math.random(2)])
                elseif a[1] == '忽视抗雷' and b[1] == '加强雷' then
                    t.基本属性[2] = T.取强法(t.级别, 属性, t.装备类型, '加强水')
                elseif a[1] == '忽视抗风' and b[1] == '加强风' then
                    t.基本属性[2] = T.取强法(t.级别, 属性, t.装备类型, ({ '加强雷', '加强水' })[
                        math.random(2)])
                end
            end
        elseif 属性 == '力量' then
            t.基本属性[1] = T.取强法(t.级别, 属性, t.装备类型, '忽视防御几率')
            t.基本属性[2] = T.取强法(t.级别, 属性, t.装备类型, '忽视防御程度')
        elseif 属性 == '敏捷' then
            t.基本属性[1] = T.取强法(t.级别, 属性, t.装备类型, '加强震慑')
            t.基本属性[2] = T.取强法(t.级别, 属性, t.装备类型)
        end
        if 等级 then
            t.制作人 = 等级
        end
        table.insert(t.基本属性, T.取物理(t.级别))
        table.insert(t.基本属性, T.取攻击(t.级别))
    end
    return t
end


function 生成帽子(名称,等级)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_帽子')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.属性要求 = T.取属性要求(t.级别)
    local 属性 = t.属性要求 and t.属性要求[1]
    t.等级需求 = T.取等级需求(t.级别, t.属性要求)

    t.基本属性 = {}
    if t.级别 < 11 then
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '物理吸收'))
        if t.级别 > 5 then
            table.insert(t.基本属性, T.取强法(t.级别, 属性, '命中率'))
        end
    elseif t.级别 < 15 then
        if 属性 ~= '力量' then --防止两条物理吸收
            table.insert(t.基本属性, T.取基础(t.级别, 属性))
        end
        table.insert(t.基本属性, T.取抗性(t.级别))
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '命中率'))
        table.insert(t.基本属性, T.取强法(t.级别, 属性))
    else
        if 属性 == '根骨' or 属性 == '灵性' then
            table.insert(t.基本属性, T.取基础(t.级别, 属性))
        end

        for i, v in ipairs(T.随机不重复强法(t.级别, 属性, 2)) do
            table.insert(t.基本属性, T.取强法(t.级别, 属性, v))
        end
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '命中率'))
        for i, v in ipairs(T.随机不重复抗性(t.级别, 2)) do
            table.insert(t.基本属性, T.取抗性(t.级别, v))
        end
    end
    if 等级 then
        t.制作人 = 等级
    end
    -- print(名称.."基础属性为:")
    -- for k, v in ipairs(t.基本属性) do
    --     print(v[1],v[2])
    -- end
    return t
end


function 生成衣服(名称,等级)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_衣服')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.属性要求 = T.取属性要求(t.级别)
    local 属性 = t.属性要求 and t.属性要求[1]
    t.等级需求 = T.取等级需求(t.级别, t.属性要求)

    t.基本属性 = {}
    if t.级别 < 11 then
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '物理吸收'))
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '防御值'))
        if t.级别 > 5 then
            table.insert(t.基本属性, T.取强法(t.级别, 属性, '速度'))
        end
    elseif t.级别 < 15 then
        if 属性 ~= '力量' then --防止两条物理吸收
            local aa = T.取强法(t.级别, 属性)
            table.print(aa)
            table.insert(t.基本属性, T.取基础(t.级别, 属性))
            table.insert(t.基本属性, aa)
        end
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '物理吸收'))
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '防御值'))
        table.insert(t.基本属性, T.取抗性(t.级别))
    else
        if 属性 == '根骨' or 属性 == '灵性' then
            table.insert(t.基本属性, T.取基础(t.级别, 属性))
        end

        table.insert(t.基本属性, T.取强法(t.级别, 属性, '物理吸收'))
        table.insert(t.基本属性, T.取强法(t.级别, 属性, '防御值'))
        for i, v in ipairs(T.随机不重复强法(t.级别, 属性, 2)) do
            table.insert(t.基本属性, T.取强法(t.级别, 属性, v))
        end

        for i, v in ipairs(T.随机不重复抗性(t.级别, 2)) do
            table.insert(t.基本属性, T.取抗性(t.级别, v))
        end
    end

    if 等级 then
        t.制作人 = 等级
    end
    return t
end


function 生成鞋子(名称,等级)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_鞋子')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.属性要求 = nil
    t.等级需求 = T.取等级需求(t.级别)

    t.基本属性 = {}
    if t.级别 < 11 then
        table.insert(t.基本属性, T.取附加指定(t.级别, '速度'))
        if math.random(100) <= 10 then
            table.insert(t.基本属性, T.取附加属性(t.级别))
        end
    else
        table.insert(t.基本属性, T.取附加属性(t.级别))
        table.insert(t.基本属性, T.取附加指定(t.级别, '速度'))
        table.insert(t.基本属性, T.取附加抗性(t.级别))
    end
    if 等级 then
        t.制作人 = 等级
    end
    return t
end



function 生成项链(名称,等级)
    if not 装备库[名称] then
        return
    end
    local T = require('数据库/装备属性_项链')
    local t = setmetatable({}, { __index = 装备库[名称] })
    t.耐久 = t.最大耐久
    t.属性要求 = nil
    t.等级需求 = T.取等级需求(t.级别)

    t.基本属性 = {
        T.取附加指定(t.级别, '附加气血'),
        T.取附加指定(t.级别, '附加魔法')
    }

    if t.级别 > 10 then
        table.insert(t.基本属性, T.取附加属性(t.级别))
        table.insert(t.基本属性, T.取附加抗性(t.级别))
    end
    if 等级 then
        t.制作人 = 等级
    end
    return t
end



return ENV
