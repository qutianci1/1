local NPC = {}
local 对话 = [[
我就是千里眼，天上凡间一草一木都逃不过我的法眼，要是你要找人找我就没错了。#2不过帮你没问题，给50000两辛苦费就行。找人可是很费神的。#17
menu
1|呀，你帮我找找
2|我只是路过看看
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
