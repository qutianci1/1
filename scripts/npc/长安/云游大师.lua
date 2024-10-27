-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:55
-- @Last Modified time  : 2023-05-22 21:06:39

local NPC = {}

function NPC:NPC对话(玩家, i)
    return string.format('大唐盛世,人人安居乐业。社会安定固是好事,可对一些新来的朋友而言，无匪寇则少游侠，这江湖却也略显冷漠了些。大师我也有一个梦，即看到天下所有人皆是一家,强者能够帮助弱者。这里有一些需要帮助的人的替身，希望你能热心扶持这些迷茫中的新人。或许在这个过程中,你也能找到自己当年的影子。善哉善哉。你当前的活力值为:#G%s\nmenu\n1|我是大侠,让我来帮助新人\n2|我临时有事取消任务\n3|没事路过,多有叨扰',玩家.活力)
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
    elseif i == '4' then
    end
end

return NPC
