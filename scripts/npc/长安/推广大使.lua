-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:55
-- @Last Modified time  : 2023-05-20 18:23:10

local NPC = {}
local 对话 = [[
平时都不点我，每次都要给你礼物才来吗#78，要经常来找我玩啊。#44
menu
1|我要兑换CDK
2|我要推广
4|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:输入窗口('', "请输入你要兑换的CDK")
        if r then
            if r == 'txc2023' then
                if not 玩家.礼包 then
                    玩家.礼包 = {}
                end
                if 玩家.礼包[2023] then
                    return '你已领取过此礼包,做人不可以太贪心!'
                end
                if 玩家:添加召唤(生成召唤 { 名称 = '兔小厨' }) then
                    玩家.礼包[2023] = true
                    return '这只兔小厨,你可要好好对它,据说当它血脉返祖那天,会蜕变成神兽哦!'
                end
            else
                return '你输入的CDK不正确'
            end
            return 文本
        end
    elseif i == '2' then
        -- 玩家:添加物品({生成物品 {名称 = '人参果王', 数量 = 999}})
        -- 玩家:添加物品({生成物品 {名称 = '蟠桃王', 数量 = 999}})

    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
