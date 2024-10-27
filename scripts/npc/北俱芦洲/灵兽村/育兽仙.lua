-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-30 20:04:56
-- @Last Modified time  : 2023-11-03 17:17:21

local NPC = {}
local 对话 = [[
这灵兽村的大小灵兽我都是看着长大的，一万年来，我教了他们不少本领，用于维护正义和消灭修罗，看着他们一个个长大心里着实高兴。你要是也想让你的灵兽也换上一招半式我可以考虑考虑教你哦。
menu
1|我想让我的坐骑学习一个技能！
2|我想让我的坐骑换一个技能
99|取消
]]


local 学习对话 = [[
坐骑技能根据属性的不同提升的能力也不同，选择对应的技能给对应的坐骑使用能力也会有显著的提高，你的坐骑要学习那个技能
menu
11|追魂夺命 16|天雷怒火
12|破釜沉舟 17|金身不坏
13|后发制人 18|心如止水
14|万劫不复 19|天神护体
15|兴风作浪 99|我再想想
]]
local 更换技能

function NPC:NPC对话(玩家, i)
    更换技能 = nil
    return 对话
end

local _坐骑技能 = {
    ["11"] = "追魂夺命",
    ["12"] = "破釜沉舟",
    ["13"] = "后发制人",
    ["14"] = "万劫不复",
    ["15"] = "兴风作浪",
    ["16"] = "天雷怒火",
    ["17"] = "金身不坏",
    ["18"] = "心如止水",
    ["19"] = "天神护体",

}



function NPC:NPC菜单(玩家, i)
    if i == '1' then
        return 学习对话
    elseif i == '2' then
        local r = 玩家:取乘骑坐骑()
        if r then
            local 管制 = 0
            for k,v in pairs(r.管制) do
                管制 = 管制 + 1
            end
            if 管制 >= 1 then
                return '请先取消召唤兽管制'
            end
            local s = r:取拥有技能()
            s[#s + 1] = '不想换了'
            return '更换技能之后,坐骑熟练度保持不变,你想要更换哪一个技能？\nmenu\n'.. table.concat(s, "\n")
        else
            return "请先将要操作的坐骑设置乘骑状态！#75"
        end
        return '你看我干啥？'
    elseif i == '追魂夺命' or i == '破釜沉舟' or i == '后发制人' or i == '万劫不复' or i == '兴风作浪' or i == '天雷怒火' or i == '金身不坏' or i == '心如止水' or i == '天神护体' then
        if 更换技能 then--如果已选择更换技能,则默认为当前选项为替换技能
            if i == 更换技能 then
                return '不可选择相同技能替换'
            end
            if 玩家:扣除银子(1000000) then
                local r = 玩家:取乘骑坐骑()
                return r:修改坐骑技能(更换技能, i)
            else
                return '你的金钱不足1000000无法替换技能'
            end
        else
            更换技能 = i
            local 技能表 = {'追魂夺命','破釜沉舟','后发制人','万劫不复','兴风作浪','天雷怒火','金身不坏','心如止水','天神护体'}
            return '请选择一种技能来替换#G'..i..'#W,坐骑的灵性、力量、根骨会影响到这些技能的发挥效果\nmenu\n'.. table.concat(技能表, "\n")
        end
    end

    if _坐骑技能[i] then
        local r = 玩家:取乘骑坐骑()
        if r then
            return  r:学习技能(_坐骑技能[i])
        else
            return "请先将要操作的坐骑设置乘骑状态！#75"
        end
    end
end

return NPC
