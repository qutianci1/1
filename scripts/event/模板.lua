-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-27 13:51:21
-- @Last Modified time  : 2022-08-02 15:02:38
--{year =2022, month = 7, day =27, hour =0, min =0, sec = 00}
--年月日 时分秒
local 事件 = {
    名称 = '模板',
    是否打开 = true,
    开始时间 = os.time {year = 2022, month = 7, day = 25, hour = 0, min = 0, sec = 00},
    结束时间 = os.time {year = 2022, month = 8, day = 30, hour = 0, min = 0, sec = 00}
}

function 事件:事件初始化()
    self.NPC = {}
end

function 事件:更新()
    local map = self:取地图(1208)

    local X, Y = map:取随机坐标()
    local NPC =
        map:添加NPC {
        名称 = '妖怪',
        外形 = 2001,
        脚本 = 'scripts/event/模板.lua',
        X = X,
        Y = Y,
        时间 = 100,
        来源 = self
    }
    self:发送系统('妖怪在 #G%s(%d,%d) #W出现', map.名称 ,X, Y)
    return not self.是否结束 and 10
end

function 事件:事件开始()
    -- print('活动开始了')
    -- self:发送系统('活动开始了')
    -- self:定时(10, self.更新)
end

function 事件:事件结束()
    self.是否结束 = true
end
--=======================================================
local 对话 = [[没想到我躲在这里，也会被你们发现，休想抓我回去。#4
menu
1|妖孽，受死吧
2|我认错人了
]]
function 事件:NPC对话(玩家, i)
    return 对话
end

function 事件:NPC菜单(玩家, i)
    print(i)
    if i == '1' then
        self:删除()
    end
end
return 事件
