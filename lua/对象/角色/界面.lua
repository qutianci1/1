-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-06-30 08:15:28
-- @Last Modified time  : 2024-08-23 09:20:18
local GGF = require('GGE.函数')
local 角色 = require('角色')

function 角色:界面_初始化()
    self.上次发言 = 0
end
--[[
[0]={0,255,0--0, 63, 0,}
[1]={228,108,78--63, 29, 21,}
[2]={48,238,255--12, 59, 63,}
[3]={199,40,41--59, 9, 9,}


16711935
3832303359
820969471
3341298175

]]
local function debug(self, str)
    if str == '1' then
        -- self:添加技能("测试技能", 1)

        -- self.名称颜色 = GGF.ftoi(0, 255, 0, 255)
        -- print(self.名称颜色)
        -- self.名称颜色 = GGF.ftoi(228,108,78, 255)
        -- print(self.名称颜色)
        -- self.名称颜色 = GGF.ftoi(48,238,255, 255)
        -- print(self.名称颜色)
        -- self.名称颜色 = GGF.ftoi(199,40,41, 255)
        -- print()
        -- self.名称颜色=3341298175
       -- 12,59,63
        -- local r = __沙盒.生成任务 { 名称 = '灵兽降世', 进度 = 0, 对话进度 = 0 }
        -- self:任务_添加(r)
        -- r = __沙盒.生成任务 { 名称 = '称谓9_抹杀孙悟空', 进度 = 0, 对话进度 = 0 }
        -- self:任务_添加(r)
        -- r = __沙盒.生成任务 { 名称 = '称谓9_蟠桃园的山妖', 进度 = 0, 对话进度 = 0 }
        -- self:任务_添加(r)
        return
    elseif str == '2' then
       -- self.名称颜色 = GGF.ftoi(0, 255, 0, 255)
       -- self:物品_添加({ __沙盒.生成物品 { 名称 = '三界符', 数量 = 1 } })
        --     __帮派数据 = {}
        --     local 编号= #__帮派数据 + 1
        --     local 初始数据 = {
        --         编号 = 编号,
        --         名称 = "客户端传来",
        --         等级 = 1,
        --         宗旨 = "帮主很懒，什么也没写",
        --         贸易金库 = 0,
        --         成员数量 = 1,
        --         最大成员数量 = 150,
        --         现任帮主=self.名称,
        --         帮派仓库 = {},
        --         成员数据 = {},
        --         申请列表 = {},
        --    }
        -- table.insert(__帮派数据[编号].成员数据,
        --    {名称 =self.名称,
        --    等级 = self.等级,
        --    转生 = self.转生,
        --    飞升 = self.飞升,
        --    成就 = 0,
        --    贡献 = 0,
        --    职务 = "帮主",
        --    种族 = self.种族,
        --     性别 = self.性别,
        --         })

        --    table.insert( __帮派数据,  初始数据  )


        self:清空技能()

        -- self.最大经验=80
        self:添加技能('龙卷雨击', 25000)
        self:添加技能('龙腾水溅', 25000)
        self:添加技能('龙啸九天', 25000)
        self:添加技能('蛟龙出海', 25000)
        self:添加技能('九龙冰封', 25000)
        self:添加技能('电闪雷鸣', 15000)
        self:添加技能('雷神怒击', 15000)
        self:添加技能('雷霆霹雳', 15000)
        self:添加技能('日照光华', 15000)
        self:添加技能('天诛地灭', 15000)

        self:添加技能('飞砂走石', 25000)
        self:添加技能('乘风破浪', 25000)
        self:添加技能('太乙生风', 25000)
        self:添加技能('风雷涌动', 25000)
        self:添加技能('袖里乾坤', 25000)
        -- self:添加技能('地狱烈火', 25000)
        -- self:添加技能('天雷怒火', 25000)
        -- self:添加技能('三味真火', 25000)
        -- self:添加技能('烈火骄阳', 25000)
        -- self:添加技能('九阴纯火', 25000)


        -- self:添加技能('吸血水蛭', 20000)
        -- self:添加技能('六翅毒蝉', 25000)
        -- self:添加技能('啮骨抽髓', 25000)
        -- self:添加技能('血煞之蛊', 25000)
        -- self:添加技能('吸星大法', 25000)
        -- self:添加技能('麻沸散', 20000)
        -- self:添加技能('鬼失惊', 25000)
        -- self:添加技能('乱魂钉', 25000)
        -- self:添加技能('失心疯', 25000)
        -- self:添加技能('孟婆汤', 25000)
        return
    -- elseif str == '3' then
    --     --self.名称颜色 = GGF.ftoi(255, 255, 255, 255)
    --     -- local s = self:召唤_添加(__沙盒.生成召唤 { 名称 = '小浪淘沙' })

    --     --self:召唤_添加(__沙盒.生成召唤 {名称 = '冲冲虫'})
    --     self:清空坐骑()
    --     self:坐骑_添加(__沙盒.生成坐骑 { 种族 = self.种族, 几座 = 1 })
    --     self:坐骑_添加(__沙盒.生成坐骑 { 种族 = self.种族, 几座 = 2 })
    --     self:坐骑_添加(__沙盒.生成坐骑 { 种族 = self.种族, 几座 = 3 })
    --     self:坐骑_添加(__沙盒.生成坐骑 { 种族 = self.种族, 几座 = 4 })
    --     self:坐骑_添加(__沙盒.生成坐骑 { 种族 = self.种族, 几座 = 5 })
    --     self:坐骑_添加(__沙盒.生成坐骑 { 种族 = self.种族, 几座 = 6 })

    -- elseif str == '4' then
    --     self:角色_帮派创建('天下第一帮')
    --     self:角色_帮派进入地图()
    -- elseif str == '5' then
    --     self:角色_帮派申请加入('天下第一帮')
    --     self:角色_帮派进入地图()
    -- elseif str == '6' then
    --     self.副本 = {
    --         __沙盒.生成地图(1004),
    --         __沙盒.生成地图(1005),
    --     }
    --     self.副本[1]:添加跳转({ X = 23, Y = 22, tid = self.副本[2].id, tX = 75, tY = 80 })
    --     self.副本[1]:添加NPC {
    --         名称 = "_地图[i].名称",
    --         外形 = 38,
    --         脚本 = 'scripts/npc/sf.lua',
    --         X = 20,
    --         Y = 26,
    --     }
    --     local map = self.副本[1]
    --     self:移动_切换地图(map, 280, 1700)
    elseif str == '结束战斗' then
        self:战斗_结束()
    end
end

function 角色:聊天_发送周围(str, ...)
    if str == '脱离战斗' then
        if self.是否战斗 then
            self.战斗:脱离战斗()
            return
        end
    end
    if os.time() - self.上次发言 < 2 then
        self.rpc:提示窗口('#R发言过快')
        return
    end
    self.上次发言 = os.time()
    if select('#', ...) > 0 then
        str = str:format(...)
    end
    if gge.isdebug then
        debug(self, str)
    end
    if self.是否战斗 then
        self.战斗:当前喊话(str)
    else
        self.rpc:添加喊话(self.nid, str) --
        self.rpn:添加喊话(self.nid, str)
    end
    --64 游侠
    --65 队伍
    --66 当前
    --67 帮派
    --68 夫妻
    --69 世界
    --70 GM
    --71 系统
    --72 私聊
    --73 经济
    --114 信息
    --115 战斗
    --116 祝福
    --154 团队
    --155 群聊
    --156 传音
    --157
    --158 贸易
    self.rpc:界面信息_聊天('#66 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
    self.rpn:界面信息_聊天('#66 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
end

function 角色:聊天_发送队伍(str, ...)
    if not self.是否组队 then
        self.rpc:提示窗口('#Y少侠,您不在队伍里面!#24')
        return
    end
    if os.time() - self.上次发言 < 1 then
        self.rpc:提示窗口('#R发言过快')
        return
    end
    self.上次发言 = os.time()
    if select('#', ...) > 0 then
        str = str:format(...)
    end
    if self.是否战斗 then
        self.战斗:队伍喊话('#65 ' .. str)
    else
        self.rpc:添加喊话(self.nid, '#65 ' .. str)
        self.rpt:添加喊话(self.nid, '#65 ' .. str)
    end
    self.rpc:界面信息_聊天('#65 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
    self.rpt:界面信息_聊天('#65 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
end

function 角色:聊天_发送帮派(str, ...)
    if not self.帮派 or not __帮派[self.帮派] or self.帮派 == '' then
        self.rpc:提示窗口('#R少侠,您还没有加入帮派!')
        return
    end
    if os.time() - self.上次发言 < 1 then
        self.rpc:提示窗口('#R发言过快')
        return
    end
    self.上次发言 = os.time()

    if select('#', ...) > 0 then
        str = str:format(...)
    end

    for k, v in __帮派[self.帮派]:遍历成员() do --遍历成员
        if __玩家[k] then --判断一下玩家是否在线
            __玩家[k].rpc:界面信息_聊天('#67 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
            __玩家[k].rpt:界面信息_聊天('#67 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
        end
    end

end

function 角色:聊天_发送私聊(str, ...)
    if os.time() - self.上次发言 < 1 then
        self.rpc:提示窗口('#R发言过快')
        return
    end
    self.上次发言 = os.time()
end

function 角色:聊天_发送世界(str, ...)
    if os.time() - self.上次发言 < 5 then
        self.rpc:提示窗口('#R发言过快')
        return
    end
    self.上次发言 = os.time()
    if select('#', ...) > 0 then
        str = str:format(...)
    end
    __世界.rpc:界面信息_聊天('#69 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
    if __事件.世界答题 and __事件.世界答题.是否打开 then
        __事件.世界答题:答案验证(str,self)
    end
end

function 角色:聊天_发送GM(str, ...)
    __世界.rpc:界面信息_聊天('#70 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
end

function 角色:聊天_发送传音(str, ...)

end

function 角色:聊天_发送信息(str, ...)
    __世界.rpc:界面信息_聊天('#114 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
end

function 角色:聊天_发送经济(str, ...)
    __世界.rpc:界面信息_聊天('#73 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
end

function 角色:聊天_发送夫妻(str, ...)
    __世界.rpc:界面信息_聊天('#68 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
end

function 角色:聊天_发送游侠(str, ...)
    __世界.rpc:界面信息_聊天('#64 [#[0|%s$%s#]]%s', self.nid, self.名称, str)
end

function 角色:角色_查看对象(nid)
    local o = __对象[nid]
    if o then
        local tp = ggetype(o)
        if tp == '物品' then
            return 1, o:取查看数据()
        elseif tp == '召唤' then
            return 2, o:取查看数据()
        end
    end
end

function 角色:角色_恢复气血()
    if self.气血 >= self.最大气血 then
        return
    end
    local list = {}
    for i, v in self:物品_遍历物品() do
        if v.取恢复气血值 then
            table.insert(list, { 物品 = v, 恢复值 = v:取恢复气血值(self) })
        end
    end
    table.sort(list, function(a, b)
        return a.恢复值 > b.恢复值
    end)
    if #list == 0 then
        return --"#Y你没有药品可以使用"
    end
    for i, v in ipairs(list) do
        repeat
            self.气血 = self.气血 + v.恢复值
            v.物品:减少(1)
        until self.气血 >= self.最大气血 or v.物品.数量 == 0
        if self.气血 >= self.最大气血 then
            break
        end
    end

    if self.气血 >= self.最大气血 then
        self.气血 = self.最大气血
    end
    self.rpc:添加特效(self.nid, 'add_hp')
    self.rpn:添加特效(self.nid, 'add_hp')
    return self.气血, self.最大气血
end

function 角色:角色_恢复法力()
    if self.魔法 >= self.最大魔法 then
        return
    end
    local list = {}
    for i, v in self:物品_遍历物品() do
        if v.取恢复魔法值 then
            table.insert(list, { 物品 = v, 恢复值 = v:取恢复魔法值(self) })
        end
    end
    if #list == 0 then
        return --"#Y你没有药品可以使用"
    end
    table.sort(list, function(a, b)
        return a.恢复值 > b.恢复值
    end)
    for i, v in ipairs(list) do
        repeat
            self.魔法 = self.魔法 + v.恢复值
            v.物品:减少(1)
        until self.魔法 >= self.最大魔法 or v.物品.数量 == 0
        if self.魔法 >= self.最大魔法 then
            break
        end
    end

    if self.魔法 >= self.最大魔法 then
        self.魔法 = self.最大魔法
    else

    end
    self.rpc:添加特效(self.nid, 'add_mp')
    self.rpn:添加特效(self.nid, 'add_mp')
    return self.魔法, self.最大魔法
end

function 角色:角色_恢复召唤气血()
    local S = self.参战召唤
    if not S then
        return
    end
    if S.气血 >= S.最大气血 then
        return
    end
    local list = {}
    for i, v in self:物品_遍历物品() do
        if v.取恢复气血值 then
            table.insert(list, { 物品 = v, 恢复值 = v:取恢复气血值(S) })
        end
    end
    if #list == 0 then
        return --"#Y你没有药品可以使用"
    end
    table.sort(list, function(a, b)
        return a.恢复值 > b.恢复值
    end)
    for i, v in ipairs(list) do
        repeat
            S.气血 = S.气血 + v.恢复值
            v.物品:减少(1)
        until S.气血 >= S.最大气血 or v.物品.数量 == 0
        if S.气血 >= S.最大气血 then
            break
        end
    end

    if S.气血 >= S.最大气血 then
        S.气血 = S.最大气血
    end
    if S and S == self.观看召唤 then
        self.rpc:添加特效(S.nid, 'add_hp')
        self.rpn:添加特效(S.nid, 'add_hp')
    end
    return S.气血, S.最大气血
end

function 角色:角色_恢复召唤魔法()
    local S = self.参战召唤
    if not S then
        return
    end
    if S.魔法 >= S.最大魔法 then
        return
    end
    local list = {}
    for i, v in self:物品_遍历物品() do
        if v.取恢复魔法值 then
            table.insert(list, { 物品 = v, 恢复值 = v:取恢复魔法值(S) })
        end
    end
    if #list == 0 then
        return --"#Y你没有药品可以使用"
    end
    table.sort(list, function(a, b)
        return a.恢复值 > b.恢复值
    end)
    for i, v in ipairs(list) do
        repeat
            S.魔法 = S.魔法 + v.恢复值
            v.物品:减少(1)
        until S.魔法 >= S.最大魔法 or v.物品.数量 == 0
        if S.魔法 >= S.最大魔法 then
            break
        end
    end

    if S.魔法 >= S.最大魔法 then
        S.魔法 = S.最大魔法
    end
    if S and S == self.观看召唤 then
        self.rpc:添加特效(S.nid, 'add_mp')
        self.rpn:添加特效(S.nid, 'add_mp')
    end
    return S.魔法, S.最大魔法
end

function 角色:角色_设置(k, v)
    self.设置[k] = v
    if k == '切磋开关' then
    elseif k == '接收物品' then
    elseif k == '加入好友' then
    elseif k == '接受组队' then
    elseif k == '宽高' then
        self.rect = require('GGE.矩形')(self.x, self.y, v[1], v[2])
        self.rect:置中心(self.rect.w // 2, self.rect.h // 2) --屏幕大小/2
    end
end

function 角色:角色_小地图(id)--用于显示地图NPC
    if os.date("%H") <= '18' or os.date("%H") >= '06' then --小于18时或者大于06时就就是06-18时这时间段
        if id == 1411 then
            id = 1001
        elseif id == 1413 then
            id = 1203
        elseif id == 1415 then
            id = 1193
        end
    end
    local map = __地图[id]
    if map then
        local list = {}
        for _, v in map:遍历固定NPC() do
            table.insert(list, {
                名称 = v.名称,
                分类 = v.分类,
                x = v.x,
                y = v.y
            })
        end
        if map.sub then
            for _, sid in pairs(map.sub) do
                for _, v in map:遍历跳转() do
                    if v.tid == sid then
                        local smap = __地图[sid]
                        local y = 0
                        for _, sv in smap:遍历固定NPC() do
                            table.insert(list, {
                                名称 = sv.名称,
                                分类 = sv.分类,
                                x = v.x,
                                y = v.y + y
                            })
                            y = y + 100
                        end
                        break
                    end
                end
            end
        end
        --飞行旗
        return list
    end
end
