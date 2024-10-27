-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-06-20 05:27:35
-- @Last Modified time  : 2023-04-28 19:15:16

local 角色 = require('角色')

function 角色:技能_初始化()
    if type(self.技能) == 'table' then
        for nid, v in pairs(self.技能) do
            if not __技能[nid] or __技能[nid].rid == v.rid then
                self.技能[nid] = require('对象/法术/技能')(v)
                self.技能[nid]:刷新熟练度上限(self)
            else
                self.技能[nid] = nil
            end
        end
    else
        self.技能 = {}
    end
end

function 角色:角色_打开技能窗口()
    local list = {}
    for k, v in self:遍历技能() do
        list[k] = {
            nid = v.nid,
            名称 = v.名称,
            阶段 = v.阶段,
            熟练度 = v.熟练度
        }
    end
    return list
end

function 角色:角色_技能描述(id)
    if self.技能[id] then
        local 描述, 消耗

        描述 = self.技能[id]:取描述()
        消耗 = self.技能[id]:取消耗()

        return 描述, 消耗
    end
end

function 角色:遍历技能()
    return next, self.技能
end

function 角色:清空技能()
    for k, v in pairs(self.技能) do
        v.rid = -1
        __垃圾[k] = v
    end
    self.技能 = {}
end

function 角色:删除技能(name)
    for k, v in pairs(self.技能) do
        if v.名称 == name then
            self.技能[k] = nil
            v.rid = -1
            __垃圾[k] = v
            return
        end
    end
end

local 五法 = {
    { "四面楚歌", "万毒攻心", "失心狂乱", "百日眠" },
    { "阎罗追命", "魔神附身", "含情脉脉", "乾坤借速" },
    { "袖里乾坤", "九阴纯火", "天诛地灭", "九龙冰封" },
    { "倩女幽魂", "血海深仇", "吸星大法", "孟婆汤" },

}
function 角色:转生技能检测()
    for _, v in self:遍历技能() do
        for _, b in pairs(五法[self.种族]) do
            if v.名称 == b and v.熟练度 >= v.熟练度上限 then
                return true
            end
        end
    end
end

function 角色:添加技能(name, sl)
    for _, v in self:遍历技能() do
        if v.名称 == name then
            print('已有技能,取消添加'..v.名称)
            return false
        end
    end
    local r = require('对象/法术/技能') {
        rid = self.id,
        名称 = name,
        熟练度 = sl
    }
    r:刷新熟练度上限(self)
    self.技能[r.nid] = r
    self.刷新的属性.技能 = true
    return true
end

function 角色:添加技能熟练度(数额, i)
    local 熟练 = math.floor(数额)
    if i == nil then
        for _, v in self:遍历技能() do
            v:添加熟练度(熟练)
        end
    else
        if self.技能[i] then
            self.技能[i]:添加熟练度(熟练)
        end
    end
    return self.技能
end
