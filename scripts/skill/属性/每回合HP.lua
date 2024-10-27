local 法术 = {
    类别 = '属性',
    类型 = 1,
    对象 = 1,
    条件 = 37,
    名称 = '每回合HP',
}


BUFF = {
    法术 = '每回合HP',
    名称 = '每回合HP',
}
法术.BUFF = BUFF

function BUFF:BUFF回合开始(buff)
print("每回合HP")
end

return 法术