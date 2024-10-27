-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-20 06:07:21
-- @Last Modified time  : 2024-08-28 22:58:38

local 角色 = require('角色')

function 角色:召唤_初始化()
    local 存档召唤 = self.召唤
    local _召唤表 = {} -- 真实地址

    self.召唤 =
    setmetatable(
        {},
        {
            __newindex = function(t, k, v)
                if v then
                    v.rid = self.id
                    v.主人 = self
                    if v.获得时间 == 0 then
                        v.获得时间 = os.time()
                    end
                else
                    __垃圾[k] = _召唤表[k]
                    __垃圾[k].rid = -1
                end
                _召唤表[k] = v
            end,
            __index = function(t, k)
                return _召唤表[k]
            end,
            __pairs = function(...)
                return next, _召唤表
            end
        }
    )
    if type(存档召唤) == 'table' then
        for k, v in pairs(存档召唤) do
            if not __召唤[v.nid] or __召唤[v.nid].rid == v.rid then --交易
                local S = require('对象/召唤/召唤')(v)
                self.召唤[v.nid] = S
                if S.是否观看 then
                    if self.观看召唤 then
                        S.是否观看 = false
                    else
                        self.观看召唤 = S
                    end
                end
                if S.是否参战 then
                    if self.参战召唤 then
                        S.是否参战 = false
                    else
                        self.参战召唤 = S
                    end
                end
            end
        end
    end

end

function 角色:召唤_更新()
    for k, v in self:遍历召唤() do
        v:更新()
    end
end

function 角色:取召唤兽数量()
    local n = 0
    for k, v in self:遍历召唤() do
        n = n + 1
    end
    return n
end

function 角色:寻找召唤兽(id)
    local r = ''
    for k, v in self:遍历召唤() do
        if v.外形 == id and not v.是否参战 and not v.是否观看 then
            r = v.nid
        end
    end
    if r == '' then
        return nil
    end
    return r
end

function 角色:删除召唤兽(id)--v:删除()
    for k, v in self:遍历召唤() do
        if v.nid == id then
            v:删除()
            return true
        end
    end
    -- if self.召唤[id] == nil then
    --     print('找不到')
    --     return false
    -- end
    -- self.召唤[id]:删除()
    -- return true
end

function 角色:召唤_添加(S)
    if ggetype(S) == '召唤接口' then
        S = S[0x4253]
    end

    if self:取召唤兽数量() >= self.召唤兽携带上限 then
        return
    end

    if ggetype(S) == '召唤' then
        --召唤数量已达上限。
        self.召唤[S.nid] = S
        self.刷新的属性.召唤列表 = true
        return S
    end
end

function 角色:召唤_添加升级亲密(等级)
    for k, v in self:遍历召唤() do
        v.亲密 = v.亲密 + 等级*15
    end
end

function 角色:召唤_添加亲密(nid,亲密)
    for k, v in self:遍历召唤() do
        if v.nid == nid then
            v.亲密 = v.亲密 + 亲密
        end
    end
end

function 角色:角色_召唤列表()
    local r = {}
    for k, v in self:遍历召唤() do
        table.insert(
            r,
            {
                nid = v.nid,
                名称 = v.名称,
                外形 = v.外形,
                原形 = v.原形,
                染色 = v.染色,
                获得时间 = v.获得时间,
                单价 = v.单价
            }
        )
    end
    return r
end

function 角色:角色_打开召唤窗口()
    local list = {}
    for k, v in self:遍历召唤() do
        table.insert(
            list,
            {
                nid = v.nid,
                名称 = v.名称,
                顺序 = v.顺序,
                是否参战 = v.是否参战,
                是否观看 = v.是否观看,
                获得时间 = v.获得时间
            }
        )
    end
    return list
end

function 角色:角色_打开召唤兽驯养窗口()
    local list = {}
    for k, v in self:遍历召唤() do
        table.insert(
            list,
            {
                nid = v.nid,
                名称 = v.名称,
                顺序 = v.顺序,
                等级 = v.等级,
                亲密 = v.亲密,
                外形 = v.外形,
                染色 = v.染色,
                是否参战 = v.是否参战,
                是否观看 = v.是否观看,
                获得时间 = v.获得时间
            }
        )
    end
    return list
end

function 角色:遍历召唤()
    return pairs(self.召唤)
end
