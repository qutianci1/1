-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-30 20:04:58
-- @Last Modified time  : 2023-09-01 02:57:36

local NPC = {}
local 对话 = [[
恭喜发财这里是最大的连锁钱庄，提供零存整取，整存零取，存钱不取，不存不取等多项服务，另外还有保险箱特殊服务!客官，想做点什么?
menu
1|我的钱太多了，想存起来
2|我没有钱花了，想把存款拿出来
3|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:金钱输入窗口('', "请输入你要存款的数额,你现在身上有 "..玩家.银子.." 两银子")
        if r then
            if r > 玩家.银子 then
                return '你逗我玩呢,去去去!'
            end
            if 玩家:存款操作(r) then
                return '已存款,欢迎下次光临#93'
            end
        end
    elseif i == '2' then
        玩家:取款()
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
