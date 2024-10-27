-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:55
-- @Last Modified time  : 2023-05-17 16:12:10

local NPC = {}
local 对话 = [[
少侠，能回收的物品给予我即可#56
目前回收：#Y乌金 金刚石 寒铁 百炼精铁 龙之鳞 千年寒铁 天外飞石 盘古精铁 补天神石 六魂之玉 无量琉璃！#24
menu
1|我要买点东西
2|我要卖点东西
3|我什么都不想做
]]
local 矿石价格 = {
    乌金=300,
    金刚石=3000,
    寒铁=10000,
    百炼精铁=20000,
    龙之鳞=40000,
    千年寒铁=80000,
    天外飞石=160000,
    盘古精铁=320000,
    补天神石=800000,
    六魂之玉=5000000,
    无量琉璃=9000000
}

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        玩家:购买窗口('scripts/shop/长安矿石收购商.lua')
    elseif i == '2' then
        玩家:打开给予窗口(self.nid)
    elseif i == '3' then
    elseif i == '4' then
    end
end

function NPC:NPC给予(玩家, cash, items)
    if items[1] and items[1].名称 and items[1].数量 and items[1].数量 >= 1 then
        if 矿石价格[items[1].名称] then
            local x = 玩家:选择窗口(items[1].名称..'回收总价'..银两颜色(矿石价格[items[1].名称] * items[1].数量)..'#W是否出售?\nmenu\n1|出售\n2|取消')
            if x then
                if x == '1' then
                    items[1]:接受(items[1].数量)
                    玩家:添加银子(矿石价格[items[1].名称] * items[1].数量)
                end
            end
        end
    end

    return '你给我什么东西？'
end

return NPC
