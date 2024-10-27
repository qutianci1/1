-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2023-11-03 16:12:59
local 物品 = {
    名称 = '星梦石',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 0,
    绑定 = false
}

function 物品:初始化()
    local 属性范围 = {'根骨', '灵性', '力量', '敏捷'}
    if not self.参数 then
        self.参数 = 属性范围[math.random(1, #属性范围)]
    end
end

function 物品:使用(对象)
    if 对象:星梦石洗点(self.参数) then
        self.数量 = self.数量 - 1
        对象:常规提示("#Y洗点成功,你的"..self.参数.."减少了5点")
    else
        对象:常规提示("#Y你没有可扣的属性点了")
    end
end

function 物品:取描述()
    if self.参数 then
        return '#Y恢复5点'..self.参数..'到可分配点数'
    end
end

return 物品