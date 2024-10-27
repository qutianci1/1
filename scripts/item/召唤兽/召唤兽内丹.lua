-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-26 19:31:08
-- @Last Modified time  : 2023-05-01 05:44:14
-- local 物品 = {
--     名称 = '召唤兽内丹',
--     类别 = 8,
--     类型 = 0,
--     对象 = 2,
--     条件 = 2,
--     绑定 = false,
-- }
local 物品 = {
    名称 = '召唤兽内丹',
    叠加 = 0,
    类别 = 3,
    类型 = 0,
    对象 = 3,
    条件 = 2,
    绑定 = false,
}

function 物品:初始化()
    local 技能 = {"浩然正气","暗渡陈仓","借力打力","凌波微步","隔山打牛","分光化影","天魔解体","小楼夜哭","青面獠牙","乘风破浪","霹雳流星","大海无量","祝融取火","红颜白发","梅花三弄","开天辟地","万佛朝宗"}
    if self.技能 == nil then
        self.技能 = 技能[math.random(1, #技能)]
    end
end

function 物品:使用(对象)
    if 对象.是否玩家 then
        if (self.等级 or 1) <= 30 and (self.转生 or 0) == 0 and (self.点化 or 0) == 0 then
            self.数量 = self.数量 - 1

            对象:添加物品 {
                生成物品 { 名称 = '内丹精华', 数量 = 3 },
            }
        end
    else
        if 对象:取内丹是否存在(self.技能) then
            if (self.等级 or 1) <= 30 and (self.转生 or 0) == 0 and (self.点化 or 0) == 0 then
                if 对象:添加元气(150) then
                    self.数量 = self.数量 - 1
                else
                    return '#Y元气已满'
                end
            end
            return
        end
        
        local 可食用 = 对象.转生 + 1
        if 可食用 > 3 then
            可食用 = 3
        end
        if 对象:取内丹数量() >= 可食用 then
            return '#Y最多使用' .. 可食用 .. '#Y个内丹'
        end

        if 对象.转生 < (self.转生 or 0) then
            return '#Y不可服用超过自身等级的内丹'
        elseif 对象.转生 == (self.转生 or 0) and (self.等级 or 1) > 对象.等级 then
            return '#Y不可服用超过自身等级的内丹'
        end
        对象:添加内丹(self)
        --self.数量=self.数量-1
        对象:常规提示('#Y这只召唤兽学会了技能#G%s#Y。',self.技能)

    end
    --遍历身上所有内丹
    --如果存在 and self.转生==0 and self.点化==0 and self.等级<=30
    --补充元气

end

local _描述 = {
    浩然正气 = "召唤兽物理攻击，有几率附加造成按对方自身法力百分比的伤害。",
    暗渡陈仓 = "此技能在物理攻击的时候能够忽视对手一定的躲闪和反击进行攻击。",
    借力打力 = "此技能在受到物理攻击的一回合内有一定的几率产生反击效果。",
    凌波微步 = "此此技能提高召唤兽一定的躲闪率。",
    隔山打牛 = "物理攻击的时候有一定几率对攻击对象周围的某个目标造成伤害。",
    分光化影 = "此技能通过牺牲自己的HP给对手造成MP伤害。",
    天魔解体 = "此技能通过牺牲自己的HP给对手造成HP伤害。",
    小楼夜哭 = "此技能通过牺牲自己的MP给对手造成MP伤害。",
    青面獠牙 = "此技能通过牺牲自己的MP给对手造成HP伤害。",
    乘风破浪 = "此技能在物理攻击的时候有一定的几率产生风系法术伤害。",
    霹雳流星 = "此技能在物理攻击的时候有一定的几率产生雷系法术伤害。",
    大海无量 = "此技能在物理攻击的时候有一定的几率产生水系法术伤害。",
    祝融取火 = "此技能在物理攻击的时候有一定的几率产生火系法术伤害。",
    红颜白发 = "此技能在使用仙法攻击的时候有一定几率出现狂暴，使伤害增加。",
    梅花三弄 = "此技能在使用仙法攻击的时候有一定几率出现法术连击。",
    开天辟地 = "此技能在使用仙法攻击的时候有一定几率忽视对方的法术抗性。",
    万佛朝宗 = "此技能有一定几率将伤害反震。",

}

function 物品:取描述()
    if self.点化 == 1 then
        return string.format("#Y%s：#G%s#r#Y技能等级：#G点化%s#Y级", self.技能, _描述[self.技能], self.等级)
    else
        return string.format("#Y%s：#G%s#r#Y技能等级：#G%s#Y转#G%s#Y级", self.技能, _描述[self.技能], self.转生 or 0,
            self.等级 or 1)
    end
end

return 物品
