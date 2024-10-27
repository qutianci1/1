-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:55
-- @Last Modified time  : 2024-02-23 23:09:18

local NPC = {}
local 对话 = [[
至富可敌贵，天子天下之贵，元宝天下之富！阁下此来有何贵干？
menu
1|领取法宝
2|查询法宝
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local _法宝 = {"银索金铃","将军令","大势锤","七宝玲珑塔","黑龙珠","幽冥鬼手","大手印","绝情鞭","情网","宝莲灯","金箍儿","锦襕袈裟","白骨爪","化蝶"}
        for n=1,#_法宝 do
            if not 玩家:取是否拥有法宝(_法宝[n]) then
                玩家:添加法宝(_法宝[n])
            else
                return '你已拥有相同法宝,做人不可以贪心!'
            end
        end

    elseif i == '2' then
        local r = 玩家:获取法宝()
        if r then
            table.print(r)
        end
    end
end

return NPC
