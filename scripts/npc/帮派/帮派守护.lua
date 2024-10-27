-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-14 19:39:24
-- @Last Modified time  : 2023-11-01 16:26:55

local NPC = {}
local 对话 = [[]]

--其它对话
function NPC:NPC对话(玩家, i)
    local 主守护 = "无"
    local 辅守护 = "无"
    if not 玩家.帮派数据.守护神 then
        玩家.帮派数据.守护神 = {主守护 = '',辅守护 = ''}
    end
    主守护 = 玩家.帮派数据.守护神.主守护
    辅守护 = 玩家.帮派数据.守护神.辅守护
    local 对话 = string.format('您的当前主守护是:#G%s#W,辅守护是:#G%s#W。请问你要更换自己的那个守护神呢?（每次更换帮派守护神操作都需要缴纳 100000 两银子给帮派，首次更换免费）\nmenu\n更换主守护\n更换辅守护\n我要增加帮派守护\n随便转转', 主守护, 辅守护)
    玩家.更改守护 = nil
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '我要增加帮派守护' then
        local 职务 = self.帮派:取成员(玩家.nid).职务
        if 职务 ~= '帮主' and 职务 ~= '副帮主' then
            return '只有帮主和副帮主才可以选择帮派守护神。'
        end
        local 数量 = #self.帮派.守护
        local r = {2,4,6,8,10}
        if r[self.帮派.等级] then
            if 数量 >= r[self.帮派.等级] then
                玩家:提示窗口('#Y你的帮派最多拥有#G'..r[self.帮派.等级]..'#Y个守护神。')
                return
            end
            local 守护表 = {'狂风战神','天雷战神','沧海战神','烈火战神','混乱战神','封印战神','昏睡战神','猛毒战神','大力战神','震慑战神'}
            for i=#守护表,1,-1 do
                for n=1,#self.帮派.守护 do
                    if self.帮派.守护[n] == 守护表[i] then
                        -- print(守护表[i])
                        table.remove(守护表, i)
                    end
                end
            end
            local 新对话 = '你想增加哪个帮派守护战神?\nmenu\n'.. table.concat(守护表, "\n")
            return 新对话
        end
    elseif i == '狂风战神' or i == '天雷战神' or i == '沧海战神' or i == '烈火战神' or i == '混乱战神' or i == '封印战神' or i == '昏睡战神' or i == '猛毒战神' or i == '震慑战神' or i == '大力战神' then
        if 玩家.更改守护 then
            if 玩家.更改守护 == '主守护' then
                if 玩家.帮派数据.守护神.辅守护 == i then
                    return '主辅守护不可选择相同战神'
                end
            elseif 玩家.更改守护 == '辅守护' then
                if 玩家.帮派数据.守护神.主守护 == i then
                    return '主辅守护不可选择相同战神'
                end
                if i =='震慑战神' then
                    return '震慑战神只可以作为主辅守护'
                end
            end
            if 玩家.帮派数据.守护神[玩家.更改守护] ~= '' then--有守护时扣除10W
                if not 玩家:扣除银子(100000) then
                    return '你的金钱不足#G100000'
                end
            end
            玩家.帮派数据.守护神[玩家.更改守护] = i
            玩家:提示窗口('#Y你的帮派'..玩家.更改守护..'已更改为#G'..i)
            玩家.更改守护 = nil
        else
            self.帮派.守护[#self.帮派.守护 + 1] = i
            local r = {2,4,6,8,10}
            local 数量 = r[self.帮派.等级] - #self.帮派.守护
            玩家:提示窗口('#Y你的帮派增加了一个'..i..',剩余'..数量..'个守护可选择')
        end
    elseif i == '更换主守护' then
        玩家.更改守护 = '主守护'
        local 守护表 = self.帮派.守护
        local 新对话 = '您要将主守护设置成什么？\nmenu\n'.. table.concat(守护表, "\n")
        return 新对话
    elseif i == '更换辅守护' then
        玩家.更改守护 = '辅守护'
        local 守护表 = self.帮派.守护
        local 新对话 = '您要将辅守护设置成什么？\nmenu\n'.. table.concat(守护表, "\n")
        return 新对话
    end
end

return NPC
