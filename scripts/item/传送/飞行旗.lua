-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-09 05:13:42
-- @Last Modified time  : 2023-04-22 04:40:15
local 物品 = {
    名称 = '飞行旗',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
    排序 = 0
}

function 物品:初始化()
    self.坐标 = {}
end

function 物品:使用(对象)
    local map = 对象:取当前地图()
    if self.坐标.名称 == nil then
        if map.名称=='初级帮派' or map.名称=='中级帮派' or map.名称=='高级帮派' then
            对象:提示窗口('#Y帮派内无法记录。')
            return
        end
        self.坐标.名称 = map.名称
        self.坐标.id = map.id
        self.坐标.X = 对象.X
        self.坐标.Y = 对象.Y
        对象:提示窗口('#Y你做好了路标。')
        return
    end

    local r = 对象:选择窗口('你要到#G%s(%d,%d)#W吗？\nmenu\n1|快送我过去\n\n2|重新做路标\n3|什么也不做', self.坐标.名称, self.坐标.X, self.坐标.Y)

    if r == '1' then
        if (对象.是否组队 and  对象:取队伍人数() > 1  )  or (对象.是否组队 and not 对象.是否队长 ) then--单人传送道具条件模板
            对象:提示窗口('#Y只有单人才可以使用该道具')
            return
        end

        for _, b in 对象:遍历队友() do
            for _, v in b:遍历任务() do
                if v.飞行限制 then
                    for _, d in 对象:遍历队友() do
                        d:提示窗口('#Y%s身上有限制飞行的任务！', v.名称)
                    end
                    return
                end
            end
        end

        对象:切换地图(self.坐标.id, self.坐标.X, self.坐标.Y)
        self.数量 = self.数量 - 1
    elseif r == '2' then
        if map.名称=='初级帮派' or map.名称=='中级帮派' or map.名称=='高级帮派' then
            对象:提示窗口('#Y帮派内无法记录。')
            return
        end
        self.坐标.名称 = map.名称
        self.坐标.id = map.id
        self.坐标.X = 对象.X
        self.坐标.Y = 对象.Y
        对象:提示窗口('#Y重新做好了路标。')
    end
end

function 物品:取描述()
    if self.坐标.名称~=nil then
        return string.format( "#Y记录的坐标是%s(%s,%s)",self.坐标.名称,self.坐标.X,self.坐标.Y )
    end
end

return 物品
