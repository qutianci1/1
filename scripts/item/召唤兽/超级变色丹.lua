-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-08 18:53:33
-- @Last Modified time  : 2023-05-02 21:37:32

local 物品 = {
    名称 = '超级变色丹',
    叠加 = 999,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    local 是否变色,方案 = 对象:使用超级变色丹(对象)
    if 是否变色 then

        if type(是否变色) == 'string' then
            对象:常规提示(是否变色)
        else
            if 方案 then
                self.数量 = self.数量 - 1
                对象:常规提示('#Y你的召唤兽颜色发生了变化。#17')
            end
        end
    else
        对象:常规提示('#Y这类召唤兽无法变色')
    end
end

return 物品
