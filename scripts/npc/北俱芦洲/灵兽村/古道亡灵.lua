-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-13 08:38:04
-- @Last Modified time  : 2022-06-17 00:46:04
local NPC = {}
local 对话 = [[前面就是传说中的修罗古城了。那是一个美丽而富饶的地方，有着遍地的黄金，却居住形形色色的人鬼魔神，……这些年来，不少年轻人做着发财梦踏入了那片古老的土地。在那里，有人一夜间成为富可敌国的大豪，更多的人却永远失去了生命甚至灵魂。你执意前往吗?
menu
我要出灵兽村
我可不想冒险。
]]
--其它对话
function NPC:NPC对话(玩家,i)
    return 对话
end


function NPC:NPC菜单(玩家,i)
    if i=='我要出灵兽村' then
        玩家:切换地图(1001, 250, 97)
    end
end



return NPC