-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:55
-- @Last Modified time  : 2023-05-17 19:09:43

local NPC = {}
local 对话 = [[
前段时间一群小神兽下凡帮助有缘人，如果能历经磨难修成正果便可在此飞升成真正的神兽！要是您有神兽我可以帮你神兽飞升！
menu
1|我的神兽需要飞升
2|给我的神兽更换造型
3|我有神兽碎片，我来换神兽
4|我只是路过看看
]]
local 飞升选择 = [[
请选择一项你想要提升的初值
menu
初血
初法
初攻
初敏
]]
local 更换外观 = [[
你要变成什么？（更改一次造型需10000000金钱）
menu
原始外观
一飞外观
二飞外观
]]
local 兑换神兽 = [[
请选择您要兑换的类型（请预留好召唤兽位置，否则无法获得神兽）
menu
我要用90个神兽碎片来兑换神兽
取消
]]


function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:取参战召唤兽()
        if r then
            local 结果 = r:飞升处理()
            if 结果 then
                return 飞升选择
            end
        else
            return "请先将要飞升的召唤兽设置参战！"   
        end
    elseif i == '2' then
        local r = 玩家:取参战召唤兽()
        if r then
            return 更换外观
        else
            return "请先将要更换外观的召唤兽设置参战！"
        end
    elseif i == '3' then
        return 兑换神兽
    elseif i == '初血' or i == '初法' or i == '初攻' or i == '初敏' then
        local r = 玩家:取参战召唤兽()
        if r then
            r:飞升3处理(i)
        else
            return "请先将要飞升的召唤兽设置参战！"
        end
    elseif i == '原始外观' or i == '一飞外观' or i == '二飞外观' then
        local r = 玩家:取参战召唤兽()
        if r then
            r:神兽更换造型(i)
        else
            return "请先将要更换外观的召唤兽设置参战！"
        end
    elseif i == '我要用90个神兽碎片来兑换神兽' then
        return 玩家:兑换神兽()
    end
end

return NPC
