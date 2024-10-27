-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-04-12 14:27:11
-- @Last Modified time  : 2024-05-09 20:43:29

local NPC = {}
local 对话 = [[
南无阿弥陀佛
]]

function NPC:NPC对话(玩家, i)
    return string.format('善哉善哉#86找我可领取元气蛋哦#89去野外帮助孵化吧#28。\nmenu\n3|我来领取元气蛋\n4|没事路过,多有叨扰',玩家.活力)
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then

        if 玩家:取任务('日常_五环任务') then
            return '你的任务还没有完成'
        end
        if 玩家.活力 < 600 then
            return '你的活力不足600。'
        end
        if 玩家.等级 < 80 then
            return '你的等级太低了,80级以后再来吧。'
        end
        local c = 玩家:取宠物信息()
        if c then
            if c.等级 then
                if c.等级 < 15 then
                    return '你的宠物等级不足15。'
                end
            else
                return '获取错误等级失败'
            end
        else
            return '没有找到你的宠物。'
        end
        if 玩家:取活动限制次数('五环任务') >= 1 then
            return '你的今日已经帮助过他人了,明天再来吧'
        end
        玩家.活力 = 玩家.活力 - 600
        local r = 生成任务 { 名称 = '日常_五环任务' }
        if r then
            if 玩家:添加任务(r) then
                r:添加任务(玩家)
                玩家:增加活动限制次数('五环任务')
                return '成功领取任务,快去帮你的第一个目标吧'
            end
        end
    elseif i == '2' then
        local r = 玩家:取任务('日常_五环任务')
        if r then
            r:任务取消(玩家)
            return '你取消了任务'
        end
     elseif i == '3' then
         if 玩家:取物品是否存在("元气蛋") then
             return '你已经领取过宠物蛋了！'
         end
         local r = 生成物品 {名称 = "元气蛋", 血气 = {0,100} ,禁止交易=true}
         if r then
             玩家:添加物品({r})
         end
    elseif i == '3' then
    end
end

return NPC
