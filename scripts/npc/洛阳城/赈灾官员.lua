-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-06-04 19:43:59
-- @Last Modified time  : 2023-08-25 05:27:46

local NPC = {}
local 对话 = [[
我是寻找那批失落镖银的官员。如果大侠能找到哪批镖银，下官感激不尽。
menu
1|兑换全部镖银
2|我要给与你镖银
3|我只是路过看看
]]


local 普通药 = {'千年熊胆','玫瑰仙叶','仙鹿茸','修罗玉','海蓝石','夜叉石'}
local 双加 = {'清风白雪','清风白雪','清风白雪','餐风饮露','餐风饮露','白露为霜','红雪散','孔雀明王羽','五龙圣丹'}
local 高级双加 = {'金风玉露','金风玉露','金风玉露','金风玉露','杜若无心','杜若无心','杜若无心','太乙玄黄丹','华韵流光'}
local 药品列表 = {普通药, 双加, 高级双加}
local 数量配置 = {10 , 5 , 1}

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local 数量 = 玩家:物品_获取数量('赈灾之银')
        local 随机 = math.random(1,100)
        local 品质 = 0
        if 随机 < 15 then
            品质 = 3
        elseif 随机 < 35 then
            品质 = 2
        else
            品质 = 1
        end
        if 数量 then
            for i=1,数量 do
                if 玩家:检查空位() then
                    local r = 生成物品 { 名称 = 药品列表[品质][math.random(1 , #药品列表[品质])], 数量 = 数量配置[品质] }
                    if r then
                        玩家:添加物品({ r })
                    end
                else
                    return '你的物品栏已满,无法继续获得物品'
                end
                local d = 玩家:取物品是否存在('赈灾之银')
                d:减少(1)
                if 玩家:检查空位() then
                    local 奖励 = 是否奖励(2002,玩家.等级,玩家.转生)
                    if 奖励 ~= nil and type(奖励) == 'table' then
                        local r = 生成物品 { 名称 = 奖励.道具信息.道具, 数量 = 奖励.道具信息.数量, 参数 = 奖励.道具信息.参数 }
                        if r then
                            玩家:添加物品({ r })
                            if 奖励.道具信息.是否广播 == 1 and 奖励.广播 ~= nil then
                                玩家:发送系统(奖励.广播, 玩家.名称, r.ind, r.名称)
                            end
                        end
                    end
                else
                    return '你的物品栏已满,无法继续获得物品'
                end
            end
        else
            return '本官很忙,如果你没有赈灾之银就走开!'
        end
    elseif i == '2' then
        玩家:打开给予窗口(self.nid)
    elseif i == '3' then
    elseif i == '4' then
    end
end

function NPC:NPC给予(玩家, cash, items)
    if items[1] and items[1].名称 == '赈灾之银' then
        local 数量 = items[1].数量
        local 随机 = math.random()
        local 品质 = 0
        if 随机 < 15 then
            品质 = 3
        elseif 随机 < 35 then
            品质 = 2
        else
            品质 = 1
        end
        if 数量 then
            for i=1,数量 do
                if 玩家:检查空位() then
                    local r = 生成物品 { 名称 = 药品列表[品质][math.random(1 , #药品列表[品质])], 数量 = 数量配置[品质] }
                    if r then
                        玩家:添加物品({ r })
                    end
                else
                    玩家:最后对话('你的物品栏已满,无法继续获得物品', self.外形)
                    return
                end
                local d = 玩家:取物品是否存在('赈灾之银')
                d:减少(1)
                if 玩家:检查空位() then
                    local 奖励 = 是否奖励(2002,玩家.等级,玩家.转生)
                    if 奖励 ~= nil and type(奖励) == 'table' then
                        local r = 生成物品 { 名称 = 奖励.道具信息.道具, 数量 = 奖励.道具信息.数量, 参数 = 奖励.道具信息.参数 }
                        if r then
                            玩家:添加物品({ r })
                            if 奖励.道具信息.是否广播 == 1 and 奖励.广播 ~= nil then
                                玩家:发送系统(奖励.广播, 玩家.名称, r.ind, r.名称)
                            end
                        end
                    end
                else
                    玩家:最后对话('你的物品栏已满,无法继续获得物品', self.外形)
                end
            end
        else
            玩家:最后对话('本官很忙,如果你没有赈灾之银就走开!', self.外形)
        end
        return
    end
    玩家:最后对话('你给我什么东西？', self.外形)
    return
end

return NPC
