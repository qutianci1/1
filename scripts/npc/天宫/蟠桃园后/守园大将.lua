local NPC = {}
local 对话 = [[
这里的蟠桃可是五百年一开花，五百年一结果，五百年一熟的呀～
menu
1|有什么可以帮忙的
2|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        --检测等级
        --检测组队
        --检测次数
        if 玩家:取任务('日常_任务链') then
            return '你还有任务没有完成!'
        end
        local r = 生成任务 { 名称 = '日常_任务链' }
        if r then
            if 玩家:添加任务(r) then
                return r:添加任务(玩家)
                -- 玩家:增加活动限制次数('任务链')
            end
        end
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
