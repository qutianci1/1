-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-09-02 15:51:57
-- @Last Modified time  : 2024-05-12 15:57:51

local GGF = require('GGE.函数')
local 角色 = require('角色')

function 角色:角色_打开商城()
    local 商品列表 = __脚本['scripts/shop/商城.lua']
    local 分类 = {}
    for i, v in ipairs(商品列表) do
        分类[i] = v.名字
    end
    return 分类, self.仙玉
end

function 角色:角色_商城商品列表(i)
    local 商品列表 = __脚本['scripts/shop/商城.lua']
    self.商品检验 = {}
    for i, v in ipairs(商品列表[i]) do
        self.商品检验[i] = tostring(v)
    end
    return 商品列表[i]
end

function 角色:角色_商城购买(a, b, n)
    -- if self.加锁状态 then
    --     self.接口:常规提示('#Y高级操作请先解除安全码!请不要将安全码透露给他人')
    --     return
    --end
    local 商品列表 = __脚本['scripts/shop/商城.lua']
    if 商品列表[a] and 商品列表[a][b] and type(n) == 'number' and n > 0 and n <= 999 then
        if tostring(商品列表[a][b]) == self.商品检验[b] then
            local t = GGF.复制表(商品列表[a][b])
            local 总价 = n * t.价格
            if tonumber(self.仙玉) < tonumber(总价) then
                return '#Y你的仙玉不足，不能购买！'
            end
            t.类别 = nil
            t.价格 = nil
            t.热卖 = nil

            local 物品表 = {}
            local 第一 = __沙盒.生成物品(t)
            if 第一.是否叠加 then
                第一.数量 = n
                table.insert(物品表, 第一)
            else
                for i = 1, n do
                    table.insert(物品表, __沙盒.生成物品(t))
                end
            end

            if self:物品_添加(物品表) then
                self.仙玉 = self.仙玉 - 总价
                self.rpc:提示窗口('#Y你购买了%s个#G%s#Y,共花费%s仙玉。',  n,t.名称, 总价)
                return true
            else
                return '#Y空间不足'
            end
        else
            return '#Y购买失败，请重新刷新'
        end
    end
end
