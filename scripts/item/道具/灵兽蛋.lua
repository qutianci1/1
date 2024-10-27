-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-03 15:56:58
-- @Last Modified time  : 2023-05-22 22:37:10
local 物品 = {
    名称 = '灵兽蛋',
    叠加 = 0,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = true,
}

function 物品:初始化()
    if not self.参数 then
        self.参数 = 1
    end
end

function 物品:使用(对象)
    local r = 对象:取任务('灵兽降世')
    if r then
        if r.孵蛋成功 then
            r:删除()
            对象:添加坐骑(self.参数)
            self.数量 = self.数量 - 1
        else
            对象:常规提示("#Y这颗蛋还不到出世的时候！")
        end
    else
        对象:常规提示("#Y这似乎是颗坏蛋....")
    end
end

function 物品:取描述()
end

return 物品