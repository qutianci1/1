-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-06-25 22:17:51
-- @Last Modified time  : 2023-07-04 00:28:39

local 装备 = class('装备')

function 装备:初始化()
end

function 装备:生成帽子()
end

function 装备:生成衣服()
end

function 装备:生成鞋子()
end

function 装备:生成武器()
end

function 装备:生成项链()
end

function 装备:检查要求(P)
    local l = self.等级需求
    if l and P.等级 < l[1] and (not l[2] or P.转生 <= l[2]) then
        return '#R等级或转生不足'
    end
    -- if l and l[2] and P.转生 < l[2] then
    --     return '#R等级不足'
    -- end

    l = self.属性要求
    if l and P[l[1]] + P.装备属性[l[1]] < l[2] then
        return '#R属性不足'
    end

    if self.角色 and not self.角色[P.原形] then
        return '#R角色不符合要求'
    end
    if self.性别 ~= 0 and self.性别 ~= P.性别 then
        return '#R性别不符合要求'
    end

    return true
end

local _非抗性 = {
    根骨 = true,
    灵性 = true,
    力量 = true,
    敏捷 = true,
    附加攻击 = true,
    基础攻击 = true,
    附加气血 = true,
    附加魔法 = true,
    附加速度 = true,
    气血增加率 = true,
    魔法增加率 = true,
    速度 = true
}



local _角色武器模型 = {
    [1] = { 扇 = 1, 剑 = 19, 默认 = 1 },
    [19] = { 扇 = 1, 剑 = 19, 默认 = 1 },
    [2] = { 锤 = 20, 剑 = 2, 默认 = 2 },
    [20] = { 锤 = 20, 剑 = 2, 默认 = 2 },
    [3] = { 拳 = 3, 斧 = 21, 默认 = 3 },
    [21] = { 拳 = 3, 斧 = 21, 默认 = 3 },
    [4] = { 刀 = 4, 枪 = 22, 默认 = 4 },
    [22] = { 刀 = 4, 枪 = 22, 默认 = 4 },
    [5] = { 钩 = 5, 鞭 = 23, 默认 = 5 },
    [23] = { 钩 = 5, 鞭 = 23, 默认 = 5 },
    [6] = { 刀 = 6, 棒 = 24, 默认 = 6 },
    [24] = { 刀 = 6, 棒 = 24, 默认 = 6 },
    [7] = { 刀 = 7, 枪 = 25, 默认 = 7 },
    [25] = { 刀 = 7, 枪 = 25, 默认 = 7 },
    [8] = { 刀 = 8, 幡 = 26, 默认 = 8 },
    [26] = { 刀 = 8, 幡 = 26, 默认 = 8 },
    [9] = { 棒 = 9, 枪 = 27, 默认 = 9 },
    [27] = { 棒 = 9, 枪 = 27, 默认 = 9 },
    [10] = { 爪 = 10, 鞭 = 28, 默认 = 10 },
    [28] = { 爪 = 10, 鞭 = 28, 默认 = 10 },
    [11] = { 棒 = 11, 剑 = 29, 默认 = 11 },
    [29] = { 棒 = 11, 剑 = 29, 默认 = 11 },
    [12] = { 钩 = 12, 刀 = 30, 默认 = 12 },
    [30] = { 钩 = 12, 刀 = 30, 默认 = 12 },
    [13] = { 枪 = 13, 锤 = 31, 默认 = 13 },
    [31] = { 枪 = 13, 锤 = 31, 默认 = 13 },
    [14] = { 棒 = 14, 爪 = 32, 默认 = 14 },
    [32] = { 棒 = 14, 爪 = 32, 默认 = 14 },
    [15] = { 拂 = 15, 剑 = 33, 默认 = 15 },
    [33] = { 拂 = 15, 剑 = 33, 默认 = 15 },
    [16] = { 飘 = 16, 棒 = 34, 默认 = 16 },
    [34] = { 飘 = 16, 棒 = 34, 默认 = 16 },
    [17] = { 拳 = 17, 环 = 35, 默认 = 17 },
    [35] = { 拳 = 17, 环 = 35, 默认 = 17 },
    [18] = { 枪 = 18, 剑 = 36, 默认 = 18 },
    [36] = { 枪 = 18, 剑 = 36, 默认 = 18 },
    [60] = { 枪 = 60, 拳 = 66, 默认 = 60 },
    [66] = { 枪 = 60, 拳 = 66, 默认 = 60 },
    [61] = { 书 = 61, 幡 = 67, 默认 = 61 },
    [67] = { 书 = 61, 幡 = 67, 默认 = 61 },
    [62] = { 剑 = 62, 刀 = 68, 默认 = 62 },
    [68] = { 剑 = 62, 刀 = 68, 默认 = 62 },
    [63] = { 灯 = 63, 环 = 69, 默认 = 63 },
    [69] = { 灯 = 63, 环 = 69, 默认 = 63 },
    [64] = { 飘 = 64, 环 = 70, 默认 = 64 },
    [70] = { 飘 = 64, 环 = 70, 默认 = 64 },
    [65] = { 鞭 = 65, 钩 = 71, 默认 = 65 },
    [71] = { 鞭 = 65, 钩 = 71, 默认 = 65 },
}

function 装备:穿上(P)
    local 装备属性 = P.装备属性
    local 装备抗性 = P.装备抗性
    self.是否有效 = nil
    if self.装备类别 == "武器" then
        if _角色武器模型[P.原形] then
            P.武器 = _角色武器模型[P.原形][self.装备类型]
            --如果 not 变身 不刷新外形 只刷新原形  变身取消时=原形
           -- P.外形 = P.武器
        end
    end
    for _, l in ipairs { "基本属性", "精炼属性", "炼化属性", "炼器属性", "默契属性" } do
        if self[l] then
            for _, v in ipairs(self[l]) do
                local k = v[1]
                if _非抗性[k] then
                    装备属性[k] = 装备属性[k] + v[2]
                else
                    装备抗性[k] = 装备抗性[k] + v[2]
                end
            end
        end
    end
    return true
end

function 装备:脱下(P)
    local 装备属性 = P.装备属性
    local 装备抗性 = P.装备抗性
    self.是否有效 = false
    if self.装备类别 == "武器" then
        if _角色武器模型[P.原形] then
            P.武器 = nil
            --如果 not 变身 不刷新外形 只刷新原形  变身取消时=原形
          --  P.外形 = P.武器
        end
    end
    for _, l in ipairs { "基本属性", "精炼属性", "炼化属性", "炼器属性", "默契属性" } do
        if self[l] then
            for _, v in ipairs(self[l]) do
                local k = v[1]
                if _非抗性[k] then
                    装备属性[k] = 装备属性[k] - v[2]
                else
                    装备抗性[k] = 装备抗性[k] - v[2]
                end
            end
        end
    end
    return self
end

return 装备
