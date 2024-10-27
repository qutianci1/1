-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-06-04 19:43:58
-- @Last Modified time  : 2024-02-24 13:48:09

local NPC = {}
local 对话 = [[
看什么？我是地府守库房的，你想抢钱啊？看来是要教训一下你了！不过你如果肯给我10000两银子，我倒可以给你些冥钞，哈哈。
menu
1|我就是来抢钱的，看谁教训谁！
2|我要买张冥钞。（扣除1万两银子）
3|我只是路过看看]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:进入战斗('scripts/war/转鬼.lua')
    elseif i == '2' then
        local r = 玩家:取物品是否存在("冥钞")
        if r then
            return "你身上拥有该道具了！"
        end
        if 玩家.银子<10000 then
            return "你的银两不足！"
        end
        玩家:扣除银子(10000)
        玩家:添加物品({ 生成物品 { 名称 = '冥钞', 数量 = 1 } }) 

    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
