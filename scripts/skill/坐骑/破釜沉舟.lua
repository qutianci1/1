-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-24 09:47:51
-- @Last Modified time  : 2023-05-06 06:40:30
local 法术 = {
    类别 = '坐骑',
    类型 = 2,
    对象 = 0,
    条件 = 0,
    名称 = '破釜沉舟',
    种族 = 1
}

function 法术:计算(坐骑, 召唤)
    local ap, kb, hsfy= self:效果计算(坐骑)
    召唤.攻击= 召唤.攻击+ math.floor(召唤.攻击 * ap * 0.01)
    召唤.抗性.狂暴几率 = 召唤.抗性.狂暴几率 + kb
    召唤.抗性.忽视防御几率 = 召唤.抗性.忽视防御几率 + hsfy
    召唤.抗性.忽视防御程度 = 召唤.抗性.忽视防御程度 + hsfy
end

function 法术:效果计算(坐骑)
    local 坐骑参数={
        [1]={[1]=4.115226337,[2]=1.141552511},
        [2]={[1]=14.40329218,[2]=3.99543379},
        [3]={[1]=4.8,[2]=1.333333333},
        [4]={[1]=14.4,[2]=4},
        [5]={[1]=14.4,[2]=4},
        [6]={[1]=3.6,[2]=1},
        [7]={[1]=7.2,[2]=2},
        [8]={[1]=4.8,[2]=1.333333333},
        [9]={[1]=7.2,[2]=2},
        [10]={[1]=4.8,[2]=1.333333333},
        [11]={[1]=7.2,[2]=2},
        [12]={[1]=4.8,[2]=1.333333333},
        [13]={[1]=7.2,[2]=2},
        [14]={[1]=7.2,[2]=2},
        [15]={[1]=4.8,[2]=1.333333333},
        [16]={[1]=7.2,[2]=2},
        [17]={[1]=14.4,[2]=4},
        [18]={[1]=4.8,[2]=1.333333333},
        [19]={[1]=7.2,[2]=2},
        [20]={[1]=4.8,[2]=1.333333333},
        [21]={[1]=3.6,[2]=1},
        [22]={[1]=14.4,[2]=4},
        [23]={[1]=7.2,[2]=2}}
    local 坐骑系数={[1]=0.3,[2]=0.3,[3]=0.7,[4]=0.7,[5]=0,[6]=0,[7]=10000,[8]=10000,[9]=1.2}
    local 等级=坐骑.等级
    local 熟练=self.熟练度
    local 根骨=坐骑.根骨
    local 灵性=坐骑.灵性
    local 力量=坐骑.力量
    local 成长=1

    local ap = (根骨 * 坐骑系数[6] + 灵性 * 坐骑系数[5] + 力量 * 1) * 成长 / 坐骑参数[19][1] + 熟练 / 坐骑系数[7] / 坐骑参数[19][2]
    local kb = (根骨 * 坐骑系数[5] + 灵性 * 坐骑系数[5] + 力量 * 1) * 成长 / 坐骑参数[20][1] + 熟练 / 坐骑系数[7] / 坐骑参数[20][2]
    local hsfy = (根骨 * 坐骑系数[5] + 灵性 * 坐骑系数[6] + 力量 * 1) * 成长 / 坐骑参数[21][1] + 熟练 / 坐骑系数[7] / 坐骑参数[21][2]
    ap = math.ceil(ap * 100) / 100
    kb = math.ceil(kb * 100) / 100
    hsfy = math.ceil(hsfy * 100) / 100
    return ap, kb, hsfy
end

function 法术:取描述(坐骑)
    local ap, kb, hsfy= self:效果计算(坐骑)
    return string.format("#G增加AP#R%s%%#G,增加狂暴几率#R%s%%#G,增加忽视防御几率#R%s%%#G,忽视防御程度#R%s%%", ap, kb
        , hsfy, hsfy)
end

return 法术
