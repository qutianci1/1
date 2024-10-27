-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:54
-- @Last Modified time  : 2023-05-22 22:09:32

local 物品 = {
    名称 = '孔明灯',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false,
    排序 = 0
}
function 物品:初始化()
    self.次数 = 99
    self.坐标 = {}
end

function 物品:取坐标列表()
    local s = ''
    for i, v in ipairs(self.坐标) do
        s = s .. string.format('%d|%s(%d,%d)\n', i, v.名称, v.X, v.Y)
    end
    return s
end

function 物品:使用(对象)
    local map = 对象:取当前地图()

    if #self.坐标 == 0 then
        if map.名称=='初级帮派' or map.名称=='中级帮派' or map.名称=='高级帮派' then
            对象:提示窗口('#Y帮派内无法记录。')
            return
        end
        table.insert(self.坐标, {名称 = map.名称, id = map.id, X = 对象.X, Y = 对象.Y})
        对象:提示窗口('#Y你做好了路标。')
        return
    end
    local 对话 = '选择路标\nmenu\n' .. self:取坐标列表() .. '新增路标'

    local r = 对象:选择窗口(对话)
    if 对象.是否组队 then
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
    for i, v in ipairs(self.坐标) do --选中路标传送
        if r == tostring(i) then
            对象:切换地图(self.坐标[i].id, self.坐标[i].X, self.坐标[i].Y)
            self.次数 = self.次数 - 1
            if self.次数 <= 0 then
                self.数量 = self.数量 - 1
            end
            return
        end
    end
    if r == '新增路标' then --记录坐标
        if map.名称=='初级帮派' or map.名称=='中级帮派' or map.名称=='高级帮派' then
            对象:提示窗口('#Y帮派内无法记录。')
            return
        end
        if #self.坐标 < 8 then
            table.insert(self.坐标, {名称 = map.名称, id = map.id, X = 对象.X, Y = 对象.Y})
            对象:提示窗口('#Y你做好了路标。')
        else
            local 对话2 = '你已经记录了8处路标，要替换哪一处？\nmenu\n'..self:取坐标列表()
            local t = 对象:选择窗口(对话2)

            for i, v in ipairs(self.坐标) do --选中路标替换
                if t == tostring(i) then
                    self.坐标[i].id = map.id
                    self.坐标[i].X = 对象.X
                    self.坐标[i].Y = 对象.Y
                    self.坐标[i].名称 = map.名称
                    对象:提示窗口('#Y你做好了路标。')
                    return
                end
            end
        end
    end
end
function 物品:取描述()
    local r = ""
    for k,v in pairs(self.坐标) do
        r=r..string.format('#G%s(%s,%s)#r', self.坐标[k].名称,self.坐标[k].X,self.坐标[k].Y)
    end


    return string.format('%s#r#Y还可以使用#R%s#Y次', r,self.次数)
end
return 物品
