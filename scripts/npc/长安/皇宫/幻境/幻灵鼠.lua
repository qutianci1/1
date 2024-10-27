-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-09-04 04:06:23
-- @Last Modified time  : 2023-09-05 14:26:05

local NPC = {}
local 对话 = [[
找什么?这个幻境的每一个角落，我都知道有什么，你想让我帮你找的话，需要消耗一个天机密令。
menu
4|我要出地宫
5|我再准备一下
]]

function NPC:NPC对话(玩家, i)
    local 等级 = 玩家:取队伍最高等级()
    local 对话 = 对话
    if 等级 >= 100 and 等级 < 120 then
        对话 = [[找什么?这个幻境的每一个角落，我都知道有什么，你想让我帮你找的话，需要消耗一个天机密令。
menu
1|挑战100级地宫
2|挑战100级卓越地宫
3|没事,看看你而已,不要害羞
4|我要出地宫
]]
    elseif 等级 >= 120 and 等级 < 140 then
        对话 = [[找什么?这个幻境的每一个角落，我都知道有什么，你想让我帮你找的话，需要消耗一个天机密令。
menu
1|挑战120级地宫
2|挑战120级卓越地宫
3|没事,看看你而已,不要害羞
4|我要出地宫
]]
    elseif 等级 >= 140 and 等级 <= 180 then
        对话 = [[找什么?这个幻境的每一个角落，我都知道有什么，你想让我帮你找的话，需要消耗一个天机密令。
menu
1|挑战140级地宫
2|挑战140级卓越地宫
3|没事,看看你而已,不要害羞
4|我要出地宫
]]
--     elseif 等级 >= 160 and 等级 <= 180 then
--         对话 = [[找什么?这个幻境的每一个角落，我都知道有什么，你想让我帮你找的话，需要消耗一个天机密令。
-- menu
-- 1|挑战160级地宫
-- 2|挑战160级卓越地宫
-- 2|没事,看看你而已,不要害羞
-- ]]
    end
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local 等级 = 玩家:取队伍最高等级()
        if not 玩家.是否组队 then
            玩家:常规提示('#Y需要3个人以上的组队来帮我！')
            return
        end
        if 玩家:取活动限制次数('地宫挑战') > 1 then
            return '每天最多完成两次地宫挑战'
        end
        --for _, v in 玩家:遍历队伍() do
           -- if v:获取时间宠等级() < 20 then
              --  table.insert(t, v.名称)
            --end
        --end
        --if #t > 0 then
          --  玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W宠物等级不足20,无法领取')
           -- return
        --end
        for _, v in 玩家:遍历队伍() do
            if v:取活动限制次数('地宫挑战') > 1 then
                table.insert(t, v.名称)
            end
        end
      --  if #t > 1 then
         --   玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W本日已完成地宫挑战,无法继续挑战')
          --  return
        --end
        for _, v in 玩家:遍历队伍() do
            local rr = v:取任务('日常_地宫挑战')
            if rr then
                rr:删除()
            end
        end


        if 等级 >= 100 and 等级 < 120 then
            local r = 生成任务 { 名称 = '日常_地宫挑战' }
            if r then
                r:添加任务(玩家, 1 , 1)
            end
        elseif 等级 >= 120 and 等级 < 140 then
            local r = 生成任务 { 名称 = '日常_地宫挑战' }
            if r then
                r:添加任务(玩家, 2 , 1)
            end
        elseif 等级 >= 140 and 等级 <= 180 then
            local r = 生成任务 { 名称 = '日常_地宫挑战' }
            if r then
                r:添加任务(玩家, 3 , 1)
            end
        -- elseif 等级 >= 160 and 等级 <= 180 then
        --     local r = 生成任务 { 名称 = '日常_地宫挑战' }
        --     if r then
        --         r:添加任务(玩家, 4 , 1)
        --     end
        else
            return '你的等级不足,无法挑战地宫'
        end
    elseif i == '2' then
        local 等级 = 玩家:取队伍最高等级()
        if 等级 >= 100 and 等级 < 120 then
            local r = 生成任务 { 名称 = '日常_地宫挑战' }
            if r then
                r:添加任务(玩家, 1 , 2)
            end
        elseif 等级 >= 120 and 等级 < 140 then
            local r = 生成任务 { 名称 = '日常_地宫挑战' }
            if r then
                r:添加任务(玩家, 2 , 2)
            end
        elseif 等级 >= 140 and 等级 <= 180 then
            local r = 生成任务 { 名称 = '日常_地宫挑战' }
            if r then
                r:添加任务(玩家, 3 , 2)
            end
        -- elseif 等级 >= 160 and 等级 <= 180 then
        --     local r = 生成任务 { 名称 = '日常_地宫挑战' }
        --     if r then
        --         r:添加任务(玩家, 4 , 2)
        --     end
        else
            return '你的等级不足,无法挑战地宫'
        end
    elseif i == '3' then
    elseif i == '4' then
        玩家:切换地图(1003, 226, 10)
    end
end

return NPC
