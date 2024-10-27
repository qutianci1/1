-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-14 19:39:24
-- @Last Modified time  : 2023-07-01 23:11:39

local NPC = {}
local 对话 = [[我是帮派的账房管理，你们可以在我这给进行帮派资金捐献，可用来提高自身的法术抗性。
menu
我要捐钱
转让帮派成就
随便转转
]]
--其它对话
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '我要捐钱' then
        if not 玩家.帮派数据.帮派贡献 then
            玩家.帮派数据.帮派贡献 = 0
        end
        local r = 玩家:输入窗口('', "请输入你要捐献的数额,你现在身上有 "..玩家.银子.." 两银子")
        r = tonumber(r)
        if r then
            if type(r) ~= 'number' then
                return '请输入正确的数字'
            end
            if 玩家:扣除银子(r + 0) then
                玩家.帮派数据.帮派贡献 = 玩家.帮派数据.帮派贡献 + r
            end
            玩家:刷新属性()
            local 文本 = '非常好，干得不错，你还没选择帮派守护神，快去找帮派守护选择一项守护吧！'
            if 玩家.帮派数据.守护神 then
                文本 = '非常好，干得不错，你的帮派守护效果提升了！'
            end
            return 文本
        end
    elseif i == '转让帮派成就' then
        local r = 玩家:输入窗口('', "请输入你要转让的对象ID以及帮派成就#r格式: 目标ID@成就数量#r你现在拥有 "..玩家.帮派数据.帮派成就.." 成就")
        if r then
            local str = 分割文本(r , '@')
            local str = 分割文本(r , '@')
            if str[1] == nil or str[2] == nil then
                return
            end
            str[1] = tonumber(str[1])
            str[2] = tonumber(str[2])
            if type(str[1]) ~= 'number' or type(str[2]) ~= 'number' then
                return '请输入正确的数字'
            end
            if str[1] and str[2] then
                local id = str[1]
                local 数量 = str[2]
                if 玩家.帮派数据.帮派成就 < 数量 then
                    玩家:提示窗口('#Y你没有那么多成就')
                    return
                end
                local P = 玩家:取帮派成员(id)
                if P then
                    local mb = 玩家:取玩家(P.NID)
                    if mb then
                        玩家:扣除成就(str[2])
                        if not mb.帮派数据.帮派成就 then
                            mb.帮派数据.帮派成就 = 0
                        end
                        mb.帮派数据.帮派成就 = mb.帮派数据.帮派成就 + str[2]
                        mb.rpc:提示窗口('#Y你获得来自#G'..玩家.名称..'#Y转让的'..str[2]..'成就')
                        玩家:提示窗口('#Y已完成成就转让')
                        local 文本 = '#67 [帮派账房]#R'..玩家.名称..'转让了'..str[2]..'点成就给'..mb.名称..''
                        玩家:发送帮派公告(文本)
                        玩家:聊天框提示()
                    end
                end
            end
        end
    end
end

return NPC
