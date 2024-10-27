-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-06-04 19:44:00
-- @Last Modified time  : 2023-07-04 01:07:34

local NPC = {}
local 对话 = [[
在我这里可以报名参加水陆大会，只要你达到1转80级以上，找我报名即可。如果你没有队伍也可以找我，我可以帮你查找跟你等级差不多的朋友，不过报名费需要一次三万才行哦，阁下是否报名呢？
menu
1|我想要报名参加
2|我要进场
3|我想看看水陆大会规则
4|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if not 玩家.是否组队 then
            return '需要3个人以上的组队报名！'
        end
        if 玩家:获取水陆报名开关() then
            local r = 玩家:查询水陆报名队伍(玩家.nid)
            if r then
                玩家:水陆大会添加队伍(玩家.nid)
                return '报名成功,已成功记录队伍信息,请在周二晚20点之前以同队人员入场比武!'
            else
                return r
            end
        else
            return '当前非报名时间,请在周二当日19点40分之前组队报名'
        end
    elseif i == '2' then
        if not 玩家.是否组队 then
            return '需要3个人以上队伍才可以入场！'
        end
        if 玩家:获取水陆入场开关() then
            local t = 玩家:检查水陆队伍()
            if type(t) == 'string' then
                return t
            else
                玩家:切换地图(1197, 135, 20)
            end
        else
            return '当前非入场时间,请在周二当日19点45—19点59分时入场'
        end
    elseif i == '3' then
        return '报名时间：#r#G每周三凌晨—每周二19点之前为报名时间，错过无法补报#r#W入场时间：#r#G每周二19点45分—19：59分为入场时间#r#W战斗规则：#r#G每场战斗最多60回合,每场战斗结束后会有5分钟的调整时间。每场战斗开始前会发放临时药物，比赛结束后未使用完则会被回收#r#W胜负规则：#r#G超过60回合未分胜负则按照双方存活数来决定胜负，胜利方会夺取失败方的积分。'
    elseif i == '4' then
    end
end

return NPC
