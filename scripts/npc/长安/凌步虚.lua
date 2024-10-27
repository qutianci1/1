-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-05-22 20:43:30
-- @Last Modified time  : 2023-05-22 23:47:14

local NPC = {}
local 对话 = [[
想让兔小厨成为你练级、任务过称的不二帮手吗#40我的不传秘法能帮你进化兔小厨#2
menu
1|我要进化兔小厨(增加初始HP、初始SP各20点)
2|我要二次进化兔小厨(增加初始HP、初始SP各25点)
3|我要三次进化兔小厨(增加初始HP、初始SP各30点)
4|不着急我再想想
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local z = 玩家:取参战召唤兽()
        if z then
            if z.外形 == 8094 then
                if not z.进化 then
                    z.进化 = 0
                end
                if z.进化 ~= 0 then
                    return '你的兔小厨已完成首次进化'
                end
                if z.等级 < 50 and z.转生 == 0 then
                    return '你的兔小厨等级不足50'
                end
                z.进化 = 1
                -- z.初血 = z.初血 + 20
                -- z.初敏 = z.初敏 + 20
                z:刷新属性(20)
                return '你的兔小厨完成进化'
            end
        end
    elseif i == '2' then
        local z = 玩家:取参战召唤兽()
        if z then
            if z.外形 == 8094 then
                if not z.进化 then
                    z.进化 = 0
                end
                if z.进化 ~= 1 then
                    return '你的兔小厨已完成此次进化'
                end
                if z.等级 < 100 and z.转生 < 1 then
                    return '你的兔小厨等级不足1转100'
                end
                if 玩家:扣除银子(5000000) then
                    z.进化 = 2
                    -- z.初血 = z.初血 + 25
                    -- z.初敏 = z.初敏 + 25
                    z:刷新属性(25)
                    return '你的兔小厨完成二次进化'
                else
                    return '你的金钱不足5000000'
                end
            end
        end
    elseif i == '3' then
        local z = 玩家:取参战召唤兽()
        if z then
            if z.外形 == 8094 then
                if not z.进化 then
                    z.进化 = 0
                end
                if z.进化 ~= 2 then
                    return '你的兔小厨已完成此次进化'
                end
                if z.等级 < 120 and z.转生 < 2 then
                    return '你的兔小厨等级不足2转120'
                end
                if 玩家:扣除银子(20000000) then
                    z.进化 = 3
                    -- z.初血 = z.初血 + 30
                    -- z.初敏 = z.初敏 + 30
                    z:刷新属性(30)
                    return '你的兔小厨完成二次进化'
                else
                    return '你的金钱不足20000000'
                end
            end
        end
    elseif i == '4' then
    end
end

return NPC
