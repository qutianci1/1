-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-04-14 06:18:08
-- @Last Modified time  : 2023-04-15 17:32:37

local function _get(s, name)
    if not s then
        return
    end
    local 脚本 = __脚本[s] or __脚本['npc/默认.lua']
    if type(脚本) == 'table' then
        if name then
            return 脚本[name]
        end
        return 脚本
    end
end

local 地图NPC = class('地图NPC')

function 地图NPC:初始化(map, t)
    self._来源 = map
    self._数据 = t

    if t.X then
        self.X = t.X
        self.Y = t.Y
        self.x = math.floor(t.X * 20)
        self.y = math.floor((map.高度 - t.Y) * 20)
    end

    self._对话 = setmetatable({}, { __mode = 'k' })
    if not self.nid then
        self.nid = _生成ID()
    end
    __NPC[self.nid] = self
end

function 地图NPC:__index(k)
    local t = rawget(self, '_数据')
    if t then
        return t[k]
    end
end

function 地图NPC:更新(sec)
    local fun = _get(self.脚本, 'NPC更新')
    if type(fun) == 'function' then
        ggexpcall(fun, self, sec)
    end
end

function 地图NPC:对话(P)
    -- print(self.脚本)
    local fun = _get(self.脚本, 'NPC对话')
    if type(fun) == 'function' then
        local ct = self:生成对话()
        self._对话[P] = ct
        ct.台词 = ggexpcall(fun, ct, P.接口)
        return ct
    end
    print('脚本不存在', self.名称, self.脚本)
end

function 地图NPC:菜单(P, opt)
    local ct = self._对话[P]
    local fun = _get(self.脚本, 'NPC菜单')
    if ct and type(fun) == 'function' then
        ct.台词 = ggexpcall(fun, ct, P.接口, opt)
        return ct
    end
end

function 地图NPC:给予(P, cash, items)
    local fun = _get(self.脚本, 'NPC给予')
    if type(fun) == 'function' then
        local ct = self:生成对话()
        self._对话[P] = ct
        return ct, ggexpcall(fun, ct, P.接口, cash, items)
    end
    return nil, '你给我什么东西？'
end

function 地图NPC:生成对话()
    return setmetatable(
        {},
        {
            --创建数据,脚本数据,自身数据,原始数据
            __index = function(t, k)
                local r = self._数据[k]
                if r ~= nil then
                    return r
                end
                local 脚本 = _get(self.脚本)
                if 脚本 and 脚本[k] ~= nil then
                    return 脚本[k]
                end
                return rawget(t, k) or self[k]
            end,
            __newindex = function(t, k, v)
                if self._数据[k] ~= nil then --优先赋值创建数据(比如.战斗中)
                    self._数据[k] = v
                else
                    rawset(t, k, v)
                end
            end
        }
    )
end

function 地图NPC:生成对象() --屏幕
    return setmetatable(
        {
            是否可见 = true,
            状态 = {},
            生成时间 = self.更新时间
        },
        { __index = self }
    )
end

function 地图NPC:取简要数据()
    return {
        type = 'npc',
        nid = self.nid,
        名称 = self.名称,
        外形 = self.外形,
        称谓 = self.称谓,
        方向 = self.方向,
        x = self.x,
        y = self.y
    }
end

function 地图NPC:删除()
    if self._来源 then
        self._来源:删除NPC(self.nid)
    end
end

function 地图NPC:切换外形(v)
    self._数据.外形 = v
    self._数据.更新时间 = os.time()
end

-- function 地图NPC:是否限时()
--     return self.结束时间>0
-- end

-- function 地图NPC:检查时间(sec)
--     if self.结束时间>0 then
--         return sec>self.结束时间
--     end
-- end

return 地图NPC
