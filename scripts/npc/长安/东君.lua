-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:21
-- @Last Modified time  : 2023-08-25 21:37:03
local NPC = {}
local 对话 = [[
今年花开特别迟。人都说东君袖手容风雪，春事凭谁做主张。其实这关我什么事#52花神们都被抓的抓贬的贬，赶快来个人去把她们救出来吧，55555~
menu
1|别哭了，怜香惜玉的风流侠士们来帮你救人了
2|告诉我规则
3|帮我把临时积分转成正式积分
4|兑换奖励
5|路过而已
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        if not 玩家.是否组队 then
            玩家:常规提示('#Y需要3个人以上的组队来帮我！')
            return
        end
        if 玩家:取活动限制次数('寻芳任务') >= 1 then
            return '在你的帮助下,花神们被救出来了,谢谢你袄~'
        end
        local t = {}
        for _, v in 玩家:遍历队伍() do
            if v:判断等级是否低于(80) then
                table.insert(t, v.名称)
            end
        end
        if #t > 0 then
            玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于80级,无法领取')
            return
        end
        for _, v in 玩家:遍历队伍() do
            if v:获取时间宠等级() < 20 then
                table.insert(t, v.名称)
            end
        end
        if #t > 0 then
            玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W宠物等级不足20,无法领取')
            return
        end
        for _, v in 玩家:遍历队伍() do
            if v:取活动限制次数('寻芳任务') > 1 then
                table.insert(t, v.名称)
            end
        end
        if #t > 0 then
            玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W本日已完成寻芳任务,无法继续挑战')
            return
        end
        local r = 玩家:取任务('日常_寻芳任务')
        if r then
            r:删除()
        end
        local r = 生成任务 {名称 = '日常_寻芳任务'}
        if r then
            local 地图 = 生成地图(1291)
            地图:添加NPC {
                    名称 = "东君",
                    外形 = 50,
                    脚本 = 'scripts/npc/副本/寻芳/东君.lua',
                    X = 73,
                    Y = 71}
            地图:添加NPC {
                    名称 = "超级巫医",
                    外形 = 3001,
                    脚本 = 'scripts/npc/超级巫医.lua',
                    X = 85,
                    Y = 65}
            地图:添加NPC {
                    名称 = "封印的花神",
                    外形 = 3061,
                    脚本 = 'scripts/npc/副本/寻芳/封印的花神.lua',
                    X = 65,
                    Y = 65}
            r:添加任务(玩家)
            玩家:切换地图2(地图, 1480,1200)
        end
    elseif i == '2' then
        return '玩家在幻境中成功解除花神封印会获得临时积分,这些临时积分可以在离开场景后找东君转换为积分,或完成所有挑战后自动把临时积分转为积分。在转换积分前,你可以重新进入幻境挑战,但是在转换积分后则无法再次进入。'
    elseif i == '3' then
        local r = 玩家:取任务("日常_寻芳任务")
        if r then
            if not 玩家.积分.寻芳积分 then
                玩家.积分.寻芳积分 = 0
            end
            玩家.积分.寻芳积分 = 玩家.积分.寻芳积分 + r.积分
            玩家:提示窗口('#Y寻芳临时积分已结算,本日获得#G'..r.积分..'#Y寻芳积分,本日已无法再次挑战。')
            玩家:增加活动限制次数('寻芳任务')
        else
            return '你今天还没有开始挑战或已完成转换积分。'
        end
    elseif i == '4' then
    end
end

return NPC
