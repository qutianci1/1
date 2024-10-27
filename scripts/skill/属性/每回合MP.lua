-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-30 20:04:59
-- @Last Modified time  : 2023-09-18 11:42:43

local 法术 = {
    类别 = '属性',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '每回合MP',
}


BUFF = {
    法术 = '每回合MP',
    名称 = '每回合MP',
}
法术.BUFF = BUFF

function BUFF:BUFF回合开始(buff)
end

return 法术