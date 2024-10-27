-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-26 08:20:56
-- @Last Modified time  : 2024-08-22 17:57:33
local 角色 = require('角色')
local GGF = require('GGE.函数')
local _炼器属性库 = require("数据库/炼器属性库")
local _装备炼化属性库 = require("数据库/普通装备炼化属性库")
local 配饰属性库 = require('数据库/配饰库')
local 装备库 = require('数据库/装备库')
require("数据库/配饰默契属性")

local _打造材料 = {
    [1] = { '', '千年寒铁', '血玲珑' },
    [2] = { '', '千年寒铁', '血玲珑' },
    [3] = { '', '千年寒铁', '血玲珑' },
    [4] = { '', '千年寒铁', '血玲珑' },
    [5] = { '', '千年寒铁', '血玲珑' },
    [6] = { '', '千年寒铁', '血玲珑' },
    [7] = { '', '千年寒铁', '血玲珑' },
    [8] = { '', '千年寒铁', '血玲珑' },
    [9] = { '', '千年寒铁', '血玲珑' },
    [10] = { '', '千年寒铁', '血玲珑' },
    [11] = { '', '千年寒铁', '血玲珑' },
    [12] = { '', '天外飞石', '血玲珑' },
    [13] = { '', '盘古精铁', '血玲珑' },
    [14] = { '', '补天神石', '血玲珑' },
    [15] = { '', '六魂之玉', '血玲珑' },
    [16] = { '', '无量琉璃', '血玲珑' },
}

local _锻造材料 = {
    [9] = { '', '千年寒铁', '内丹精华' },
    [10] = { '', '千年寒铁', '内丹精华' },
    [11] = { '', '千年寒铁', '内丹精华' },
    [12] = { '', '天外飞石', '内丹精华' },
    [13] = { '', '盘古精铁', '内丹精华' },
    [14] = { '', '补天神石', '内丹精华' },
    [15] = { '', '六魂之玉', '内丹精华' },
    [16] = { '', '无量琉璃', '内丹精华' },
}
local _重铸材料 = {
    [9] = { '', '补天神石', '内丹精华' },
    [10] = { '', '补天神石', '内丹精华' },
    [11] = { '', '补天神石', '内丹精华' },
    [12] = { '', '补天神石', '内丹精华' },
    [13] = { '', '补天神石', '内丹精华' },
    [14] = { '', '补天神石', '内丹精华' },
    [15] = { '', '六魂之玉', '内丹精华' },
    [16] = { '', '无量琉璃', '内丹精华' },
}

local _炼化装备 = {
    炼化 = {
        需要数量 = 6,
        fun = function(item, 保留)
            if not item[1].是否装备 then
                return
            end
            if item[1].级别 > 16 then --小于11级无法炼化 大于15级无法炼化 只有装备可以炼化 配饰不行
                return
            end
            for i, v in ipairs { '', '内丹精华', '血玲珑', '九彩云龙珠', '九彩云龙珠', '九彩云龙珠' } do
                if v ~= '' and item[i].名称 ~= v then
                    return
                end
            end
            local 价值 = 0
            for k, v in pairs(item) do
                if v.价值 then
                    价值 = 价值 + v.价值
                end
            end
            local yzxh = 50000

            if 保留 then
                yzxh = 200000
            end


            --价值，金钱，体力
            -- 取材料剩余可炼化次数
            return '炼化', 价值, yzxh, 10
        end
    },
    生产 = {
        需要数量 = 3,
        fun = function(item)
            if not item[1].是否装备 then
                return
            end
            if item[1].数据.炼化属性 then
                return '#Y炼化过的装备无法打造'
            end
            if item[1].级别 > 15 then
                return "#Y只有高级装备才可以在作坊重铸"
            end
            local t = _打造材料[item[1].级别 + 1]
            for i, v in ipairs(t) do
                if v ~= '' and item[i].名称 ~= v then
                    return
                end
            end
            -- local jb = item[1].级别
            local yzxh = 50000
            if item[1].级别 > 10 then
                yzxh = 1 * 2 ^ (item[1].级别 - 10) * 50000
            end
            --价值，金钱，体力
            return '打造', nil, yzxh, 10
        end
    },
    锻造 = {
        需要数量 = 3,
        fun = function(item)
            if not item[1].是否装备 then
                return
            end



            local t = _重铸材料[item[1].级别]
            if t then
                for i, v in ipairs(t) do
                    if v ~= '' and item[i].名称 ~= v then
                        return
                    end
                end
            else
                return
            end

            if item[1].级别 > 15 or item[1].级别 < 10 then
                return "#Y只有高级装备才可以在作坊重铸"
            end
            if item[1].数据.炼化属性 then
                return '#Y炼化过的装备无法重铸'
            end

            local yzxh = 1000000
            --价值，金钱，体力
            return '重铸', nil, yzxh, 10
        end
    },

}

local _炼器装备 = {
    开光 = {
        需要数量 = 2,
        fun = function(item)
            if not item[1].是否装备 then
                return
            end
            if item[1].级别 < 11 then
                return --"#Y只有高级装备才可以进行此操作"
            end
            for i, v in ipairs { '', '九玄仙玉' } do
                if v ~= '' and item[i].名称 ~= v then
                    return
                end
            end
            local yzxh = 100000
            --价值，金钱，体力
            return '开光', nil, yzxh, 10
        end
    },
    炼器 = {
        需要数量 = 2,
        fun = function(item)
            if not item[1].是否装备 then
                return
            end
            -- if  not item[1].开光 then
            --     return --"#Y只有开光过的武器才可以炼器。"
            -- end
            if item[1].级别 < 11 then
                return --"#Y只有高级装备才可以进行此操作"
            end
            local 价值 = 0
            for i, v in ipairs { '', '落魂砂' } do
                if v ~= '' and item[i].名称 ~= v then
                    return
                end
                if v.价值 then
                    价值 = 价值 + v.价值
                end
            end
            local yzxh = 100000
            if item[3] and item[3].名称 == "神功笔录" then
                yzxh = 500000
            end
            --价值，金钱，体力
            return '炼器', 价值, yzxh, 10
        end
    },
}

local _炼化配饰 = {
    升级 = {
        需求数量 = 2,
        fun = function(item)
            if not item[1].是否装备 or not item[1].配饰 or not item[1].默契 then
                return
            end
            for i, v in ipairs { '', '补天神石' } do

                if v ~= '' and item[i].名称 ~= v then
                    return
                end
            end
            local yzxh = item[1].等级 * 400000
            --价值，金钱，体力
            return '升级', nil, yzxh, 0
        end
    },
    培养 = {
        需求数量 = 2,
        fun = function(item)
            if not item[1].是否装备 or not item[1].配饰 or not item[1].默契 then
                return
            end
            for i=2,6 do
                if item[i] then
                    if not item[i].配饰 and not item[i].炼妖 and item[i].名称 ~= '一级配饰盒子' and item[i].名称 ~= '二级配饰盒子' and item[i].名称 ~= '三级配饰盒子' then
                        return
                    end
                end
            end
            local yzxh = item[1].等级 * 20000
            --价值，金钱，体力
            return '培养', nil, yzxh, 0
        end
    },
    属性重炼 = {
        需求数量 = 6,
        fun = function(item)
            if not item[1].是否装备 or not item[1].配饰 then
                return
            end
            for i, v in ipairs { '', '内丹精华', '血玲珑', '九彩云龙珠', '九彩云龙珠', '九彩云龙珠' } do
                if v ~= '' and item[i].名称 ~= v then
                    return
                end
            end
            local yzxh = 20000
            --价值，金钱，体力
            -- 取材料剩余可炼化次数
            return '重炼', nil, yzxh, 0
        end
    },
    低级配饰升级 = {
        需求数量 = 2,
        fun = function(item)
            if not item[1].是否装备 or not item[1].配饰 or item[1].默契 then
                return
            end
            if not item[2].等级 or item[2].默契 then
                return
            end
            if item[1].等级 ~= item[2].等级 then
                return
            end
            if item[1].等级 > 3 or item[2].等级 > 3 then
                return
            end

            local yzxh = item[1].等级 * 400000
            --价值，金钱，体力
            return '升级', nil, yzxh, 0
        end
    },
    高级配饰升级 = {
        需求数量 = 2,
        fun = function(item)
            if not item[1].是否装备 or not item[1].配饰 or not item[1].默契 then
                return
            end
            if not item[2] or not item[2].等级 then
                return
            end
            if item[1].等级 <= 3 or item[2].等级 <= 3 then
                return
            end
            local tables = {'','','','补天神石','六魂之玉','无量琉璃'}
            if item[2].名称 ~= tables[item[1].等级] then
                return
            end
            local yzxh = item[1].等级 * 400000
            --价值，金钱，体力
            return '升级', nil, yzxh, 0
        end
    },
}

local _整数范围 = require('数据库/装备属性_共用')._整数范围
local _装备信息库 = require("数据库/装备信息库")
function 角色:角色_取作坊列表()
    return self.作坊, self.银子, self.体力, self.好心值
end

local function _检查物品(self, list)
    if type(list) ~= 'table' then
        return
    end
    local 数量 = {}
    for _, nid in ipairs(list) do
        if __物品[nid] and __物品[nid].rid == self.id then
            if not 数量[nid] then
                数量[nid] = 0
            end
            数量[nid] = 数量[nid] + 1
        else
            return
        end
    end
    for i, nid in ipairs(list) do
        if 数量[nid] > __物品[nid].数量 then
            return
        end
        list[i] = __物品[nid]
    end
    return true
end

function 角色:角色_炼化配饰(list)
    if not _检查物品(self, list) then
        return
    end
    local n, aa = #list, false
    for k, v in pairs(_炼化配饰) do
        if v.需求数量 <= n then
            aa = true
            -- if n == 3 and list[2].名称 == "内丹精华" and list[3].名称 == "血玲珑" then
            --     aa = false
            -- end

            local r = { v.fun(list) }
            if r[1] then
                return r
            end
        end
    end
    if aa then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
end

function 角色:角色_配饰培养(list)
    if not _检查物品(self, list) then
        return
    end
    if not list[1].配饰 or not list[1].数据.默契 then
        return '#Y只有默契配饰才可以培养。'
    end
    local 通过了 = true
    for i=2,6 do
        if list[i] then
            if not list[i].配饰 and not list[i].炼妖 and list[i].名称 ~= '一级配饰盒子' and list[i].名称 ~= '二级配饰盒子' and list[i].名称 ~= '三级配饰盒子' then
                通过了 = false
            end
        end
    end
    if not 通过了 then
        return
    end
    if self:角色_扣除银子(20000) then
        local 默契 = 0
        for i=2,6 do
            if list[i] then
                if list[i].配饰 then
                    默契 = 默契 + list[i].等级 * 15
                    list[i]:减少(1)
                elseif list[i].炼妖 then
                    默契 = 默契 + list[i].等级 * 3
                    list[i]:减少(1)
                elseif list[i].名称 == '一级配饰盒子' or list[i].名称 == '二级配饰盒子' or list[i].名称 == '三级配饰盒子' then
                    local 差值 = list[1].数据.默契上限 - list[1].数据.默契
                    local 数量 = math.floor( 差值 / ( list[i].等级 * 12 ) )
                    默契 = 默契 + list[i].等级 * 12 * 数量
                    list[i]:减少(数量)
                end
            end
        end
        list[1].数据.默契 = list[1].数据.默契 + 默契
        local 实际 = 默契
        if list[1].数据.默契 > list[1].数据.默契上限 then
            实际 = list[1].数据.默契上限 - list[1].数据.默契
            list[1].数据.默契 = list[1].数据.默契上限
        end
        for i=1,#list[1].数据.默契属性 do
            list[1].数据.默契属性[i][2] = 取默契属性(list[1].数据.默契属性[i][1],list[1].数据.默契,#list[1].数据.默契属性)
        end
        if 实际 ~= 默契 then
            return { self.银子, self.体力, "#Y你的配饰增加了"..实际.."点默契,已达升级上限,请及时升级！" }
        else
            return { self.银子, self.体力, "#Y你的配饰增加了"..实际.."点默契！" }
        end
    else
        return '#Y你的金钱不足20000'
    end
end

function 角色:角色_配饰升级(list)
    if not _检查物品(self, list) then
        return
    end
    if not list[1].配饰 then
        return '#Y只有配饰才可以在这里升级。'
    end
    local yzxh = list[1].等级 * 400000
    if self.银子 < yzxh then
        return '#Y你没有那么多银子。'
    end
    if list[1].默契 then
        if list[1].默契 < list[1].默契上限 then
            return '#Y这件配饰的默契并未打到上限,无法升级。'
        end
        if list[2].名称 ~= '补天神石' then
            return '#Y默契配饰升级需要补天神石。'
        end
    else
        if list[1].等级 == 3 then
            return '#Y3级配饰无法升级。'
        end
        if list[1].等级 < 3 then
            if list[1].等级 ~= list[2].等级 then
                return '#Y两件同级别无默契配饰才可以升级。'
            end
        elseif list[1].等级 > 3 then
            local tables = {'','','','补天神石','六魂之玉','无量琉璃'}
            if list[2].名称 ~= tables[list[1].等级] then
                return '#Y升级'..list[1].等级..'级配饰需要用到'..tables[list[1].等级]..'。'
            end
        end
    end
    local 名称 = 取下级配饰名称(list[1].名称)
    if not 名称 then
        return '#Y这件配饰已满级。'
    end
    if self:物品_添加 { __沙盒.生成装备 { 名称 = 名称 , 等级 = list , 序号 = 9999999 } } then
        list[1]:减少(1)
        list[2]:减少(1)
        self:角色_扣除银子(yzxh)
        return { self.银子, self.体力, string.format("#Y你获得了#R%s", 名称) }
    end
end

function 角色:角色_配饰重炼(list)
    if not _检查物品(self, list) then
        return
    end
    if not list[1].配饰 then
        return '#Y只有配饰才可以在这里重炼。'
    end
    for i=2,6 do
        if not list[i] then
            return '#Y缺少材料。'
        end
    end
    local 材料表 = { '', '内丹精华', '血玲珑', '九彩云龙珠', '九彩云龙珠', '九彩云龙珠' }
    for i=2,6 do
        if list[i].名称 ~= 材料表[i] then
            return '#Y你提供的材料不正确。'
        end
    end
    local 默契 = 0
    local 默契上限=0
    local 部位 = list[1].装备部位
    local 名称 = list[1].名称
    local 等级 = list[1].等级
    local 临时默契 = list[1].默契
    if list[1].默契 then
        默契 = 1
    end
    local 道具数据=配饰属性库[部位][名称]
    if 默契 == 0 then
        道具数据=配饰属性库['无默契'..部位][名称]
    end
    if self:角色_扣除银子(20000) then
        -- list[1]:减少(1)
        -- self:物品_添加 {
        --     __沙盒.生成装备 { 名称 = 名称, 等级 = 等级, 序号 = 临时默契 },
        -- }
        -- list[2]:减少(1)
        -- list[3]:减少(1)
        -- list[4]:减少(1)
        -- list[5]:减少(1)
        -- list[6]:减少(1)
        -- return { self.银子, self.体力, string.format("#Y你的#G%s#Y已重炼#R", 名称) }
        local 需求表 = {"根骨","灵性","力量","敏捷"}
        local 随机类型 = math.random(4)
        list[1].数据.属性要求 = {需求表[随机类型], 道具数据.属性需求[随机类型]}
        list[1].数据.基本属性 = {}
        list[1].数据.默契属性 = {}
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
                list[1].数据.基本属性[#list[1].数据.基本属性 + 1] = {临时属性,附加属性数值}
                if 默契 == 0 then
                    list[1].数据.基本属性[#list[1].数据.基本属性] = {临时属性,math.floor(math.random(math.floor(附加属性数值 * 0.5 * 100),附加属性数值 * 100) / 100)}
                end
            else
                list[1].数据.基本属性[#list[1].数据.基本属性 + 1] = {对应属性[随机类型],附加属性数值}
                if 默契 == 0 then
                    list[1].数据.基本属性[#list[1].数据.基本属性] = {对应属性[随机类型],math.floor(math.random(math.floor(附加属性数值 * 0.5 * 100),附加属性数值 * 100) / 100)}
                end
            end
        end
        -- 统一随机一种属性提升
        local 属性提升={"根骨","灵性","力量","敏捷"}
        local 随机属性=math.random(4)
        if 部位 ~= '挂件' and 部位 ~= '戒指' then
            list[1].数据.基本属性[#list[1].数据.基本属性 + 1] = {[1] = 属性提升[随机属性] , [2] = 道具数据.属性提升[随机类型]}
            if 默契 == 0 then
                list[1].数据.基本属性[#list[1].数据.基本属性] = {[1] = 属性提升[随机属性] , [2] = math.floor(math.random(math.floor(道具数据.属性提升[随机类型] * 0.5 * 100),道具数据.属性提升[随机类型] * 100) / 100)}
            end
        end

        -- 统一添加默契属性
        local 全局 = '默契'..部位..'属性'
        local 默契属性数据 = _G[全局]()
        local 默契属性数量 = math.random(2,4)
        --无默契参数
        if 等级<=2 then
            默契上限=1000*等级
        else
            默契上限=2000+(等级-2)*2000
        end
        local result = {}
        while #list[1].数据.默契属性 < 默契属性数量 do
            local idx = math.random(1, #默契属性数据)
            local value = 默契属性数据[idx]
            if not result[value] then
                table.insert(result, value)
                result[value] = true
                if 默契 == 0 then
                    list[1].数据.默契属性[#list[1].数据.默契属性 + 1] = {value,取默契属性(value,默契上限 / 2,默契属性数量)}
                else
                    list[1].数据.默契属性[#list[1].数据.默契属性 + 1] = {value,取默契属性(value,list[1].默契,默契属性数量)}
                end
            end
        end
        if 部位 == '面具' then
            local 抗性 = {"抗混乱","抗封印","抗昏睡","抗遗忘","抗鬼火"}
            local 随机抗性 = math.random(5)
            if 随机抗性 == 5 then
                list[1].数据.基本属性[#list[1].数据.基本属性 + 1] = {抗性[随机抗性] , 道具数据.鬼火属性[随机类型]}
                if 默契 == 0 then
                    list[1].数据.基本属性[#list[1].数据.基本属性] = {抗性[随机抗性] , math.random(math.floor(道具数据.鬼火属性[随机类型] * 0.7 * 10),道具数据.鬼火属性[随机类型] * 10) / 10}
                end
            else
                list[1].数据.基本属性[#list[1].数据.基本属性 + 1] = {抗性[随机抗性] , 道具数据.人法属性[随机类型]}
                if 默契 == 0 then
                    list[1].数据.基本属性[#list[1].数据.基本属性] = {抗性[随机抗性] , math.random(math.floor(道具数据.人法属性[随机类型] * 0.7 * 10),道具数据.人法属性[随机类型] * 10) / 10}
                end
            end
        elseif 部位 == '披风' or 部位 == '腰带' then
            if math.random() <= 50 then
                list[1].数据.基本属性[#list[1].数据.基本属性 + 1] = {'抗遗忘',道具数据.人法属性[随机类型]}
                if 默契 == 0 then
                    list[1].数据.基本属性[#list[1].数据.基本属性] = {'抗遗忘',math.random(math.floor(道具数据.人法属性[随机类型] * 0.7 * 10),道具数据.人法属性[随机类型] * 10) / 10}
                end
            else
                list[1].数据.基本属性[#list[1].数据.基本属性 + 1] = {'抗鬼火',道具数据.鬼火属性[随机类型]}
                if 默契 == 0 then
                    list[1].数据.基本属性[#list[1].数据.基本属性] = {'抗鬼火',math.random(math.floor(道具数据.鬼火属性[随机类型] * 0.7 * 10),道具数据.鬼火属性[随机类型] * 10) / 10}
                end
            end
        elseif 部位 == '挂件' then
            local 抗性={"抗混乱","抗封印","抗昏睡","抗风","抗水","抗火","抗雷"}
            local 随机抗性=math.random(#抗性)
            if 随机抗性>3 then
                list[1].数据.基本属性[#list[1].数据.基本属性 + 1] = {抗性[随机抗性] , 道具数据.鬼火属性[随机类型]}
                if 默契 == 0 then
                    list[1].数据.基本属性[#list[1].数据.基本属性] = {抗性[随机抗性] , math.random(math.floor(道具数据.鬼火属性[随机类型] * 0.7 * 10),道具数据.鬼火属性[随机类型] * 10) / 10}
                end
            else
                list[1].数据.基本属性[#list[1].数据.基本属性 + 1] = {抗性[随机抗性] , 道具数据.人法属性[随机类型]}
                if 默契 == 0 then
                    list[1].数据.基本属性[#list[1].数据.基本属性] = {抗性[随机抗性] , math.random(math.floor(道具数据.人法属性[随机类型] * 0.7 * 10),道具数据.人法属性[随机类型] * 10) / 10}
                end
            end
        elseif 部位 == '戒指' then
            local 属性 = 属性提升[math.random(4)]
            if 默契 == 0 then
                list[1].数据.基本属性[#list[1].数据.基本属性 + 1] = {属性,道具数据.属性提升}
            else
                list[1].数据.基本属性[#list[1].数据.基本属性 + 1] = {属性,道具数据.属性提升[属性][随机类型]}
            end
        end
        list[2]:减少(1)
        list[3]:减少(1)
        list[4]:减少(1)
        list[5]:减少(1)
        list[6]:减少(1)
        return { self.银子, self.体力, string.format("#Y你的#G%s#Y已重炼#R", 名称) }
    else
        return '#Y你的金钱不足20000'
    end
end

function 角色:角色_炼化装备(作坊, list, 保留)
    if not _检查物品(self, list) then
        return
    end

    -- if 作坊 == nil then
    --     return '因为此装备不能在这个作坊炼化，炼化失败。'
    --     return '因为你的生产作坊等级不足以炼化此装备，炼化失败。'
    -- end

    local n, aa = #list, false
    for k, v in pairs(_炼化装备) do
        if v.需要数量 == n then
            aa = true
            if n == 3 and list[2].名称 == "内丹精华" and list[3].名称 == "血玲珑" then
                aa = false
            end
            local r = { v.fun(list, 保留) }
            if type(r) == "table" then
                if r[1] then
                    if r[1] ~= "炼化" and r[1] ~= "打造" and r[1] ~= "重铸" then
                        return r[1]
                    end
                    return r
                end
            end

        end
    end
    if aa then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
end

local _作坊限制 = { "帽子", "武器", "衣服", "鞋子", "项链" }
local _作坊打造限制 = {
    { dw = 0, lv = 0 },
    { dw = 1, lv = 5 },
    { dw = 1, lv = 10 },
    { dw = 2, lv = 15 },
    { dw = 2, lv = 20 },
    { dw = 3, lv = 25 },
    { dw = 3, lv = 30 },
    { dw = 4, lv = 35 },
    { dw = 4, lv = 40 },
    { dw = 5, lv = 45 },
    { dw = 5, lv = 50 },
    { dw = 6, lv = 55 },
    { dw = 6, lv = 60 },
    { dw = 7, lv = 65 },
    { dw = 7, lv = 70 },
}

function 角色:角色_高级装备打造(作坊, list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 3 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    if not list[1].是否装备 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end




    local t = _打造材料[list[1].级别 + 1]
    for i, v in ipairs(t) do
        if v ~= '' and list[i].名称 ~= v then
            return '#Y你提供的原料有问题，请重新执行一遍。'
        end
    end


    if list[1].数据.炼化属性 then
        return '#Y炼化过的装备不可生产。'
    end
    if list[1].级别 > 15 then
        return '#Y只有高级装备才可以在此生成'
    end
    if not 作坊 or not _作坊限制[作坊] or list[1].装备类别 ~= _作坊限制[作坊] then
        return '#Y因为此装备不能在这个作坊生产，生产失败。'
    end

    local jb = list[1].级别
    if jb < 10 then
        return '#Y10级装备才可以打造为高级装备。'
    end


    local xz = _作坊打造限制[jb + 1]
    local zf = self.作坊[作坊]
    if zf.等级 < xz.lv or zf.段位 < zf.段位 then
        return '#Y因为你的生产作坊等级不足以生产此装备，生产失败。'
    end

    local yzxh = 50000
    if jb > 10 then
        yzxh = 1 * 2 ^ (jb - 10) * 50000
    end
    if self.银子 < yzxh then
        return '#Y你没有那么多银子。'
    end
    local tlxh = 10
    if zf.等级 == 1 and zf.熟练 < 100 then
        tlxh = 0
    end
    if self.体力 < tlxh then
        return '#Y体力不足。'
    end

    self:角色_扣除银子(yzxh)
    self:角色_扣除体力(tlxh)
    local 武器类别 = list[1].装备类别
    local 名称 = ""

    if 武器类别 == "武器" then
        名称 = _装备信息库.武器名称表[list[1].装备类型][jb + 1]
    elseif 武器类别 == "衣服" or 武器类别 == "帽子" then
        名称 = _装备信息库[武器类别 .. "名称表"][list[1].性别][jb + 1]
    elseif 武器类别 == "项链" then
        名称 = _装备信息库.项链名称表[jb + 1]
    elseif 武器类别 == "鞋子" then
        名称 = _装备信息库.鞋子名称表[jb + 1]
    end
    list[1]:减少(1)
    list[2]:减少(1)
    list[3]:减少(1)
    self:物品_添加 {
        __沙盒.生成装备 { 名称 = 名称 , 等级 = self.名称 },
    }
    return { self.银子, self.体力, string.format("#Y你获得了#R%s", 名称) }
end

function 角色:角色_高级装备重铸(作坊, list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 3 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    if not list[1].是否装备 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local t = _重铸材料[list[1].级别]
    for i, v in ipairs(t) do
        if v ~= '' and list[i].名称 ~= v then
            return '#Y你提供的原料有问题，请重新执行一遍。'
        end
    end
    if list[1].数据.炼化属性 then
        return '#Y炼化过的装备不可锻造。'
    end

    -- if list[1].装备类别 ~= "武器" then
    --     return '#Y只有武器可以重铸。'
    -- end
    if list[1].级别 < 10 or list[1].级别 > 16 then
        return '#Y只有高级装备才可以在此锻造'
    end

    if not 作坊 or not _作坊限制[作坊] or list[1].装备类别 ~= _作坊限制[作坊] then
        return '#Y因为此装备不能在这个作坊生产，生产锻造。'
    end
    local xz = _作坊打造限制[list[1].级别]
    local zf = self.作坊[作坊]
    if zf.等级 < xz.lv or zf.段位 < zf.段位 then
        return '#Y因为你的生产作坊等级不足以生产此装备，生产锻造。'
    end

    local yzxh = 1000000
    if self.银子 < yzxh then
        return '#Y你没有那么多银子。'
    end
    local tlxh = 10
    if self.体力 < tlxh then
        return '#Y体力不足。'
    end

    self:角色_扣除银子(yzxh)
    self:角色_扣除体力(tlxh)

    local 名称 = list[1].名称


    list[1]:减少(1)
    list[2]:减少(1)
    list[3]:减少(1)
    self:物品_添加 {
        __沙盒.生成装备 { 名称 = 名称 , 等级 = self.名称 },
    }
    return { self.银子, self.体力, string.format("#R%s#Y的属性发生了些许变化", 名称) }
end

function 角色:角色_装备炼化(作坊, list, 保留)
    if not _检查物品(self, list) then
        return '#Y你提供的原材料不足，请检查原材料。'
    end
    if #list < 6 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    if not list[1].是否装备 then
        return '#Y你提供的原料有问题，请重新执行一遍！'
    end

    -- if list[1].级别 <= 10 then
    --     return '#Y只有高级装备才可以炼化属性。'
    -- end

    if list[1].佩饰 or list[1].仙器 or list[1].神兵 then
        return '#Y只有装备才可以炼化属性。'
    end

    if not 作坊 or not _作坊限制[作坊] or list[1].装备类别 ~= _作坊限制[作坊] then
        return '#Y因为此装备不能在这个作坊炼化，炼化失败。'
    end
    local xz = _作坊打造限制[list[1].级别]
    local zf = self.作坊[作坊]
    if zf.等级 < xz.lv or zf.段位 < zf.段位 then
        return '#Y因为你的生产作坊等级不足以炼化此装备，炼化失败。'
    end
    local yzxh = 50000

    if 保留 then
        yzxh = 200000
    end

    if self.银子 < yzxh then
        return '#Y你的银两不足'
    end
    local tlxh = 10
    if self.体力 < tlxh then
        return '#Y体力不足。'
    end
    for i, v in ipairs { '', '内丹精华', '血玲珑', '九彩云龙珠', '九彩云龙珠', '九彩云龙珠' } do
        if v ~= '' and list[i].名称 ~= v then
            return '#Y你提供的原料有问题，请重新执行一遍。'
        end
    end
    local 确定 = true
    if list[1].数据.炼化属性 and list[1].数据.炼化属性.重复 and not 保留 then
        确定 = self.rpc:确认窗口('检查当前属性较好，确定再次炼化么？')
    end
    if not 确定 then
        return
    end


    self:角色_扣除银子(yzxh)
    self:角色_扣除体力(tlxh)

    list[2]:减少(1)
    list[3]:减少(1)
    list[4]:减少(1)
    list[5]:减少(1)
    list[6]:减少(1)


    --如何计算材料剩余可炼化次数
    local 剩余次数 = 10
    local 价值 = 0
    for k, v in pairs(list) do
        if v.价值 then
            价值 = 价值 + v.价值
        end
    end
    local t, 重复 = self:取普通装备炼化属性(list[1].装备类别, 价值)
    if not list[1].数据.炼化属性 then
        保留 = false
    end
    if 保留 then
        self.临时炼化属性 = {}
        for k, v in pairs(t) do
            table.insert(self.临时炼化属性, { k, v })
        end
        self.临时炼化属性.nid = list[1].nid
        self.临时炼化属性.重复 = 重复
        zf.熟练度 = zf.熟练度 + 15
        t.重复 = 重复

        return "炼化", t, self.银子, self.体力, list[1].数据.炼化属性, zf.熟练度, 剩余次数, "#Y炼化成功！"
    else
        list[1].数据.炼化属性 = {}
        for k, v in pairs(t) do
            table.insert(list[1].数据.炼化属性, { k, v })
        end
        list[1].数据.炼化属性.重复 = 重复
    end
    zf.熟练度 = zf.熟练度 + 15
    return "炼化", t, self.银子, self.体力, nil, zf.熟练度, 剩余次数, "#Y炼化成功！"
end

function 角色:角色_装备炼化属性替换()
    if not self.临时炼化属性 then
        return
    end
    if not self.临时炼化属性.nid then
        return
    end
    local nid = self.临时炼化属性.nid

    if __物品[nid] and __物品[nid].rid == self.id then

        local item = __物品[nid]
        item.数据.炼化属性 = {}
        for i, v in ipairs(self.临时炼化属性) do
            table.insert(item.数据.炼化属性, { v[1], v[2] })
        end
        item.数据.炼化属性.重复 = self.临时炼化属性.重复
        item.数据.制作人 = self.名称
        self.临时炼化属性 = nil
        return item.数据.炼化属性
    end
end

function 角色:角色_炼器(list)
    if not _检查物品(self, list) then
        return
    end
    local n, aa = #list, false
    for k, v in pairs(_炼器装备) do
        if v.需要数量 <= n then
            aa = true
            local r = { v.fun(list) }
            if type(r) == "table" then
                if r[1] then
                    return r
                end
            end
        end
    end
end

local _开光几率 = { 50, 25, 12, 7, 3 }
function 角色:角色_装备开光(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "九玄仙玉" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if not list[1].是否装备 or list[1].级别 < 11 or list[1].佩饰 or list[1].装备类别 ~= "武器" then
        return '#Y只有武器才可以炼化属性。'
    end
    if list[1].数据.开光 and list[1].数据.开光 > 4 then
        return '#Y一件武器只能开光五次。'
    end

    local yzxh = 100000
    if self.银子 < yzxh then
        return '#Y你没有那么多银子。'
    end
    local tlxh = 10
    if self.体力 < tlxh then
        return '#Y体力不足。'
    end
    self:角色_扣除银子(yzxh)
    self:角色_扣除体力(tlxh)
    list[2]:减少(1)
    if math.random(100) < _开光几率[(list[1].数据.开光 or 0) + 1] then
        if list[1].数据.开光 == nil then
            list[1].数据.开光 = 0
        end
        list[1].数据.开光 = list[1].数据.开光 + 1
        return { self.银子, self.体力, "#Y恭喜你，开光成功了！" }
    else
        return { self.银子, self.体力, "#Y很遗憾，开光失败了" }
    end
end

function 角色:角色_装备炼器(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if not list[1].是否装备 or list[1].级别 < 11 or list[1].佩饰 or list[1].装备类别 ~= "武器" then
        return '#Y只有武器才可以炼化属性。'
    end
    if not list[1].数据.开光 then
        return '#Y开光过后的武器才可以进行炼器！'
    end


    local 神功笔录 = 0
    local 价值 = 0
    local 保留 = false

    for i, v in ipairs(list) do
        if v.价值 then
            价值 = 价值 + v.价值 * 3
        end
        if v.名称 == "神功笔录" then
            保留 = true
            神功笔录 = i
        elseif v.名称 == "落魂砂" then
            if v.数量 < 3 then
                return '#Y材料不足！'
            end
        end

    end
    if not list[1].数据.炼器属性 then
        保留 = false
    end
    local yzxh = 100000
    if 保留 then
        yzxh = 500000
    end
    if self.银子 < yzxh then
        return '#Y你没有那么多银子！'
    end
    local tlxh = 10
    if self.体力 < tlxh then
        return '#Y体力不足。'
    end

    local 确定 = true
    if list[1].数据.炼器属性 and list[1].数据.炼器属性.重复 and not 保留 then
        确定 = self.rpc:确认窗口('检查当前属性较好，确定再次炼器么？')
    end
    if not 确定 then
        return
    end




    self:角色_扣除银子(yzxh)
    self:角色_扣除体力(tlxh)

    list[2]:减少(3)
    if list[神功笔录] and 保留 then
        list[神功笔录]:减少(1)
    end
    local t, 重复 = self:取普通装备炼器属性(价值, list[1].开光)
    if 保留 then
        self.临时炼器属性 = {}
        for k, v in pairs(t) do
            table.insert(self.临时炼器属性, { k, v })
        end
        self.临时炼器属性.nid = list[1].nid
        self.临时炼器属性.重复 = 重复
        t.重复 = 重复
        return "炼器", t, self.银子, self.体力, list[1].数据.炼器属性
    else
        list[1].数据.炼器属性 = {}
        for k, v in pairs(t) do
            table.insert(list[1].数据.炼器属性, { k, v })
        end
        list[1].数据.炼器属性.重复 = 重复
        return "炼器", t, self.银子, self.体力
    end
end

function 角色:角色_装备炼器属性替换()
    if not self.临时炼器属性 then
        return
    end
    if not self.临时炼器属性.nid then
        return
    end
    local nid = self.临时炼器属性.nid

    if __物品[nid] and __物品[nid].rid == self.id then

        local item = __物品[nid]
        item.数据.炼器属性 = {}
        for i, v in ipairs(self.临时炼器属性) do
            table.insert(item.数据.炼器属性, { v[1], v[2] })
        end
        item.数据.炼器属性.重复 = self.临时炼器属性.重复
        self.临时炼器属性 = nil
        return item.数据.炼器属性
    end
end

local _装备炼器重复控制 = {
    {
        { 触发 = false, 几率 = 1500 },
        { 触发 = false, 几率 = 3000 },
        { 触发 = false, 几率 = 6000 },
        { 触发 = false, 几率 = 12000 },
    },
    {
        { 触发 = false, 几率 = 1000 },
        { 触发 = false, 几率 = 2000 },
        { 触发 = false, 几率 = 4000 },
        { 触发 = false, 几率 = 8000 },
    },
    {
        { 触发 = false, 几率 = 600 },
        { 触发 = false, 几率 = 1200 },
        { 触发 = false, 几率 = 2400 },
        { 触发 = false, 几率 = 4800 },
    },
}
function 角色:取普通装备炼器属性(价值, n)
    local a = 1
    if 价值 >= 450 then
        a = 3
    elseif 价值 >= 375 then
        a = 2
    end
    local t = GGF.复制表(_炼器属性库)
    local r = {}
    n = math.random(n)
    local 重复 = false
    local 可重复 = self:取重复几率(_装备炼器重复控制, a)
    local 重复数量 = self:取重复条数(可重复)
    if 重复数量 > n then --
        重复数量 = n
    end
    if 重复数量 > 1 then
        local cfsx = math.random(#t) --先随机取一条属性 进行重复
        -- print(string.format("触发炼器 %s 属性重复 %s 条", t[cfsx].名称, 重复数量))
        table.insert(r, t[cfsx])
        n = n - 1
        for i = 1, 重复数量 - 1 do --开始重复
            table.insert(r, t[cfsx])
            n = n - 1
            重复 = true
        end
        table.remove(t, cfsx)
    end
    for i = 1, n do
        local s = math.random(#t)
        table.insert(r, t[s])
        table.remove(t, s)
    end

    local list = {}
    for k, v in pairs(r) do
        for a, b in pairs(r) do
            if v.名称 == b.名称 and k ~= a then
                重复 = true
            end
        end
        if list[v.名称] == nil then
            list[v.名称] = 0
        end
        if v.上限 < v.下限 then
            v.上限 = v.下限
            print(a .. "炼器属性库出错--" .. v.名称)
        end
        if _整数范围[v.名称] then
            list[v.名称] = list[v.名称] + math.floor(math.random(v.下限 * 100, v.上限 * 100) / 100)
        else
            local sz = math.random(v.下限 * 10, v.上限 * 10) / 10
            list[v.名称] = list[v.名称] + sz
        end
    end
    return list, 重复
end

local _普通装备炼化重复控制 = {
    {
        { 触发 = false, 几率 = 1500 },
        { 触发 = false, 几率 = 3000 },
        { 触发 = false, 几率 = 6000 },
        { 触发 = false, 几率 = 12000 },
    },
    {
        { 触发 = false, 几率 = 1000 },
        { 触发 = false, 几率 = 2000 },
        { 触发 = false, 几率 = 4000 },
        { 触发 = false, 几率 = 8000 },
    },
    {
        { 触发 = false, 几率 = 600 },
        { 触发 = false, 几率 = 1200 },
        { 触发 = false, 几率 = 2400 },
        { 触发 = false, 几率 = 4800 },
    },
}

function 角色:取重复几率(t, a)
    local list = t[a]
    for i, v in ipairs(list) do
        v.触发 = false
    end
    return list
end

function 角色:取重复条数(可重复)
    for i = #可重复, 1, -1 do
        if math.random(可重复[i].几率) <= 1 then
            可重复[i].触发 = true
        end
    end

    local 重复条数 = 0
    for i = #可重复, 1, -1 do
        if 可重复[i].触发 then
            重复条数 = i
            break
        end
    end
    return 重复条数 + 1
end

function 角色:取普通装备炼化属性(类别, 价值)
    local a = 1
    if 价值 >= 495 then
        a = 3
    elseif 价值 >= 450 then
        a = 2
    end
    local 重复 = false
    local t = GGF.复制表(_装备炼化属性库[类别])
    local n = math.random(5) --
    local list = {}
    local r = {}
    local 可重复 = self:取重复几率(_普通装备炼化重复控制, a)
    local 重复数量 = self:取重复条数(可重复)
    if 重复数量 > n then --
        重复数量 = n
    end
    if 重复数量 > 1 then
        local cfsx = math.random(#t) --先随机取一条属性 进行重复
        print(string.format("触发装备炼化 %s 属性重复 %s 条", t[cfsx].名称, 重复数量))
        table.insert(r, t[cfsx])
        n = n - 1
        for i = 1, 重复数量 - 1 do --开始重复
            table.insert(r, t[cfsx])
            n = n - 1
            重复 = true
        end
        table.remove(t, cfsx)
    end
    for i = 1, n do --不存在重复
        local s = math.random(#t)
        table.insert(r, t[s])
        table.remove(t, s)
    end


    for k, v in pairs(r) do
        for a, b in pairs(r) do
            if v.名称 == b.名称 and k ~= a then
                重复 = true
            end
        end
        if list[v.名称] == nil then
            list[v.名称] = 0
        end
        if v.上限 < v.下限 then
            v.上限 = v.下限
            print(类别 .. a .. "普通装备炼化属性库出错--" .. v.名称)
        end
        if _整数范围[v.名称] then
            list[v.名称] = list[v.名称] + math.random(v.下限, v.上限)
        else
            local sz = math.random(v.下限 * 10, v.上限 * 10) / 10
            list[v.名称] = list[v.名称] + sz
        end
    end
    return list, 重复
end

--===============================================================================
--===============================================================================
--===============================================================================
function 角色:角色_八荒遗风(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if list[1] and list[1].名称 == "八荒遗风" and list[2] and list[2].仙器 then
        local xh = { 800000, 2000000, 4800000, 8000000, 9600000 }
        local js = list[2].阶数
        return { xh[js] }
    end
    return '#Y你提供的原料有问题，请重新执行一遍。'
end

function 角色:角色_灌输灵气(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    local 上限 = { 8, 8, 6, 5, 3 }
    if list[1] and list[1].名称 == "八荒遗风" and list[2] and list[2].仙器 then
        if list[2].阶数 > 5 then
            return '#Y你提供的原料有问题，请重新执行一遍。'
        end
        if list[1].灵气 then
            if list[1].阶数 ~= 0 and list[1].阶数 ~= list[2].阶数 then
                return '#Y你提供的原料有问题，请重新执行一遍。'
            elseif list[1].阶数 ~= 0 and list[1].灵气 >= 上限[list[1].阶数] then
                return '#Y灵气已满！'
            end
        end
        local js = list[2].阶数
        local xh = { 800000, 2000000, 4800000, 8000000, 9600000 }
        local yzxh = xh[js]
        if self.银子 < yzxh then
            return '#Y你没有那么多银子！'
        end
        self:角色_扣除银子(yzxh)
        if list[1].灵气 then
            list[1]:添加灵气()
        else
            list[1]:添加灵气(list[2].阶数, list[2].编号)

        end
        list[2]:减少(1)
        return { self.银子, "#Y灵气提升1点！" }
    end
end

local _仙器升级材料 = { "千年寒铁", "天外飞石", "盘古精铁", "补天神石", "六魂之玉", "无量琉璃" }
function 角色:角色_提交仙器升级材料(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].灵气 then
        return
    end
    if list[1].名称 ~= "八荒遗风" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local 上限 = { 8, 8, 6, 5, 3 }
    if list[1].灵气 < 上限[list[1].阶数] then
        return "#Y灵气未满"
    end
    if list[2].名称 ~= _仙器升级材料[list[1].阶数] then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local xh = { 1500000, 2800000, 6000000, 12000000, 24000000 }
    --消耗
    return { xh[list[1].阶数 or 1] }

end

function 角色:角色_仙器升级(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].灵气 then
        return
    end
    if list[1].名称 ~= "八荒遗风" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local 上限 = { 8, 8, 6, 5, 3 }
    if list[1].灵气 < 上限[list[1].阶数] then
        return "#Y灵气未满"
    end
    if list[2].名称 ~= _仙器升级材料[list[1].阶数] then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    local xh = { 1500000, 2800000, 6000000, 12000000, 24000000 }
    local yzxh = xh[list[1].阶数 or 1]
    if self.银子 < yzxh then
        return "#Y你没有那么多银子！"
    end

    self:角色_扣除银子(yzxh)
    local 阶 = list[1].阶数 + 1
    local 名称 = _装备信息库.仙器名称表[math.random(#_装备信息库.仙器名称表)]
    list[1]:减少(1)
    list[2]:减少(1)
    self:物品_添加 {

        __沙盒.生成装备 { 名称 = 名称, 等级 = 阶 }

    }

    return { self.银子, string.format("#Y你获得了#R%s", 名称) }



end

function 角色:角色_提交仙器炼化材料(list, 保留)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].仙器 then
        return
    end
    if list[2].名称 ~= "仙器精华" and not list[2].仙器 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].仙器 and list[2].阶数 > 1 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local yzxh = 100000
    if 保留 then
        yzxh = 1000000
    end
    return { yzxh }
end

function 角色:角色_仙器炼化(list, 保留)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    if not list[1].仙器 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "仙器精华" and not list[2].仙器 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].仙器 and list[2].阶数 > 1 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    local yzxh = 100000
    if 保留 then
        yzxh = 1000000
    end
    if self.银子 < yzxh then
        return '#Y你没有那么多银子。'
    end
    self:角色_扣除银子(yzxh)


    list[2]:减少(1)
    --如何计算材料剩余可炼化次数
    local 剩余次数 = 0

    local t = require("数据库/仙器炼化属性库")[list[1].装备类别]
    local sx = t[math.random(#t)]
    local list2 = {}
    list2[sx.名称] = 0
    if _整数范围[sx.名称] then
        list2[sx.名称] = list2[sx.名称] + math.random(sx.下限, sx.上限)
    else
        local sz = math.random(sx.下限 * 10, sx.上限 * 10) / 10
        list2[sx.名称] = list2[sx.名称] + sz
    end

    if not list[1].数据.炼化属性 then
        保留 = false
    end
    if 保留 then
        self.临时仙器炼化属性 = {}
        for k, v in pairs(list2) do
            table.insert(self.临时仙器炼化属性, { k, v })
        end
        self.临时仙器炼化属性.nid = list[1].nid
        return "仙器炼化", list2, self.银子, list[1].数据.炼化属性
    else
        list[1].数据.炼化属性 = {}
        for k, v in pairs(list2) do

            table.insert(list[1].数据.炼化属性, { k, v })
        end
    end
    return "仙器炼化", list2, self.银子
end

function 角色:角色_仙器炼化属性替换()
    if not self.临时仙器炼化属性 then
        return
    end
    if not self.临时仙器炼化属性.nid then
        return
    end
    local nid = self.临时仙器炼化属性.nid

    if __物品[nid] and __物品[nid].rid == self.id then

        local item = __物品[nid]
        item.数据.炼化属性 = {}
        for i, v in ipairs(self.临时仙器炼化属性) do
            table.insert(item.数据.炼化属性, { v[1], v[2] })
        end
        self.临时仙器炼化属性 = nil
        return item.数据.炼化属性
    end
end

function 角色:角色_提交仙器重铸材料(list)
    if not _检查物品(self, list) then
        return
    end

    if #list < 2 then
        return
    end
    if not list[1].仙器 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "悔梦石" and list[2].名称 ~= "高级悔梦石" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local yzxh = 2000000

    return { yzxh }
end

function 角色:角色_仙器重铸(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].仙器 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "悔梦石" and list[2].名称 ~= "高级悔梦石" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local 阶数 = list[1].阶数
    if list[2].名称 == "高级悔梦石" and list[2].参数 < 阶数 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    local yzxh = 2000000
    if self.银子 < yzxh then
        return '#Y你没有那么多银子！'
    end
    self:角色_扣除银子(yzxh)

    local 名称 = list[1].原名
    if list[2].名称 ~= "高级悔梦石" then
        名称 = _装备信息库.仙器名称表[math.random(#_装备信息库.仙器名称表)]
    end
    list[1]:减少(1)
    list[2]:减少(1)

    self:物品_添加 {

        __沙盒.生成装备 { 名称 = 名称, 等级 = 阶数 }

    }

    return { self.银子 }
end

local _普通打造材料 = { "乌金", "金刚石", "寒铁", "百炼精铁", "龙之鳞", "千年寒铁", "天外飞石",
    "盘古精铁", "补天神石" }
function 角色:角色_提交装备打造材料(list)
    if type(list) ~= 'table' then
        return
    end
    for i, nid in ipairs(list) do
        if __物品[nid] and __物品[nid].rid == self.id then
            list[i] = __物品[nid]
        else
            return
        end
    end
    if #list < 2 then
        return
    end
    if not list[1].是否装备 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[1].级别 > 9 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= _普通打造材料[list[1].级别] then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local yzxh = 5000 * list[1].级别




    return { yzxh }



end

function 角色:角色_装备打造(list)
    if type(list) ~= 'table' then
        return
    end

    for i, nid in ipairs(list) do
        if __物品[nid] and __物品[nid].rid == self.id then
            list[i] = __物品[nid]
        else
            return
        end
    end
    if #list < 2 then
        return
    end
    if not list[1].是否装备 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[1].佩饰 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    elseif list[1].级别 > 9 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= _普通打造材料[list[1].级别] then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end

    if list[1].数据.炼化属性 then
        return '#Y炼化过的装备不可生产。'
    end
    if list[1].级别 > 9 then
        return '#Y只有高级装备才可以在此生成'
    end

    local yzxh = 5000 * list[1].级别

    if self.银子 < yzxh then
        return '#Y你没有那么多银子。'
    end

    self:角色_扣除银子(yzxh)
    local 武器类别 = list[1].装备类别
    local 名称 = ""

    if 武器类别 == "武器" then
        名称 = _装备信息库.武器名称表[list[1].装备类型][list[1].级别 + 1]
    elseif 武器类别 == "衣服" or 武器类别 == "帽子" then
        名称 = _装备信息库[武器类别 .. "名称表"][list[1].性别][list[1].级别 + 1]
    elseif 武器类别 == "项链" or 武器类别 == "鞋子" then
        名称 = _装备信息库[武器类别 .. "名称表"][list[1].级别 + 1]

    end
    list[1]:减少(1)
    list[2]:减少(1)
    self:物品_添加 {
        __沙盒.生成装备 { 名称 = 名称 , 等级 = self.名称 },
    }
    return { self.银子, string.format("#Y你获得了#R%s", 名称) }
end

--===============================================================================
--===============================================================================

function 角色:角色_提交神兵升级材料(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= _仙器升级材料[list[1].等级] then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local yzxh = 100000
    if list[1].等级 > 1 then
        yzxh = 1 * 2 ^ (list[1].等级 - 1) * 100000
    end

    return { yzxh }

end

local _神兵升级广播 = {
    "#G%s#Y眼疾手快的夺回了何大雷刚想贪污的#R%s，#Y，定眼一看原来四级了，乐的屁颠屁颠的。",
    "#Y刹那间，天空忽然传来#G%s#Y的一声长啸“有此五级#R%s#Y，今世别无所求”",
    "#Y神器问世，谁与争锋！何大雷双手将六级的#R%s#Y奉上，叹道：“只有风流如#G%s#Y才配的上这绝世神兵",
}
function 角色:角色_神兵升级(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= _仙器升级材料[list[1].等级] then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[1].等级 >= 6 then
        return '#Y神兵等级已达上限。'
    end
    local yzxh = 100000
    if list[1].等级 > 1 then
        yzxh = 1 * 2 ^ (list[1].等级 - 1) * 100000
    end
    if self.银子 < yzxh then
        return "#Y你没有那么多银子！"
    end

    self:角色_扣除银子(yzxh)
    list[2]:减少(1)
    local dj = list[1].等级
    local 成功几率 = { 60, 40, 15, 10, 5}
    if math.random(100) < 成功几率[dj] then
        if list[1].装备类别 == '武器' then
            if list[1].数据.属性要求 then
                local sz = list[1].数据.属性要求[2] / dj
                sz = sz * (dj + 1)
                list[1].数据.属性要求[2] = math.floor(sz)
            end
        end

        local 固定属性 = {'物理吸收' , '附加速度' , '防御' , '忽视防御几率'}
        for k, v in pairs(list[1].数据.基本属性) do
            local r = v[2] / dj
            local 固定 = false
            for n = 1 , #固定属性 do
                if v[1] == 固定属性[n] then
                    固定 = true
                end
            end
            if list[1].装备类别 ~= '武器' and v[1] == '命中率' then
                固定 = true
            end
            if not 固定 then
                v[2] = r * (dj + 1)
            end
        end
        list[1].等级 = list[1].等级 + 1

        if list[1].装备类别 == "帽子" or list[1].装备类别 == "衣服" then
            list[1].名称 = list[1].原名 .. "#" .. list[1].等级 .. "_" .. list[1].条数
        end

        if list[1].等级 == 4 then
            __世界:发送系统(string.format(_神兵升级广播[1], self.名称, list[1].原名))
        elseif list[1].等级 == 5 then
            __世界:发送系统(string.format(_神兵升级广播[2], self.名称, list[1].原名))
        elseif list[1].等级 == 6 then
            __世界:发送系统(string.format(_神兵升级广播[3], list[1].原名, self.名称))

        end

        return { self.银子, string.format("#W好的，你的#Y%s#W已经升到了%s级。", list[1].原名, list[1].等级) }
    else
        list[1]:减少(1)
        return { self.银子, "由于你强行锻造神兵，使原来并不完美的神兵加速损坏，你的神兵消失了。" }
    end


end
--神兵精炼
function 角色:角色_提交神兵强化材料(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if not list[2].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local yzxh = 100000
    if list[1].等级 > 1 then
        yzxh = 1 * 2 ^ (list[1].等级 - 1) * 100000
    end

    return { yzxh }

end
function 角色:角色_神兵强化(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 or list[1].等级 < 4  then
        return '#Y只有4级或者4级以上神兵才可以使用精炼升级。'
    end
    if not list[2].神兵 or list[2].等级 < 1 or list[2].等级 > 3 then
    return '#Y你提供的原料有问题，必须是1级到3级的神兵，请重新执行一遍。'
    end
    if list[1].等级 >= 6 then
        return '#Y神兵等级已达上限。'
    end
    local yzxh = 100000
    if list[1].等级 > 1 then
        yzxh = 1 * 2 ^ (list[1].等级 - 1) * 100000
    end
    if self.银子 < yzxh then
        return "#Y你没有那么多银子！"
    end

    self:角色_扣除银子(yzxh)
    list[2]:减少(1)
    local dj = list[1].等级
    --这里 6是4-5 3是5-6 100/  目前 4-5 是100/6 5-6是100/3
    local 成功几率 = { 60, 20, 5, 3, 1}
    if math.random(100) < 成功几率[dj] then
        if list[1].装备类别 == '武器' then
            if list[1].数据.属性要求 then
                local sz = list[1].数据.属性要求[2] / dj
                sz = sz * (dj + 1)
                list[1].数据.属性要求[2] = math.floor(sz)
            end
        end

        local 固定属性 = {'物理吸收' , '附加速度' , '防御' , '忽视防御几率'}
        for k, v in pairs(list[1].数据.基本属性) do
            local r = v[2] / dj
            local 固定 = false
            for n = 1 , #固定属性 do
                if v[1] == 固定属性[n] then
                    固定 = true
                end
            end
            if list[1].装备类别 ~= '武器' and v[1] == '命中率' then
                固定 = true
            end
            if not 固定 then
                v[2] = r * (dj + 1)
            end
        end
        list[1].等级 = list[1].等级 + 1

        if list[1].装备类别 == "帽子" or list[1].装备类别 == "衣服" then
            list[1].名称 = list[1].原名 .. "#" .. list[1].等级 .. "_" .. list[1].条数
        end

        if list[1].等级 == 4 then
            __世界:发送系统(string.format(_神兵升级广播[1], self.名称, list[1].原名))
        elseif list[1].等级 == 5 then
            __世界:发送系统(string.format(_神兵升级广播[2], self.名称, list[1].原名))
        elseif list[1].等级 == 6 then
            __世界:发送系统(string.format(_神兵升级广播[3], list[1].原名, self.名称))

        end

        return { self.银子, string.format("#W好的，你的#Y%s#W已经升到了%s级。", list[1].原名, list[1].等级) }
    else
        return { self.银子, "精炼失败了#15" }
    end
end

--神兵精炼
function 角色:角色_提交神兵炼化材料(list)
    if not _检查物品(self, list) then
        return
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "神兵石" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local yzxh = 150000



    return { yzxh }

end

function 角色:角色_神兵炼化(list, 保留)
    if type(list) ~= 'table' then
        return
    end
    for i, nid in ipairs(list) do
        if __物品[nid] and __物品[nid].rid == self.id then
            list[i] = __物品[nid]
        else
            return
        end
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "神兵石" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if not list[1].数据.炼化属性 then
        保留 = false
    end
    local yzxh = 150000
    if self.银子 < yzxh then
        return '#Y你没有那么多银子！'
    end
    self:角色_扣除银子(yzxh)
    list[2]:减少(1)

    local k
    if list[1].装备类别 == "武器" then
        k = require("数据库/神兵炼化属性库")[list[1].种族]
    else
        k = require("数据库/神兵炼化属性库")[list[1].原名]
    end
    local sx = k[math.random(#k)]
    if list[1].原名 == '混元盘金锁' then
        if self:是否拥有属性(list[1].基本属性 , '速度') then
            print('敏链子,附加速度属性')
            sx = k[1]
        else
            print('抗链子,附加气血属性')
            sx = k[2]
        end
    end

    local r = {}
    for _, v in ipairs(sx) do
        r[v[1]] = v[2]
    end

    if 保留 then
        self.临时神兵炼化属性 = {}
        for _, v in pairs(sx) do
            table.insert(self.临时神兵炼化属性, { v[1], v[2] })
        end
        self.临时神兵炼化属性.nid = list[1].nid
        return "神兵炼化", r, self.银子, list[1].数据.炼化属性
    else
        list[1].数据.炼化属性 = {}
        for _, v in pairs(sx) do
            table.insert(list[1].数据.炼化属性, { v[1], v[2] })
        end
    end
    return "神兵炼化", r, self.银子
end

function 角色:是否拥有属性(装备, 属性)
    for k,v in pairs(装备) do
        if v[1] == 属性 then
            return true
        end
    end
    return false
end

--玩家:神兵精炼窗口()
-- 玩家:神兵炼化窗口()
--[[ 完成后 检测刷新  剩余次数  提醒  广播 提醒   佩戴属性  佩戴角色 神兵 仙器描述 ]]

function 角色:角色_提交神兵精炼材料(list)
    if type(list) ~= 'table' then
        return
    end
    for i, nid in ipairs(list) do
        if __物品[nid] and __物品[nid].rid == self.id then
            list[i] = __物品[nid]
        else
            return
        end
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "神兵石" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    local yzxh = 150000



    return { yzxh }

end

function 角色:角色_神兵精炼(list, 保留)
    -- if self.加锁状态 then
    --     self.接口:常规提示('#Y高级操作请先解除安全码!请不要将安全码透露给他人')
    --     return
    -- end
    if type(list) ~= 'table' then
        return
    end
    for i, nid in ipairs(list) do
        if __物品[nid] and __物品[nid].rid == self.id then
            list[i] = __物品[nid]
        else
            return
        end
    end
    if #list < 2 then
        return
    end
    if not list[1].神兵 then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if list[2].名称 ~= "神兵石" then
        return '#Y你提供的原料有问题，请重新执行一遍。'
    end
    if not list[1].数据.精炼属性 then
        保留 = false
    end
    local yzxh = 150000
    if 保留 then
        yzxh = 1500000
    end



    if self.银子 < yzxh then --
        return '#Y你没有那么多银子！'
    end
    self:角色_扣除银子(yzxh)
    list[2]:减少(1)
    local t = require("数据库/仙器炼化属性库")[list[1].装备类别]
    local sjsl = math.random(1,5)
    local list2 = {}
    local yjsl = 0
    -- table.print(t)
    -- print("~~~~~~~~~~~")
    while yjsl < sjsl do
        local sj = math.random(#t)
        local sx = t[sj]
        table.print(sx)
        if list2[sx.名称] == nil then
            list2[sx.名称] = 0
            if _整数范围[sx.名称] then
                list2[sx.名称] = list2[sx.名称] + math.random(sx.下限, sx.上限)
            else
                local sz = math.random(sx.下限 * 10, sx.上限 * 10) / 10
                list2[sx.名称] = list2[sx.名称] + sz
            end
            yjsl = yjsl + 1
        end
        if #t <= 0 then
            break
        end
    end

    if 保留 then
        self.临时神兵精炼属性 = {}
        for k, v in pairs(list2) do
            table.insert(self.临时神兵精炼属性, { k, v })
        end
        self.临时神兵精炼属性.nid = list[1].nid
        return "神兵精炼", list2, self.银子, list[1].数据.精炼属性
    else
        list[1].数据.精炼属性 = {}
        for k, v in pairs(list2) do
            table.insert(list[1].数据.精炼属性, { k, v })
        end
    end
    return "神兵精炼", list2, self.银子,{}
end

function 角色:角色_神兵精炼属性替换()
    if not self.临时神兵精炼属性 then
        return
    end
    if not self.临时神兵精炼属性.nid then
        return
    end
    local nid = self.临时神兵精炼属性.nid

    if __物品[nid] and __物品[nid].rid == self.id then

        local item = __物品[nid]
        item.数据.精炼属性 = {}
        for i, v in ipairs(self.临时神兵精炼属性) do
            table.insert(item.数据.精炼属性, { v[1], v[2] })
        end
        self.临时神兵精炼属性 = nil
        return item.数据.精炼属性
    end
end

--===============================================================================
--===============================================================================
function 角色:角色_打开作坊总管窗口()
    return self:角色_取作坊列表()
end

function 角色:提升作坊熟练(r, n)
    if r then
        if r.熟练度 < 100000 then
            r.熟练度 = r.熟练度 + math.floor(n)
            if r.熟练度 > 100000 then
                r.熟练度 = 100000
            end
            return r
        end
    end
end

function 角色:角色_提升作坊熟练(n, 次数)
    local tlxh = 次数 * 20
    local yzxh = 次数 * 100000
    if self.体力 < tlxh then
        return "#Y你的体力不足！"
    end
    if self.银子 < yzxh then
        return "#Y你的银两不足！"
    end
    local r = self.作坊[n]
    if r then
        if r.熟练度 < 100000 then
            local tj = 0
            for i = 1, 次数 do
                tj = tj + math.random(15, 25)
            end
            r.熟练度 = r.熟练度 + tj
            if r.熟练度 > 100000 then
                r.熟练度 = 100000
            end
            self:角色_扣除银子(yzxh)
            self:角色_扣除体力(tlxh)
            return r, self.体力, string.format("#Y%s获得%s点熟练度", r.名称, tj)
        else
            return "#Y熟练度达到上限！"
        end
    end
end

function 角色:角色_提升作坊等级(n)
    local r = self.作坊[n]
    if r then
        local slxh = (r.等级 + 1) * 2
        local yzxh = (r.等级 + 1) * 250
        if r.熟练度 < slxh then
            return "#Y你的熟练度不足！"
        end
        if self.银子 < yzxh then
            return "#Y你的银两不足！"
        end
        if r.等级 < 126 then
            r.等级 = r.等级 + 1
            self:角色_扣除银子(yzxh)
            r.熟练度 = r.熟练度 - slxh
            return r, string.format("#Y%s提升至%s级", r.名称, r.等级)
        else
            return "#Y等级度达到上限！"
        end
    end
end

local _等级需求 = { 8, 24, 40, 56, 72, 88, 104, 999 }
function 角色:角色_提升作坊段位(n)
    local r = self.作坊[n]
    if r then
        local djxh = _等级需求[r.段位 + 1]
        local yzxh = _等级需求[r.段位 + 1] * 250000
        if r.等级 < djxh then
            return "#Y你的等级不够！"
        end
        if self.银子 < yzxh then
            return "#Y你的银两不足！"
        end
        if r.段位 < 7 then
            r.段位 = r.段位 + 1
            self:角色_扣除银子(yzxh)
            return r, string.format("#Y%s提升至%s段", r.名称, r.段位)
        else
            return "#Y等级度达到上限！"
        end
    end
end
