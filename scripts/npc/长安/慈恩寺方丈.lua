-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:55
-- @Last Modified time  : 2023-08-25 21:37:43

local NPC = {}
local 对话 = [[
雁塔佛地竟出现妖魔怨气，为了天下生灵，侠士您愿意赶赴塔中，为镇妖封魔而战吗？(流程测试)
menu
1|快送我去镇妖封魔
2|请大师告诉我详情
3|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if not 玩家.是否组队 then
            玩家:常规提示('#Y此去危险重重,还是多叫几个小伙伴吧！')
            return
        end
        if 玩家:取活动限制次数('大雁塔任务') >= 1 then
            return '你的今日已经完成大雁塔任务'
        end
        if 玩家:取任务('日常_大雁塔任务') then
            return
        end
        local t = {}
        for _, v in 玩家:遍历队伍() do
            if v:判断等级是否低于(60) then
                table.insert(t, v.名称)
            end
        end
        if #t > 0 then
            玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W你太年轻了,还是再去历练一番吧,至少等级达到60级')
            return
        end
        for _, v in 玩家:遍历队伍() do
            if v:取任务('日常_大雁塔任务') then
                table.insert(t, v.名称)
            end
        end
        if #t > 0 then
            玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取')
            return
        end
        local r = 生成任务 { 名称 = '日常_大雁塔任务' }
        if r and r:添加任务(玩家) then
            -- local 地图 = {
            --     生成地图(1004),
            --     生成地图(1005),
            --     生成地图(1006),
            --     生成地图(1007),
            --     生成地图(1008),
            --     生成地图(1090),
            -- }
            -- local map = 地图[1]
            -- 玩家:切换地图2(map, 280,1700)--280,1700
            -- map:添加NPC {
            --     名称 = "慈恩寺方丈",
            --     外形 = 3031,
            --     脚本 = 'scripts/npc/副本/大雁塔/慈恩寺方丈.lua',
            --     X = 136,
            --     Y = 70}
            玩家:切换地图(1004, 121, 68)
            玩家:刷新追踪面板()
            玩家:增加活动限制次数('大雁塔任务')
        end
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
