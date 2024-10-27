-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-06-01 16:33:44
-- @Last Modified time  : 2023-09-18 20:09:22

local 角色 = require('角色')
function 角色:法宝_初始化()
    if type(self.法宝) == 'table' then
        for k, v in pairs(self.法宝) do
            local P = require('对象/法宝/法宝')(v)
            self.法宝[k] = P
        end
        self:角色_刷新法宝技能()
    else
        self.法宝 = {}
    end

end

function 角色:法宝_添加(S) --pet
    if ggetype(S) == '法宝' then
        S.rid = self.id
        self.法宝[S.nid] = S
        self.法宝[S.nid].参战 = 0
        -- table.print(self.法宝[S.nid])
        self.rpc:提示窗口('#Y恭喜你获得一个#G'..self.法宝[S.nid].名称..'#Y！')
        return S
    end
end

function 角色:法宝_是否拥有(名称)
    for k,v in pairs(self.法宝) do
        if v.名称 == 名称 then
            return true
        end
    end
    return false
end

function 角色:法宝_添加经验(n)
    local 时辰 = n / 10000
    if 时辰 < 1 then
        时辰 = 1
    end
    local 年 = math.floor(时辰 / (360 * 12))
    local 天 = math.floor((时辰 - 年 * 360 * 12) / 12)
    local 时 = 时辰 - 年 * 360 * 12 - 天 * 12
    for k,v in pairs(self.法宝) do
        if v.参战 ~= 0 then
            v.道行 = v.道行 + 时辰
            while v.等级 < 200 and v.道行 >= v.升级道行 do
                v.等级 = v.等级 + 1
                v.道行 = v.道行 - v.升级道行
                v.升级道行 = math.pow(v.等级 + 1 , 3)
            end
            self.rpc:提示窗口('炼妖炉中的'..v.名称..'吸收了#Y'..年..'年'..天..'天'..时..'时辰#W道行')
        end
    end
end

function 角色:法宝_获取升级经验(等级)
    local 时辰 = math.pow(等级 + 1 , 3)
    local 年 = math.floor(时辰 / (360 * 12))
    local 天 = math.floor((时辰 - 年 * 360 * 12) / 12)
    local 时 = 时辰 - 年 * 360 * 12 - 天 * 12
    return {年,天,时}
end

function 角色:角色_获取法宝数据()
    return self.法宝
end

function 角色:角色_法宝使用(i)
    if not self.是否战斗 then
        local nid = ''
        for k,v in pairs(self.法宝) do
            if v.名称 == i then
                nid = k
                if v.参战 ~= 0 then
                    return
                end
            end
        end
        local 参战位 = {}
        local 参战数 = 0
        for k,v in pairs(self.法宝) do
            if v.参战 ~= 0 then
                参战位[v.参战] = true
                参战数 = 参战数 + 1
            end
        end
        for i=1,3 do
            if not 参战位[i] then
                self.法宝[nid].参战 = i
                -- self:添加技能(self.法宝[nid].名称,self.法宝[nid].等级)
                self:角色_刷新法宝技能()
                return self.法宝[nid]
            end
        end
        return
    end
end

function 角色:角色_刷新法宝技能()
    local _法宝 = {"银索金铃","将军令","大势锤","七宝玲珑塔","黑龙珠","幽冥鬼手","大手印","绝情鞭","情网","宝莲灯","金箍儿","番天印","锦襕袈裟","白骨爪","化蝶"}
    for i=1,#_法宝 do
        self:删除技能(_法宝[i])
    end
    for k,v in pairs(self.法宝) do
        if v.参战 ~= 0 then
            self:添加技能(v.名称,v.等级)
        end
    end
    self:刷新属性()
end

function 角色:角色_法宝休息(i)
    if not self.是否战斗 then
        local nid = ''
        for k,v in pairs(self.法宝) do
            if v.名称 == i then
                local 临时参战 = v.参战
                v.参战 = 0
                self:角色_刷新法宝技能()
                return 临时参战
            end
        end
        return
    end
end