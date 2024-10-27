-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-30 20:04:58
-- @Last Modified time  : 2023-10-27 03:38:56

local NPC = {}
local 对话 = [[
我平时就是走街串巷的收点破烂。你有什么不需要的废品吗?卖不？照顾下生意啊#14
menu
1|我要卖点东西
2|怎么个卖法？
3|离开
]]

local 收购价格 = {
    九彩云龙珠=3000,
    血玲珑=9000,
    内丹精华=18000,
    百炼精铁=20000,
}

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:打开给予窗口(self.nid)
    elseif i == '2' then
        local 文本 = ''
        for k,v in pairs(收购价格) do
            文本 = 文本..'#G'..k..'#Y:'..v..'  '
        end
        return '只要把你不需要的东西给予我,我会给出相应的回收价格,当前收购行情\n'..文本
    elseif i == '3' then
    elseif i == '4' then
    end
end

function NPC:NPC给予(玩家, cash, items)
    if items[1] and items[1].名称 and items[1].数量 and items[1].数量 >= 1 then
        if 收购价格[items[1].名称] then
            local x = 玩家:选择窗口(items[1].名称..'回收总价'..银两颜色(收购价格[items[1].名称] * items[1].数量)..'#W是否出售?\nmenu\n1|出售\n2|取消')
            if x then
                if x == '1' then
                    items[1]:接受(items[1].数量)
                    玩家:添加银子(收购价格[items[1].名称] * items[1].数量)
                end
            end
        end
    end
    return '你给我什么东西？'
end

return NPC
