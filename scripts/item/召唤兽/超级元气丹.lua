-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-09 11:29:28
-- @Last Modified time  : 2023-05-03 04:04:01

local 物品 = {
    名称 = '超级元气丹',
    叠加 = 1,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:初始化()
end

function 物品:使用(对象)
    local 结果,提升 = 对象:使用超级元气丹()
    if 结果 then
        if type(结果) == 'string' then
            对象:常规提示(结果)
        else
            if 提升 then
                self.数量 = self.数量 - 1
                对象:常规提示('#Y你的召唤兽一口吞下元气丹,身体发生了一些奇异的变化。')
            end
        end
    else
        对象:常规提示('#Y服用元气丹失败')
    end
end

function 物品:取描述()
end

return 物品