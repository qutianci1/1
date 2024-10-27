-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:55
-- @Last Modified time  : 2023-05-02 05:07:37

local NPC = {}
local 对话 = [[
经天庭将士用命，终将御马监四大妖王镇压。奈何四大妖王非同一般，仍有无数分身逃逸。是故吾立捉妖榜，发布天庭任务。三界侠士皆可揭榜捉妖，以维护三界和平，兼可获得天庭嘉奖。少侠是否要揭榜捉妖?
menu
1|为民除害，义不容辞！
4|我只是路过看看
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        return self:领取天庭任务(玩家)
    end
end

function NPC:领取天庭任务(玩家)
    local t = {}
    for _, v in 玩家:遍历队伍() do
        if v:判断等级是否低于(70) then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于70级,无法领取')
        return
    end
    local r = 生成任务 {名称 = '日常_天庭任务'}
    if r and r:添加任务(玩家) then
        --local ff = '快去御马监降服妖魔吧'
        if 玩家.是否组队 then
            for _, v in 玩家:遍历队友() do
              --  v:最后对话(ff, self.外形)
            end
            return ff
        end
    end
end

return NPC
