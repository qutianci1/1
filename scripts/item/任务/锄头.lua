-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-15 03:39:51
-- @Last Modified time  : 2023-04-15 04:56:05

local 物品 = {
    名称 = '锄头',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = true,
}

function 物品:初始化()
    self.计时 = os.time() - 5
    self.坐标 = {}
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
    if map.名称~='初级帮派' and map.名称~='中级帮派' and map.名称~='高级帮派' and map.名称~='长安' then
        对象:提示窗口('#Y这是在帮派里锄草的道具,你想干啥。')
        return
    end
    if os.time() - self.计时 < 5 then
        对象:提示窗口('#Y你也太快了。')
        return
    end
    if self.坐标.x ~= nil then
        if not self:判断移动范围(对象,self.坐标,5) then
            对象:提示窗口('#Y这片的杂草已经清除了，该去别处清除了。')
            return
        end
    end
    self.计时 = os.time()
    self.坐标 = {x = 对象.X, y = 对象.Y}
    local r = 对象:取任务('日常_帮派任务')
    local 次数 = r.位置
    if 次数==3 then
        对象:提示窗口('#Y经过你的一番努力,帮中的杂草少了许多。')
    else
        对象:提示窗口('#Y经过你的一番努力,帮中的杂草又少了许多。')
    end
    r.位置=r.位置-1
    if r.位置==0 then
        r:完成(对象)
        self.数量 = self.数量-1
    end
end

return 物品