local NPC = {}
local 对话 = [[
本庙最近香火旺盛，来供奉的香火之客络绎不绝，不少游客在供奉香火之后会得到神明的庇佑。
menu
1|为本庙供奉香火
2|供奉香火介绍
3|我只是路过看看
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
