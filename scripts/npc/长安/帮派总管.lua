-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:21
-- @Last Modified time  : 2023-05-17 19:57:54

local NPC = {}
local 对话 = [[
我就是所有帮派的总管，你找我有什么事吗?
menu
1|我要建立帮派
2|我来响应帮派
3|我要加入帮派
99|我什么都不想做
]]
function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)--点击选项,客户端显示窗口,并将
    if i=="1" then
        local 名称, 宗旨 = 玩家:创建帮派窗口()
        if 名称 then
            local s = 玩家:取物品是否存在('圣旨')
            if not s then
                return "创建帮派需要圣旨,很显然你没有。"
            else
                s:减少(1)
            end
            if 玩家:帮派创建(名称,宗旨) then
                return "你开始申请创立帮派，等待他人响应。"
            end
        end
    elseif i == "2" then
        local list={}
        for k, v in 遍历帮派() do
            if v.响应 and v.响应<10 then
                table.insert( list, {名称=v.名称,响应=v.响应,创始人=v.帮主,宗旨=v.宗旨} )
            end
        end
        local 名称 = 玩家:响应帮派窗口(list)
        if 名称 then
            if 玩家:响应帮派(名称) then
                return "响应成功"
            end
        end
    elseif i == "3" then
        local list={}
        for k, v in 遍历帮派() do
            local n = v:取成员人数()
            if v.响应==10 then
                table.insert( list, {名称=v.名称,等级=v.等级,人数=n,帮主=v.帮主,宗旨=v.宗旨} )
            end
        end
        玩家:申请帮派窗口(list)
    elseif i == "4" then
        玩家:取消帮派()
    end
end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end

return NPC
