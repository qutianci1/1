-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2023-08-23 02:42:01

local 法术 = {
    类别 = '门派',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '互相拉血',
    id = 0191,
}

local BUFF
function 法术:法术施放(攻击方, 目标)
    self.xh = 0
end
function 法术:法术施放后(攻击方, 目标)
    if self.xh then
        self.xh=false
        for i, v in ipairs(目标) do
            local 气血 = math.floor(v.最大气血 * 0.7)
            v:增加气血(气血,1)
        end
    end
end

function 法术:法术取BUFF效果(攻击方, 挨打方)
end

function 法术:法术取回合()
end

function 法术:法术取目标数()
    return 1
end

function 法术:法术取消耗()
    return
end

function 法术:法术取描述()
    return '恢复目标70%最大气血'
end

return 法术
