-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-26 01:59:55
-- @Last Modified time  : 2024-03-15 19:31:28

local NPC = {}
local 对话 = [[快跑吧,炮灰?
menu
1|查看体力
2|点错了
]]

function NPC:NPC对话(玩家, i)
    if 玩家.帮派 ~= self.帮派.名称 then
        return '你不是我帮派成员'
    end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        return '目前守护神剩余体力：'..self.帮派.帮战体力
    end
end

return NPC
