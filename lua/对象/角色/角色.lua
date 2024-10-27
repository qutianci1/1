-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-04-14 06:18:08
-- @Last Modified time  : 2024-10-26 01:00:17

local 角色 = class('角色')
--用gge.require，不会被缓存
gge.require('对象/角色/摆摊')
gge.require('对象/角色/帮派')
gge.require('对象/角色/仓库')
gge.require('对象/角色/称谓')
gge.require('对象/角色/好友')
gge.require('对象/角色/法宝')
gge.require('对象/角色/宠物')
gge.require('对象/角色/地图')
gge.require('对象/角色/队伍')
gge.require('对象/角色/管理')
gge.require('对象/角色/技能')
gge.require('对象/角色/交易')
gge.require('对象/角色/商城')
--角色
--接口
gge.require('对象/角色/界面')
gge.require('对象/角色/任务')
gge.require('对象/角色/属性')
gge.require('对象/角色/数据')
gge.require('对象/角色/算法')
gge.require('对象/角色/通信')
gge.require('对象/角色/物品')
gge.require('对象/角色/战斗')
gge.require('对象/角色/召唤')
gge.require('对象/角色/作坊')
gge.require('对象/角色/坐骑')
gge.require('对象/角色/自动任务')
gge.require('对象/角色/机器人')

function 角色:初始化(t) --创建角色位置
    if t.数据.地图 == nil or not __地图[t.数据.地图] then
        t.数据.地图 = 1208
        t.数据.x = 935
        t.数据.y = 260
    end
    self:加载存档(t)

    if not self.原形 or self.原形 == 0 then
        self.原形 = self.外形
    end

    self:物品_初始化()
    self:召唤_初始化()
    self:宠物_初始化()
    self:通信_初始化()
    self:地图_初始化()
    self:队伍_初始化()
    self:任务_初始化()
    self:技能_初始化()
    self:界面_初始化()
    self:坐骑_初始化() --在召唤后
    self:属性_初始化() --最后
    self:法宝_初始化()
    self.状态 = {} --头顶
    self.窗口 = {}
    self.接口 = require('对象/角色/接口')(self)

    if not self.新手剧情 then
        self.新手剧情 = true
        local r = __沙盒.生成任务 { 名称 = '新手剧情' }
        self:任务_添加(r)
        local r = __沙盒.生成任务 { 名称 = '引导_升级检测' }
        self:任务_添加(r)
    end
    self:角色_取名称颜色()
    -- local r = __沙盒.生成任务 { 名称 = '引导_升级检测' }
    -- print(r)
    -- self:任务_添加(r)
end

function 角色:__index(k)
    if k == '仙玉' then
        return __仙玉[self.uid]
    end
    local 数据 = rawget(self, '数据')
    if 数据 then
        return 数据[k]
    end
end

local _存档表 = require('数据库/存档属性_角色')

function 角色:__newindex(k, v)
    if k == '仙玉' then
        __仙玉[self.uid] = v
        return
    end
    if _存档表[k] ~= nil then
        if self.可刷新 and self.刷新的属性 and k ~= 'x' and k ~= 'y' then
            self.刷新的属性[k] = v
        end
        self.数据[k] = v
        return
    end
    rawset(self, k, v)
end

function 角色:更新(sec)
    if self.可刷新 and not self.是否掉线 then
        self:增加在线时间()
        self:属性_更新(sec)
        if not self.是否机器人 then
            self:地图_更新(sec)
        end
        self:物品_更新(sec)
        self:任务_更新(sec)
        self:召唤_更新(sec)
        self:机器人_更新(sec)
    end
end

function 角色:增加在线时间()
    if self.在线时间.秒 then
        self.在线时间.秒 = self.在线时间.秒 + 1
    else
        self.在线时间.秒 = 0
    end
    --分钟
    if self.在线时间.秒 == 60 then
        self.在线时间.秒 = 0
        --增加宠物经验
        if self.宠物 then
            for k,v in pairs(self.宠物) do
                local r = v:增加经验()
                if r then
                    self.rpc:提示窗口('#Y你的宠物升级到#G'..r..'#Y级')
                end
            end
        end
        if self.在线时间.分 then
            self.在线时间.分 = self.在线时间.分 + 1
        else
            self.在线时间.分 = 0
        end
    end
    --小时
    if self.在线时间.分 == 60 then
        self.在线时间.分 = 0
        if self.体力 < self.体力上限 then
            self.体力 = self.体力 + 30
        end
        if self.体力 > self.体力上限 then
            self.体力 = self.体力上限
        end
        if self.在线时间.时 then
            self.在线时间.时 = self.在线时间.时 + 1
        else
            self.在线时间.时 = 0
        end
    end
end

function 角色:掉线() --玩家依旧存在世界中
    if self.是否组队 and not self.是否战斗 then
        self:角色_离开队伍()
    end
    self.是否掉线 = true
    self:存档()
    if not self.是否战斗 then
        self.当前地图:删除玩家(self)
        self.当前地图:删除召唤(self.观看召唤)
        self.当前地图:删除宠物(self.观看宠物)
        __世界:删除玩家(self)
        if not 子 and _角色[self.cid] and _角色[self.cid].子角色 then
            for i,v in pairs(_角色[self.cid].子角色) do
                if v.nid ~= self.nid then
                    v:下线(1)
                end
            end
            _角色[self.cid].子角色 = nil
        end
    else
        if self.是否组队 then
            if self.是否队长 then
                for k,v in self:遍历队伍() do
                    if v.nid ~= self.nid and v.离线角色 then
                        v:掉线()
                    end
                end
            end
        end
    end
    self.lscid = self.cid
    self.cid = nil
end
function 角色:取玩家是否在线(nid) --玩家依旧存在世界中
     if __玩家[nid] then
        return true
    end
    return false
end

-- function 角色:角色_进入PK(nid)
--     --排除不可进入战斗的条件
--         if __副本地图[self.当前地图.接口.id] and self.当前地图.接口.名称 == '比武场' then
--         if tonumber(os.date('%H', os.time())) ~= 20 then
--             self.rpc:提示窗口('非帮战期间禁止PK')
--             return
--         end
--         if self.帮派 and __帮派[self.帮派] and __帮派[self.帮派].帮战结束 then
--             self.rpc:提示窗口('非帮战期间禁止PK')
--             return
--         end
--         local 玩家 = self.周围玩家[nid]
--         if 玩家 then
--             if self.是否组队 then
--                 for k,v in self:遍历队伍() do
--                     if v.nid == nid then
--                         self.rpc:提示窗口('同队无法PK')
--                         return
--                     end
--                 end
--             end
--             self:战斗_初始化(玩家,'帮战')
--         end
--     else
--     end
--     local 玩家 = self.周围玩家[nid]
--     if 玩家 then
--         if 玩家.是否摆摊 then
--             self.rpc:提示窗口('对方处于无法战斗状态!')
--             return
--         end
--         if not self.当前地图.可遇怪 then--安全区只能切磋
--             if not self.设置.切磋开关 then
--                 self.rpc:提示窗口('只有野外可以强制PK!')
--                 return
--             end
--             if not 玩家.设置.切磋开关 then
--                 self.rpc:提示窗口('对方未开启切磋开关!')
--                 return
--             end
--         end
--     else
--         self.rpc:提示窗口('该玩家离你太远!')
--         return
--     end
--     if self.是否组队 then
--         for k,v in self:遍历队伍() do
--             if v.nid == nid then
--                 self.rpc:提示窗口('同队无法PK')
--                 return
--             end
--         end
--     end

--     --切磋:在双方玩家都打开切磋开关的条件下,除特定地图外,可以进入切磋战斗
--     --强P:在暗雷场景下,且发起攻击方拥有夺命香状态,且发起方关闭了切磋开关,可以进入强P战斗,PK战斗中,发起PK方无法逃跑

--     --设置战斗类型
--     local 是否强P = false
--     if self.当前地图.可遇怪 then
--         if not self.设置.切磋开关 then--己方未开启切磋开关,进入强P模式
--             if self.是否组队 then
--                 if self.是否队长 then
--                     local 满足 = true
--                     for k,v in self:遍历队伍() do
--                         local r = v:任务_获取("夺命香")
--                         if not r then
--                             满足 = false
--                         end
--                     end
--                     if 满足 then
--                         是否强P = true
--                     else
--                         self.rpc:提示窗口('#R发起强制PK战斗需要全队服用夺命香')
--                     end
--                 else
--                     self.rpc:提示窗口('#R只能由队长发起强制PK战斗')
--                     return
--                 end
--             else
--                 local r = self:任务_获取("夺命香")
--                 if r then
--                     是否强P = true
--                 end
--             end
--         end
--     end
--     if 是否强P then
--         self:战斗_初始化(玩家,'PK')
--     else
--         self:战斗_初始化(玩家,'切磋')
--     end
-- end
function 角色:角色_进入PK(nid)
if __副本地图[self.当前地图.接口.id] and self.当前地图.接口.名称 == '比武场' then
        if tonumber(os.date('%H', os.time())) ~= 20 then
            self.rpc:提示窗口('非帮战期间禁止PK')
            return
        end
        if self.帮派 and __帮派[self.帮派] and __帮派[self.帮派].帮战结束 then
            self.rpc:提示窗口('非帮战期间禁止PK')
            return
        end
        local 玩家 = self.周围玩家[nid]
        if self.帮派 and 玩家.帮派 and self.帮派 == 玩家.帮派 then
        self.rpc:提示窗口('同帮派成员无法进行PK')
        return
        end
        if 玩家 then
            if self.是否组队 then
                for k,v in self:遍历队伍() do
                    if v.nid == nid then
                        self.rpc:提示窗口('同队无法PK')
                        return
                    end
                end
            end
            self:战斗_初始化(玩家,'帮战')
        end
    else
        local 玩家 = self.周围玩家[nid]
        if 玩家 then
            if 玩家.是否摆摊 then
                self.rpc:提示窗口('对方处于无法战斗状态!')
                return
            end
            -- if not self.当前地图.可遇怪 then--安全区只能切磋
            --     if not self.设置.切磋开关 then
            --         self.rpc:提示窗口('只有野外可以强制PK!')
            --         return
            --     end
            --     if not 玩家.设置.切磋开关 then
            --         self.rpc:提示窗口('对方未开启切磋开关!')
            --         return
            --     end
            -- end
        else
            self.rpc:提示窗口('该玩家离你太远!')
            return
        end
        if self.是否组队 then
            for k,v in self:遍历队伍() do
                if v.nid == nid then
                    self.rpc:提示窗口('同队无法PK')
                    return
                end
            end
        end

        --切磋:在双方玩家都打开切磋开关的条件下,除特定地图外,可以进入切磋战斗
        --强P:在暗雷场景下,且发起攻击方拥有夺命香状态,且发起方关闭了切磋开关,可以进入强P战斗,PK战斗中,发起PK方无法逃跑

        --设置战斗类型
        local 是否强P = false
        if self.当前地图.可遇怪 then
            if not self.设置.切磋开关 then--己方未开启切磋开关,进入强P模式
                if self.是否组队 then
                    if self.是否队长 then
                        local 满足 = true
                        for k,v in self:遍历队伍() do
                            local r = v:任务_获取("夺命香")
                            if not r then
                                满足 = false
                            end
                        end
                        if 满足 then
                            是否强P = true
                        else
                            self.rpc:提示窗口('#R发起强制PK战斗需要全队服用夺命香')
                        end
                    else
                        self.rpc:提示窗口('#R只能由队长发起强制PK战斗')
                        return
                    end
                else
                    local r = self:任务_获取("夺命香")
                    if r then
                        是否强P = true
                    end
                end
            end
        end
        if 是否强P then
            self:战斗_初始化(玩家,'PK')
        else
            self:战斗_初始化(玩家,'切磋')
        end
    end
end

function 角色:水陆进入战斗(nid)
    local 玩家 = __玩家[nid]
    if 玩家 then
        print('有队伍进入水陆战斗')
        self:战斗_初始化(玩家,'水陆')
    else
        print('玩家不存在或离线无法进入水陆战斗')
    end
end

function 角色:上线(id,数据)
    self.加锁状态 = false
    self.cid = id --网络
    self.可刷新 = false
    self.rpc:进入游戏(self:取登录数据(), self.设置)
    self.可刷新 = true
    __世界:添加玩家(self)
    if not self.是否机器人 then
        print(self.nid)
        __世界:发送系统('#Y欢迎#R#u#[0|%s$%s#]#u#Y进入游戏！', self.nid, self.名称)
    else
        self.活跃时间 = os.time()

    end
    --__世界:发送系统('#Y欢迎#R#u%s#u#Y进入游戏！', self.名称)

    if self.观看召唤 then
        self.观看召唤:召唤_观看(true)
    end
    if self.观看宠物 then
        self.观看宠物:宠物_观看(true)
    end

    self.task:任务上线(self.接口)
    self:角色_刷新外形()
    if 数据 then
        self.账号 = 数据.账号
        self.体验 = 数据.体验
    end
end



function 角色:角色_刷新外形()
    local r = self:任务_获取("变身卡")
    if r and r.外形 ~= self.原形 then
        if r.外形 then
            self.外形 = r.外形
            return self.外形
        end
    end
    if self.当前坐骑 then
        self.外形 = 5000 + self.原形 * 10 + self.当前坐骑.几座
        return self.外形
    end
    self.外形 = self.原形
end

local _名称颜色 = {
    569384191, --0, 63, 0,--568270335
    3077448959, --63, 29, 21,
    1340136191, --12, 59, 63,
    2837455103, --59, 9, 9,
}

function 角色:角色_取名称颜色()
    if _名称颜色[self.转生+1] then
        self.名称颜色 = _名称颜色[self.转生+1]
    end
end

function 角色:重新上线(id)
    self.rpc:弹出窗口('      #R注意:#Y 你的角色在其他设备登录#2')
    self.lscid = self.cid or self.lscid
    if _角色[self.lscid] and _角色[self.lscid].子角色 then
        for i,v in pairs(_角色[self.lscid].子角色) do
            if v.nid ~= self.nid then
                v.cid = id
                _角色[id].子角色[v.nid] = v
            end
        end
        _角色[self.lscid] = nil
        self.lscid = nil
    end
    self.cid = id
    self.是否掉线 = false
    self.可刷新 = false
    --self.状态 = {} --头顶
    self.窗口 = {}
    self:地图_初始化()
    self.rpc:进入游戏(self:取登录数据(), self.设置)

    self.可刷新 = true
    self:战斗_重连()

    -- if not self.是否战斗 then
        if self.是否组队 then
            self:刷新队伍信息()
        end
    -- end
end

function 角色:离线上线(id,数据)
    self.cid = id --网络
    self.离线角色 = true
    self.是否助战 = true
    -- self.rpc:进入游戏(self:取登录数据(), self.设置)
    self.可刷新 = true
    __世界:添加玩家(self)
    if not self.是否机器人 then
        __世界:发送系统('#Y欢迎#R#u#[0|%s$%s#]#u#Y进入游戏！', self.nid, self.名称)
    else
        self.活跃时间 = os.time()
    end
    --__世界:发送系统('#Y欢迎#R#u%s#u#Y进入游戏！', self.名称)

    if self.观看召唤 then
        self.观看召唤:召唤_观看(true)
    end
    if self.观看宠物 then
        self.观看宠物:宠物_观看(true)
    end

    self.task:任务上线(self.接口)
    self:角色_刷新外形()
    self:地图_初始化()
    if 数据 then
        self.账号 = 数据.账号
        self.体验 = 数据.体验
    end
end

function 角色:下线(子)
        if self.是否摆摊 then
            return
        end
    if self.是否机器人 then
        self:角色_离开队伍()
        self.当前地图:删除玩家(self)
        __世界:删除玩家(self)
        return
    end
    if self.是否战斗 then
        self.可刷新 = false
        -- if not 子 and _角色[self.cid] and _角色[self.cid].子角色 then
        --     for i,v in pairs(_角色[self.cid].子角色) do
        --         if v.nid ~= self.nid then
        --             v:掉线(1)
        --         end
        --     end
        -- end
        self.lscid = self.cid
        self.cid = nil
    else
        __世界:删除玩家(self)
        self:角色_离开队伍()
        self.可刷新 = false
        --rpc:交易关闭(self)
        --rpc:摆摊结束(self)
        --self:好友_下线()
        self.当前地图:删除玩家(self)
        self.当前地图:删除召唤(self.观看召唤)
        self.当前地图:删除宠物(self.观看宠物)
        self.登录时间 = 0
        self.task:任务下线(self.接口)
        self:存档()
        if not 子 and _角色[self.cid] and _角色[self.cid].子角色 then
            for i,v in pairs(_角色[self.cid].子角色) do
                if v.nid ~= self.nid then
                    v:下线(1)
                end
            end
            _角色[self.cid].子角色 = nil
        end
        self.cid = nil
        return true
    end
end
function 角色:角色_申请解锁(v)
    local 账号 = v
    if self.账号 then
        账号 = self.账号
    end
    -- if gge.isdebug then
    --     self.加锁状态 = false
    --     self.接口:常规提示('#Y调试模式:已打开物品锁,可进行交易、给予、商城购买等操作')
    --     return
    -- end
    if 账号 then
        local r = self.接口:输入窗口('', "请输入你的安全码")
        if r then
            local a = __存档.验证安全码(账号 , r)
            if a then
                self.加锁状态 = false
                self.接口:常规提示('#Y已打开物品锁,可进行交易、给予、商城购买等操作')
            else
                self.接口:常规提示('#Y安全码输入错误')
            end
        end
    end
end

function 角色:离线下线()
    if self.是否战斗 then
        self.可刷新 = false
        self.cid = nil
    else
        __世界:删除玩家(self)
        self:角色_离开队伍()
        self.可刷新 = false
        --rpc:交易关闭(self)
        --rpc:摆摊结束(self)
        --self:好友_下线()
        self.当前地图:删除玩家(self)
        self.当前地图:删除召唤(self.观看召唤)
        self.当前地图:删除宠物(self.观看宠物)
        self.登录时间 = 0
        self.task:任务下线(self.接口)
        self:存档()
        if not 子 and _角色[self.cid] and _角色[self.cid].子角色 then
            for i,v in pairs(_角色[self.cid].子角色) do
                if v.nid ~= self.nid then
                    v:下线(1)
                end
            end
            _角色[self.cid].子角色 = nil
        end
        self.cid = nil
        return true
    end
end

function 角色:存档()
    if self.是否机器人 then
        return
    end
    require('数据库/存档').角色存档(self:取存档数据())
end

--===========================================================================
--地图
--===========================================================================

function 角色:时辰刷新(时辰)
    if 时辰 == 5 or 时辰 == 11 then --白天黑夜
        -- for k,v in pairs(self.周围) do
        --     if v.type ==2 then--NPC
        --         self:地图_删除对象(v)
        --     end
        -- end
    end
end

function 角色:扣除积分(类型,数额)
    if not self.积分 then
        self.积分 = {}
        self.积分[类型] = 0
    end
    if self.积分[类型] < 数额 then
        return
    end
    self.积分[类型] = self.积分[类型] - 数额
end

function 角色:角色_初始化孩子()
    local 性别 = '男'
    if math.random(1, 100) <= 50 then
        性别 = '女'
    end
    local h = {
        名称 = self.名称..'的宝宝',
        性别 = 性别,
        年龄 = 0,
        气质 = 0,
        悟性 = 0,
        智力 = 0,
        耐力 = 0,
        内力 = 0,
        亲密 = 0,
        孝心 = 0,
        温饱 = 0,
        疲劳 = 0,
        状态 = '正常',
        天资 = {
            [1] = '淘气',
            [2] = '天真',
            [3] = '好奇',
        },
        参战 = false,
        培养次数 = 0,
        评价 = 0,
        装备 = {}
    }
    return h
end

function 角色:角色_孩子改名(序号,新名称)
    if self.孩子[序号] then
        self.孩子[序号].名称 = 新名称
        return true
    else
        return '你并没有这个孩子'
    end
end

function 角色:角色_获取孩子数据()
    if not self.孩子 then
        self.孩子 = {}
    end
    for k,v in pairs(self.孩子) do
        if not v.评价 then
            v.评价 = 0
        end
        self:角色_刷新孩子评价(k)
    end
    return self.孩子
end

function 角色:角色_刷新孩子评价(编号)
    if self.孩子[编号]==nil then
        self.接口:常规提示("没找到这个孩子")
        return
    end
    local 排序={}
    local 属性={"气质","内力","智力","耐力","悟性"}
    for k,v in pairs(self.孩子[编号]) do
        for i=1,#属性 do
            if k==属性[i] then
                排序[#排序+1]={值=v}
            end
        end
    end
    table.sort(排序,function(a,b) return a.值>b.值 end )
    local value = {600,180,150,120,90}
    local 评价=0
    for i=1,5 do
        评价=评价+value[i]*(排序[i].值^0.2)
    end
    评价 = 评价 + self.孩子[编号].亲密 * 20 + self.孩子[编号].孝心 * 20
    self.孩子[编号].评价=math.floor(评价)
end

function 角色:角色_孩子参战(x)
    if not self.孩子[x] then
        return "没找到这个孩子"
    end
    -- if self.孩子[x].培养次数 < 1200 then
    --     local sz = 1200 - self.孩子[x].培养次数
    --     return '你的孩子还没长大,需要再培养至少'..sz..'次'
    -- end
    if self.孩子[x].参战 then
        self.孩子[x].参战 = false
        self.接口:常规提示("已取消参战")
        self.孩子参战 = nil
    else
        self.孩子[x].参战 = true
        self.接口:常规提示("已参战")
        self.孩子参战 = self.孩子[x]
    end
    for k,v in pairs(self.孩子) do
        if v.参战 then
            if k ~= x then
                v.参战 = false
            end
        end
    end
    return self.孩子[x]
end

function 角色:角色_孩子培养(i,x,all)
    if not self.孩子[x] then
        return "没找到这个孩子"
    end
    if not self.孩子[x].培养次数 then
        self.孩子[x].培养次数 = 0
    end
    if not self.是否战斗 and not self.是否摆摊 and not self.是否交易 then
        local item = self.物品[i]
        if item then
            if item.孩子是否可用 then
                if item.名称 == '猕猴桃' then
                    local 天资 = MYF.取孩子随机天资()
                    local 文本 = '请选择一项你想要覆盖的天资\nmenu\n1|'..self.孩子[x].天资[1]..'\n2|'..self.孩子[x].天资[2]..'\n3|'..self.孩子[x].天资[3]..'\n4|什么也不做'
                    local xx = self.接口:选择窗口(文本)
                    if xx then
                        self.孩子[x].天资[tonumber(xx)] = 天资
                        self.接口:常规提示('#Y你的孩子获得新的天资#G'..天资)
                    end
                elseif item.名称 == '金丹' then
                    local 天资 = MYF.取孩子高级天资()
                    local 文本 = '请选择一项你想要覆盖的天资\nmenu\n1|'..self.孩子[x].天资[1]..'\n2|'..self.孩子[x].天资[2]..'\n3|'..self.孩子[x].天资[3]..'\n4|什么也不做'
                    local xx = self.接口:选择窗口(文本)
                    if xx then
                        self.孩子[x].天资[tonumber(xx)] = 天资
                        self.接口:常规提示('#Y你的孩子获得新的天资#G'..天资)
                    end
                elseif item.名称 == '仙童果' then
                    if self.接口:取活动限制次数('仙童果') > 10 then
                        return '此物不易服用过多,请明日后继续服用'
                    end
                    self.接口:增加活动限制次数('仙童果')
                    local sj = math.random(1, 5)
                    self.孩子[x].亲密 = self.孩子[x].亲密 + sj
                    self:角色_刷新孩子评价(x)
                elseif item.名称 == '孝经' then
                    if self.接口:取活动限制次数('孝经') > 10 then
                        return '此物不易服用过多,请明日后继续服用'
                    end
                    self.接口:增加活动限制次数('孝经')
                    local sj = math.random(1, 5)
                    self.孩子[x].孝心 = self.孩子[x].孝心 + sj
                    self:角色_刷新孩子评价(x)
                else
                    if self.孩子[x].培养次数 >= 1728 then
                        return '你的孩子培养次数已满'
                    end
                    local 次数,实际次数 = 1 , 0
                    if all then
                        次数 = item.数量
                    end
                    for i=1,次数 do
                        if item.属性 then
                            for k,v in pairs(item.属性) do
                                if self.孩子[x][k] then
                                    self.孩子[x][k] = self.孩子[x][k] + v
                                end
                            end
                            self.孩子[x].培养次数 = self.孩子[x].培养次数 + 1
                            实际次数 = 实际次数 + 1
                            if self.孩子[x].培养次数 >= 1728 then
                                break
                            end
                        end
                    end
                    local 数量 = 1728 - self.孩子[x].培养次数
                    self.接口:常规提示('#Y培养成功,剩余可培养次数'..数量)
                    self:角色_刷新孩子评价(x)
                    item:减少(次数)
                    if self.物品[i] == nil then
                        return 2 , nil , self.孩子[x]
                    end
                    return 1, item:取简要数据(), self.孩子[x]
                end

                local r = item:使用(self.接口)
                if type(r) == 'string' then
                    return 0, r
                elseif self.物品[i] == nil then --删除
                    return 2
                end
                return 1, item:取简要数据(), self.孩子[x]
            elseif item.孩子装备 and item.部位 then
                local 性别 = MYF.取孩子装备性别限制(item.名称)
                if 性别 ~= '通用' and 性别 ~= self.孩子[x].性别 then
                    return '这件装备不适合你的宝宝穿戴'
                end
                self.物品[i] = self.孩子装备[(x - 1) * 4 + item.部位]--
                if self.孩子装备[(x - 1) * 4 + item.部位] then
                    self:角色_卸下孩子装备(x,item.部位)
                end
                self:角色_穿戴孩子装备(x,item)
                self:角色_刷新孩子评价(x)

                return 3, item.部位, self.孩子[x]
            end
        end
    end
end

function 角色:角色_脱下孩子装备(x,部位)
    if not self.孩子[x] then
        return "没找到这个孩子"
    end
    if type(部位) == 'number' then
        local n = self:物品_查找空位()
        if n then
            self.物品[n] = self.孩子装备[(x - 1) * 4 + 部位]
            self:角色_卸下孩子装备(x,部位)
            self:角色_刷新孩子评价(x)
            return true, self.孩子[x]
        end
    end
end

function 角色:角色_卸下孩子装备(x,部位)
    for k,v in pairs(self.孩子装备[(x - 1) * 4 + 部位].装备属性) do
        if self.孩子[x][k] then
            self.孩子[x][k] = self.孩子[x][k] - v
        end
    end
    self.孩子装备[(x - 1) * 4 + 部位] = nil
end

function 角色:角色_穿戴孩子装备(x,装备)
    for k,v in pairs(装备.装备属性) do
        if self.孩子[x][k] then
            self.孩子[x][k] = self.孩子[x][k] + v
        end
    end
    self.孩子装备[(x - 1) * 4 + 装备.部位] = 装备
    -- local a = (x - 1) * 4 + 装备.部位
    -- print(a)
    table.print(self.孩子装备)
    -- table.print(装备)
end
function 角色:角色_添加仙玉(n)
    self.仙玉 = self.仙玉 + n
end

function 角色:角色_卡密兑换(卡号)
    local 面值 = 0
    for i=1,#__CDK do
        if __CDK[i][1] == 卡号 then
            面值 = __CDK[i][2]
        end
    end
    if 面值 == 0 then
        self.rpc:提示窗口('#Y无效的卡密')
        return
    end
    if not validate_card('PayLog.csv', 卡号) then
        self.rpc:提示窗口('#Y卡密已被使用')
        return
    end
	if 面值=='月卡' then
		面值=20
		 self:物品_添加({__沙盒.生成物品 {名称 = 'VIP月卡', 数量 = 1}})
		 self.rpc:提示窗口('#Y月卡已经发放,注意包裹内查看')
	end
    local time = os.date("%Y年%m月%d日 %H:%M:%S", os.time())
    record_card('PayLog.csv', 卡号, 面值, time)

    local 仙玉数量 = 面值 * 100
    self.仙玉 = self.仙玉 + 仙玉数量
    if not self.充值 then
        self.充值 = 0
    end
    self.充值 = self.充值 + 面值
    local 礼包范围 = {10,100,500,1000,2000,5000}
    if not self.礼包 then
        self.礼包 = {}
    end
    for i=1,#礼包范围 do
        if self.充值 >= 礼包范围[i] then
            if not self.礼包[礼包范围[i]] then
                self:角色_发放礼包(礼包范围[i])
                self.礼包[礼包范围[i]] = true
            end
        end
    end
    self.rpc:提示窗口('#Y通过卡密兑换获得#G'..仙玉数量..'#Y仙玉')
end

function 角色:角色_发放礼包(类型)
    if 类型 == 128 then
        self.仙玉 = self.仙玉 + 10000
        self.rpc:提示窗口('#Y你获得了#R10000#Y仙玉')
        self.刷新的属性.银子 = true
        self.银子 = self.银子 + 10000000
        self.rpc:提示窗口('#Y你获得了#R10000000#Y两银子')
        self:物品_添加({__沙盒.生成物品 {名称 = '5级神兵礼盒', 数量 = 1}})
        self:物品_添加({__沙盒.生成物品 {名称 = '随机神兽宝盒', 数量 = 1}})
        self:物品_添加({__沙盒.生成物品 {名称 = '亲密丹' , 参数 = 100000 , 数量 = 5}})
        self:物品_添加({__沙盒.生成物品 {名称 = '超级金柳露', 数量 = 5}})
        self:物品_添加({__沙盒.生成物品 {名称 = '超级清盈果', 数量 = 5}})
        self.rpc:提示窗口('#Y已获得累充128礼包')
    elseif 类型 == 328 then
        self.仙玉 = self.仙玉 + 50000
        self.rpc:提示窗口('#Y你获得了#R50000#Y仙玉')
        self.刷新的属性.银子 = true
        self.银子 = self.银子 + 50000000
        self.rpc:提示窗口('#Y你获得了#R50000000#Y两银子')
        self:物品_添加({__沙盒.生成物品 {名称 = '超级清盈果', 数量 = 10}})
        self:物品_添加({__沙盒.生成物品 {名称 = '六魂之玉' , 数量 = 10}})
        self:物品_添加({__沙盒.生成物品 {名称 = '悔梦石', 数量 = 20}})
        self:物品_添加({__沙盒.生成物品 {名称 = '5级神兵礼盒', 数量 = 3}})
        self:物品_添加({__沙盒.生成物品 {名称 = '亲密丹' , 参数 = 100000 , 数量 = 10}})
        self:物品_添加({__沙盒.生成物品 {名称 = '4阶仙器礼盒', 数量 = 1}})
        self:物品_添加({__沙盒.生成物品 {名称 = '神兽自选礼包', 数量 = 1}})
        self.rpc:提示窗口('#Y已获得累充328礼包')
    elseif 类型 == 648 then
        self.仙玉 = self.仙玉 + 100000
        self.rpc:提示窗口('#Y你获得了#R100000#Y仙玉')
        self.刷新的属性.银子 = true
        self.银子 = self.银子 + 100000000
        self.rpc:提示窗口('#Y你获得了#R100000000#Y两银子')
        self:物品_添加({__沙盒.生成物品 {名称 = '超级清盈果', 数量 = 20}})
        self:物品_添加({__沙盒.生成物品 {名称 = '六魂之玉' , 数量 = 20}})
        self:物品_添加({__沙盒.生成物品 {名称 = '悔梦石', 数量 = 50}})
        self:物品_添加({__沙盒.生成物品 {名称 = '五级神兵自选', 数量 = 2}})
        self:物品_添加({__沙盒.生成物品 {名称 = '亲密丹' , 参数 = 100000 , 数量 = 30}})
        self:物品_添加({__沙盒.生成物品 {名称 = '5阶仙器礼盒', 数量 = 1}})
        self:物品_添加({__沙盒.生成物品 {名称 = '神兽自选礼包', 数量 = 2}})
        self.rpc:提示窗口('#Y已获得累充648礼包')
    elseif 类型 == 1280 then
        self.仙玉 = self.仙玉 + 200000
        self.rpc:提示窗口('#Y你获得了#R200000#Y仙玉')
        self.刷新的属性.银子 = true
        self.银子 = self.银子 + 200000000
        self.rpc:提示窗口('#Y你获得了#R200000000#Y两银子')
        self:物品_添加({__沙盒.生成物品 {名称 = '超级清盈果', 数量 = 40}})
        self:物品_添加({__沙盒.生成物品 {名称 = '六魂之玉' , 数量 = 30}})
        self:物品_添加({__沙盒.生成物品 {名称 = '高级悔梦石', 数量 = 50}})
        self:物品_添加({__沙盒.生成物品 {名称 = '神兵自选礼包', 数量 = 1}})
        self:物品_添加({__沙盒.生成物品 {名称 = '亲密丹' , 参数 = 100000 , 数量 = 50}})
        self:物品_添加({__沙盒.生成物品 {名称 = '六级仙器礼包', 数量 = 1}})
        self:物品_添加({__沙盒.生成物品 {名称 = '神兽自选礼包', 数量 = 5}})
        self.rpc:提示窗口('#Y已获得累充1280礼包')
    elseif 类型 == 2560 then
        self.仙玉 = self.仙玉 + 450000
        self.rpc:提示窗口('#Y你获得了#R450000#Y仙玉')
        self.刷新的属性.银子 = true
        self.银子 = self.银子 + 1000000000
        self.rpc:提示窗口('#Y你获得了#R1000000000#Y两银子')
        self:物品_添加({__沙盒.生成物品 {名称 = '超级清盈果', 数量 = 100}})
        self:物品_添加({__沙盒.生成物品 {名称 = '六魂之玉' , 数量 = 100}})
        self:物品_添加({__沙盒.生成物品 {名称 = '高级悔梦石', 数量 = 120}})
        self:物品_添加({__沙盒.生成物品 {名称 = '神兵自选礼包', 数量 = 2}})
        self:物品_添加({__沙盒.生成物品 {名称 = '亲密丹' , 参数 = 100000 , 数量 = 100}})
        self:物品_添加({__沙盒.生成物品 {名称 = '六级仙器礼包', 数量 = 3}})
        self:物品_添加({__沙盒.生成物品 {名称 = '神兽自选礼包', 数量 = 10}})
        self.rpc:提示窗口('#Y已获得累充2560礼包')
    end
end

function 角色:角色_召唤兽驯养(...)
    local t = __沙盒.生成任务({ 名称 = '驯养召唤兽' ,循环 = 0,时间 = os.time() + 3600 , 消耗成就 = 0,驯养数值 = 0, 召唤兽 = ... })
    self:任务_添加(t)
    self.rpc:提示窗口('#Y开始驯养')
end

return 角色
