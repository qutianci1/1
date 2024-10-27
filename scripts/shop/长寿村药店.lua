-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-08-17 00:52:55
-- @Last Modified time  : 2022-09-02 09:59:19
local 商店 = {}

local list = {
    { 类别 = "道具", 名称 = "灵芝", 价格 = 1580 },
    { 类别 = "道具", 名称 = "佛手", 价格 = 1291 },
    { 类别 = "道具", 名称 = "羊脂仙露", 价格 = 1201 },
    { 类别 = "道具", 名称 = "旋复花", 价格 = 1308 },
    { 类别 = "道具", 名称 = "曼陀罗花", 价格 = 1210 },
    { 类别 = "道具", 名称 = "九转龙涎香", 价格 = 1358 },
    { 类别 = "道具", 名称 = "天龙水", 价格 = 1200 },
    { 类别 = "道具", 名称 = "鬼切草", 价格 = 1100 },
    { 类别 = "道具", 名称 = "仙狐涎", 价格 = 1100 },
    { 类别 = "道具", 名称 = "白药", 价格 = 1400 },
    { 类别 = "道具", 名称 = "和合散", 价格 = 1100 },
}

function 商店:取商品()
    return list
end

function 商店:购买(玩家, i, n)
    local 总价 = n * list[i].价格
    if 玩家.银子 >= 总价 then
        local t = 复制表(list[i])
        t.类别 = nil
        t.价格 = nil
        local 物品表 = {}
        local 第一 = 生成物品(t)
        if 第一.是否叠加 then
            第一.数量 = n
            table.insert(物品表, 第一)
        else
            for _ = 1, n do
                table.insert(物品表, 生成物品(t))
            end
        end
        if 玩家:添加物品_无提示(物品表) then
            玩家:扣除银子(总价)
            玩家:提示窗口('#Y你购买了%s个#G%s#Y,共花费%s银两。',  n,t.名称, 总价)
            return true
        else
            return '#Y空间不足'
        end

    else
        return '#Y你的银两不足，不能购买！'
    end
end

return 商店
