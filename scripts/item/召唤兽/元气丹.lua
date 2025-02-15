-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-09 11:29:28
-- @Last Modified time  : 2023-05-07 09:56:00

local 物品 = {
    名称 = '元气丹',
    叠加 = 0,
    类别 = 8,
    类型 = 0,
    对象 = 2,
    条件 = 2,
    绑定 = false
}

function 物品:初始化()
    if not self.参数 then
        local 低级召唤兽 = {"野狗","女贼","小妖","武士","士兵","兔妖","花妖","夜叉","衙役","猪怪","骷髅怪","家丁","牛妖","羊头怪","水妖","流氓","狐狸精","小龙女","女妖","毒蜂","鸡精","山贼","千年老妖","吸血鬼","龟丞相","修罗","战神女娲","幽灵","复活女娲","冤魂","孤魂","蟹将","虾兵","鳄鱼","黑熊","银狐","大鹏","狮子","强盗","无身鬼","野鬼","蛤蟆精","无头鬼","老虎","猴小兵","树妖","打手","黑熊精","大象","开山怪","古代瑞兽","冲冲虫","白虎","符咒女娲","独眼巨人","寒钢怪","鸟嘴兽","蜘蛛精","精怪","三尾怪","蝴蝶仙子","两角怪","死灵","鼠怪","雷鸟人","冰熊","山妖","火神女娲","神兵","地狱战神","野蛮王","舍身女娲"}
        local 中级召唤兽 = {"凤凰","蛟龙","神灵","猴精","食土兽","桃树精","水灵仙","金刚仙","桃花仙","麒麟兽"}
        local 高级召唤兽 = {"泥石怪","冰雪魔","黄金兽","喷火牛","赤焰妖"}
        local 天书召唤兽 = {"哥俩好","剑精灵","雷兽","罗刹鬼姬","狮蝎","冥灵妃子","迦楼罗王","精卫","松鼠"}
        local 随机 = math.random(100)
        if 随机 <= 5 then
            self.参数 = 天书召唤兽[math.random(#天书召唤兽)]
        elseif 随机 <= 15 then
            self.参数 = 高级召唤兽[math.random(#高级召唤兽)]
        elseif 随机 <= 40 then
            self.参数 = 中级召唤兽[math.random(#中级召唤兽)]
        else
            self.参数 = 低级召唤兽[math.random(#低级召唤兽)]
        end
    end
end

function 物品:使用(对象)
    if self.参数 == nil then
        对象:常规提示('#Y获取元气丹数据失败,无法使用')
        return
    end

    local 结果,提升 = 对象:使用元气丹(self.参数)
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
    if self.参数 then
        return '#Y种类：'..self.参数
    end
end

return 物品