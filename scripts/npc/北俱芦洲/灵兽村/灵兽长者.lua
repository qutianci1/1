local NPC = {}
local 对话 = [[
万众归心，天下大统。唯我大唐盛世！
menu
1|合成精卫-天书残卷4、5、6、6、7、8
2|合成迦楼罗王-天书残卷3、4、6、6、7、9
3|合成冥灵妃子-天书残卷3、5、6、6、8、9
4|合成狮蝎-天书残卷1、2、4、5
5|合成罗刹鬼姬-天书残卷1、2、4、6
6|合成雷兽-天书残卷2、3、4、5
7|合成哥俩好-天书残卷2、3、4、6
8|合成剑精灵-天书残卷3、4、5、6
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
