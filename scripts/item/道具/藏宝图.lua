-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-16 15:46:47
-- @Last Modified time  : 2023-10-27 04:10:48

local 物品 = {
    名称 = '藏宝图',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:初始化()
end

function 物品:判断移动范围(对象,记录,距离)
    if math.abs(对象.X - 记录.x) > 距离 or math.abs(对象.Y - 记录.y) > 距离 then
        return true
    else
        return false
    end
end

function 物品:使用(对象)
    local map = 对象:取当前地图()--对象.X

    if self.参数.地图信息 and self.参数.坐标 then
        if map.名称 ~= self.参数.地图信息.名称 or map.id ~= self.参数.地图信息.id or self:判断移动范围(对象,self.参数.坐标,3) then
            对象:提示窗口('#Y可是地点似乎不对，这里显然没有宝藏。')
            return
        end
    end
    local 奖励类型 = {装备 = 15,放妖 = 20,道具 = 65}
    local 奖励
    for i,v in pairs(奖励类型) do
        if math.random(100) <= v then
            奖励 = k
        end
    end
    local 奖励 = 是否奖励(2000,对象.等级,对象.转生)
    if 奖励 ~= nil and type(奖励) == 'table' then
        对象:提示窗口('#Y奖励未添加,嘿嘿')
        self.数量 = self.数量 - 1
    end
end

function 物品:取描述()
    if self.参数 then
        return string.format('宝藏大概藏在#G%s(%d,%d)#W附近', self.参数.地图信息.名称, self.参数.坐标.x, self.参数.坐标.y)
    end
end

return 物品
