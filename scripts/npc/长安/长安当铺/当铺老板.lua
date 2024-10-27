-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-29 08:42:29
-- @Last Modified time  : 2023-04-18 06:17:29
local NPC = {}
local 对话 = [[
在我这里存放物品，绝对安全，童叟无欺。
menu
1|我想看看我当铺里有什么东西
2|给我当铺增加物品栏
3|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:当铺窗口()
    elseif i=='2' then
        玩家:增加当铺()
    end
end

return NPC
