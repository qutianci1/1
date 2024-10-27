-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-03-04 02:29:35
-- @Last Modified time  : 2024-08-22 22:24:03

local 角色 = require('角色')
function 角色:角色_自动任务_进入战斗(任务)
    local r = self:任务_获取(任务)
    if r then
        if 任务 == "日常_天庭任务" then
            r:任务NPC菜单(self.接口, r.自动, "1")
        else
            local P = self.周围[r.NPC]
            if P and ggetype(P) == '地图NPC' then
                r.接口:任务攻击事件(self.接口, P)
            end
        end
    end
end

function 角色:角色_自动任务_天庭自动(x, y)
    local r = self:任务_获取("日常_天庭任务")
    if r then
        local 名称
        if x == 180 and y == 10 then
            名称 = "万年熊王"
        elseif x == 10 and y == 100 then
            名称 = "三头妖王"
        elseif x == 180 and y == 100 then
            名称 = "蓝色妖王"
        elseif x == 150 and y == 150 then
            名称 = "黑山妖王"
        end
        if r[名称] and r[名称] ~= 1 then
            r.自动 = { 名称 = 名称 }
        end
    end
end

--self.自动 = { 名称 = v[1] }



function 角色:角色_自动任务_添加任务(任务)
    if 任务 == "日常_抓鬼任务" then
        self:自动任务_添加小鬼()
    elseif 任务 == "日常_天庭任务" then
        self:自动任务_添加天庭(self.接口)
    elseif 任务 == "日常_鬼王任务" then
        self:自动任务_鬼王任务(self.接口)
    elseif 任务 == "日常_修罗任务" then
        self:自动任务_修罗任务(self.接口)
    end
end

function 角色:自动任务_鬼王任务(玩家)
    if not 玩家.是否组队 then
        玩家:常规提示('#Y需要3个人以上的组队来帮我！')
        return
    end
    -- if 玩家:取队伍人数() < 3 then
    --     玩家:常规提示('#Y需要3个人以上的组队来帮我！')
    --     return
    -- end
    local t = {}
    -- for _, v in 玩家:遍历队伍() do
    --     if v:判断等级是否低于(20) then
    --         table.insert(t, v.名称)
    --     end
    -- end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于20级,无法领取')
        return
    end
    for _, v in 玩家:遍历队伍() do
        if v:取任务('日常_鬼王任务') then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取')
        return
    end
    local r = __沙盒.生成任务 { 名称 = '日常_鬼王任务' }

    if r and r:生成怪物(玩家) then
        local ff = string.format(
        '从地府逃出去的#G#u%s#W#u由于长时间没有被超度，现今在#Y%s#W吸取阴气化为鬼王，为免其危害人间，我已下令招募三界有志之士前往捉拿，成功者重重有赏！这事情就有劳阁下了！'
        , r.怪名:gsub('王', ''), r.位置)
        if 玩家.是否组队 then
            for _, v in 玩家:遍历队友() do
                v:最后对话(ff, self.外形)
            end
            return ff
        end
    end
end

function 角色:自动任务_修罗任务(玩家)
    if not 玩家.是否组队 then
        玩家:常规提示('#Y需要3个人以上的组队来帮我！')
        return
    end
    -- if 玩家:取队伍人数() < 3 then
    --     玩家:常规提示('#Y需要3个人以上的组队来帮我！')
    --     return
    -- end
    local t = {}
    -- for _, v in 玩家:遍历队伍() do
    --     if v:判断等级是否低于(20) then
    --         table.insert(t, v.名称)
    --     end
    -- end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于20级,无法领取')
        return
    end
    for _, v in 玩家:遍历队伍() do
        if v:取任务('日常_修罗任务') then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        玩家:常规提示('#Y' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取')
        return
    end
    local r = __沙盒.生成任务 { 名称 = '日常_修罗任务' }

    if r and r:生成怪物(玩家) then
        local ff = string.format('请速去#Y%s#W#处消灭#G#u%s#u#W，阻止他为非作歹。！', r.位置, r.怪名)
        if 玩家.是否组队 then
            for _, v in 玩家:遍历队伍() do
                v:最后对话(ff, self.外形)
            end
        end
    end
end

function 角色:自动任务_添加天庭(玩家)
    local r = __沙盒.生成任务 { 名称 = '日常_天庭任务' }
    if r and r:添加任务(玩家) then
        --local ff = '快去御马监降服妖魔吧'
        if 玩家.是否组队 then
            for _, v in 玩家:遍历队伍() do
               -- v:最后对话(ff, 2294)
            end
        end
    end
end

function 角色:自动任务_添加小鬼()
    if not self.是否组队 then
        self.接口:常规提示('#Y需要3个人以上的组队来帮我！')
        return
    end
    -- if 玩家:取队伍人数() < 3 then
    --     玩家:常规提示('#Y需要3个人以上的组队来帮我！')
    --     return
    -- end
    local t = {}
    -- for _, v in 玩家:遍历队伍() do
    --     if v:判断等级是否低于(20) then
    --         table.insert(t, v.名称)
    --     end
    -- end
    if #t > 0 then
        self.接口:常规提示('#Y' .. table.concat(t, '、 ') .. '#W低于20级,无法领取')
        return
    end
    for _, v in self.接口:遍历队伍() do
        if v:取任务('日常_抓鬼任务') then
            table.insert(t, v.名称)
        end
    end
    if #t > 0 then
        self.接口:常规提示('#Y' .. table.concat(t, '、 ') .. '已有此任务,无法重复领取')
        return
    end
    local r = __沙盒.生成任务 { 名称 = '日常_抓鬼任务' }

    if r and r:生成怪物(self.接口) then
        local ff = string.format('各位且去#Y%s#W找到#G#u%s#W#u,降服超度它吧。', r.位置, r.怪名)
        if self.接口.是否组队 then
            for _, v in self.接口:遍历队伍() do
                v:最后对话(ff, 3039)
            end
            return ff
        end
    end
end

function 角色:角色_自动任务_地图跳转(mid, x, y, 任务)
    self.接口:切换地图(mid, x, y)
    if 任务 then
        local t = self:物品_获取(任务)
        if t then
            t:删除()
        end
    end
end