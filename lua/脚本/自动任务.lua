-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-02-25 21:22:54
-- @Last Modified time  : 2024-08-24 09:57:22

local 自动任务 = class('自动任务')
local __gui
function 自动任务:初始化(根)
    __gui = 根
end

local function 取地图名称(id)
    local map = gge.require('数据/地图库')
    if map[id] then
        return map[id].name
    end
    return id
end

local 对话 = {
    [[
春眠不觉晓，鼾声惊飞鸟。人间鬼太多，钟馗累坏了。#91你们别总当钟馗是个抓鬼的粗人，其实我也投过功名，可惜生地丑，被那皇帝老儿取消了殿试资格#78。
menu
1|我来帮你
99|我只是路过
]],
    [[
经天庭将士用命，终将御马监四大妖王镇压。奈何四大妖王非同一般，仍有无数分身逃逸。是故吾立捉妖榜，发布天庭任务。三界侠士皆可揭榜捉妖，以维护三界和平，兼可获得天庭嘉奖。少侠是否要揭榜捉妖?
menu
1|为民除害，义不容辞！
4|我只是路过看看
]],
    [[
昔日孙悟空大闹地府，使得地狱中的鬼魂倾巢而出，由于逃出的鬼魂过长时间没有被超度现如今在三界中吸尽了阴气化为鬼王，鬼王的出现严重影响到了大唐子民，为免鬼王的出现扰乱人间秩序，地藏王大人下令招募三界有志之士前往捉拿正在危害人间的鬼王，成功捉拿者将论功行赏。
menu
1|在下愿为三界出一份力！
99|说啥呢！？怎么这么高深呢？！听不懂，闪先
]],

    [[
近来修罗频繁越境，更幻化假身四处作乱，虽然我法力强，无赖最近从抓来的越境修罗口里得知，有一个修罗族很厉害的头头也要越境，所以我不得不在这里守着，片刻不能离开。
menu
1|闲来无事，要我帮忙吗
99|离开
]],







}

function 自动任务:意外中断() --todo手动移动也清空
    self.开始 = false
    self.战斗锁 = false
    self._定时延迟 = nil
    self.间隔定制 = nil
    --  self.数据 = nil
end

function 自动任务:设置任务(t)
    self.开始 = true
    self.战斗锁 = false
    self.数据 = t
    local path = '{' .. 取地图名称(t.id) .. ',' .. t.x .. ',' .. t.y .. '}'
    __gui.界面层.任务追踪:自动寻路点击(path)
end

function 自动任务:到达终点()
    if not self.数据 or not self.开始 or not self.数据.类型 then
        self.开始 = false
        return
    end

    self.战斗锁 = true
    __rpc:角色_自动任务_进入战斗(self.数据.类型)
end

function 自动任务:设置返回()
    if not self.数据 then
        return
    end

    self.战斗锁 = false
    if self.数据.类型 == "日常_抓鬼任务" then --todo nil
        __rpc:角色_自动任务_地图跳转(1122, 32, 55, "三界符")
        self:领取任务("日常_抓鬼任务")
    elseif self.数据.类型 == "日常_天庭任务" then
        __rpc:角色_自动任务_地图跳转(1111, 145, 115)
        self:领取任务("日常_天庭任务")
    elseif self.数据.类型 == "日常_鬼王任务" then
        __rpc:角色_自动任务_地图跳转(1124, 23, 15, "鬼狱灵反符")
        self:领取任务("日常_鬼王任务")
    elseif self.数据.类型 == "日常_修罗任务" then
        __rpc:角色_自动任务_地图跳转(1001, 241, 79)
        self:领取任务("日常_修罗任务")
    elseif self.数据.类型 == "打海盗" then
        __rpc:角色_自动任务_地图跳转(1208, 38, 116)
        self:领取任务("打海盗")
    end
end

function 自动任务:领取任务(name)
    self._定时延迟 = 引擎:定时(
        1000,
        function(ms)
            if not 引擎.切换地图回调 then
                __rpc:角色_自动任务_添加任务(name)
                return 0
            end
            return ms
        end
    )
end

function 自动任务:战斗结束(s)
    if s then --胜利  返回
        self:设置返回()
    else      --失败 继续 间隔
        self.间隔定制 = 引擎:定时(
            2000,
            function(ms)
                if self.开始 then --
                    self.战斗锁 = false
                    if not __rol.是否战斗 then
                        self:设置任务(self.数据)
                        return 0
                    end
                end
                return ms
            end
        )
    end
end

return 自动任务
