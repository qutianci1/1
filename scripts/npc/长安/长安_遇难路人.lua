-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-12 01:07:39
-- @Last Modified time  : 2022-06-13 08:26:21
-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-12 01:05:47
-- @Last Modified time  : 2022-06-12 01:05:47
-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-12 01:05:01
-- @Last Modified time  : 2022-06-12 01:05:01


local NPC = {}
local 对话 = [[天杀的修罗占领了我们的家园，我现在只能到处流浪了#52我可以带领你去修罗古城和灵兽村，你随便给我点带路费就行了。
menu
修罗古城  
灵兽村 
我什么都不想做 
]]

--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='战斗测试' then
        --玩家:进入战斗('测试')
    elseif i=='物品测试' then
        --玩家:增加物品(生成道具('四叶花'))
    elseif i=='召唤兽测试' then
        --玩家:增加召唤(生成召唤('大海龟'))
    end
end



return NPC