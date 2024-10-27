-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-05-14 15:34:03
-- @Last Modified time  : 2023-06-29 00:58:05

local NPC = {}
local 对话 = [[
帮派者，家也，大凡英雄好汉,都少不了兄弟相帮。长安人来人往，我虽为小吏一员，但是世事洞明，凡事都逃不过我的眼睛!谁为帮派尽心尽职，谁为帮派成就之首!您可以找我帮您记录帮派成就,每记录一次,收取手续费#R100000两。
menu
1|我要撰写帮派成就册
2|我去做帮派任务了,再回
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local sl = 玩家.帮派数据.帮派成就
        if sl then
            if sl >= 2000 then
                local r = 玩家:整数输入窗口('', "请输入你要撰写的帮派成就数额,你现在身上有 "..sl.." 点成就")
                if r then
                    if sl < r then
                        return '你没有那么多成就'
                    end
                    if 玩家:扣除银子(100000) then
                        玩家:扣除成就(r)
                        玩家:添加物品({生成物品 {名称 = '帮派成就册', 参数 = r}})
                    end
                end
            else
                return '您的帮派成就才这么点,等达到2000以上再来找我吧!'
            end
        else
            return '帮派都没有,你给我捣什么乱!'
        end
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
