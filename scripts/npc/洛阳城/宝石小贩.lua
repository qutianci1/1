local NPC = {}
local 对话 = [[
收宝石喽，收宝石喽，童叟无欺，洛阳城外仅此一家。走过路过不要错过。
menu
1|我要25万购买不可交易的宝石
2|我要250万购买不可交易的宝石
3|我要2500万购买不可交易的宝石
4|我只是路过看看
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
