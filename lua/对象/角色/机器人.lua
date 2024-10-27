-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2024-03-04 02:29:35
-- @Last Modified time  : 2024-08-15 12:00:37

local 角色 = require('角色')

--================================================================
function 角色:机器人_更新(sec)
    if self.是否机器人 and not self.是否战斗 then
        -- 10分钟活跃时间，否则下线机器人
        if self.活跃时间 + 600 < sec then
            self:下线()
            return
        end
        if self.是否队长 then
            self:下线()
            return
        end
        if not self.是否组队 then
            self:下线()
            return
        end
    end
end

function 角色:添加机器人(种族, 性别, 外形, 技能, 辅助技能)
    local 机器人 = __沙盒.生成机器人({
        转生 = self.转生,
        等级 = self.等级,
        种族 = 种族,
        性别 = 性别,
        外形 = 外形,
        技能 = 技能,
        辅助技能 = 辅助技能,
        地图 = self.地图,
        x = self.x,
        y = self.y
    })
    -- table.print(机器人)
    self:机器人添加队伍(机器人)
end

function 角色:角色_招募机器人(种族, 性别, 外形, 技能, 辅助技能)
     if not self.是否队长 then
         self.rpc:提示窗口('#Y您未组队！请先组队后！重新参战！#32')
         return
     end
    if self.接口:取队伍人数() >= 5 then
        self.rpc:提示窗口('#Y你的队伍已经满了')
        return
    end
    self:添加机器人(种族, 性别, 外形, 技能, 辅助技能)
end

function 角色:角色_踢出机器人(种族, 性别, 外形)
    self:机器人踢出队伍(种族, 性别, 外形)
end
