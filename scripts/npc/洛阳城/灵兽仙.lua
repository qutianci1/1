local NPC = {}
local 对话 = [[
天地间的生物只要你有能力驾御都可以成为召唤兽，但是野外的召唤兽能力都不会很强。不过有的召唤兽历经磨难、修炼得道，我是可以帮你点化为更强的召唤兽的。这也就是召唤兽转生了。
menu
1|我要转生召唤兽
2|查看召唤兽转生规则
3|我只是路过看看]]
--2|我要点化召唤兽
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:取参战召唤兽()
        if r then
            r:转生处理()
        end
    elseif i == '2' then


    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
