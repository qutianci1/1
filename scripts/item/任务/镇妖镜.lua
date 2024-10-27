-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-15 03:39:51
-- @Last Modified time  : 2023-06-19 15:01:24

local 物品 = {
    名称 = '镇妖镜',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = true,
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
    local map = 对象:取当前地图()
    if map.名称~='大雁塔一层' then
        return
    end
    local r = 对象:取任务('日常_大雁塔任务')
    if r then
        local 坐标 = r.坐标记录[r.进度]
        if self:判断移动范围(对象,坐标,5) then
            对象:提示窗口('#Y这个地方并没有妖魔存在。')
            return
        end
        self.数量 = self.数量-1
        r:任务进入战斗(对象)
    end
end

return 物品