-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-06 19:05:22
-- @Last Modified time  : 2023-05-23 11:41:20

local 任务 = {
    名称 = '灵兽降世',
    别名 = '灵兽降世',
    类型 = '坐骑任务',
    是否可取消 = false,
    是否可追踪 = false,
}

function 任务:任务初始化()
    self.孵蛋成功 = false
end

function 任务:任务上线(玩家)
    --self:删除()
end

function 任务:任务更新(玩家, sec)
end


function 任务:任务取详情(玩家)
    return '#Y任务目的#r灵兽蛋需有天地灵力相助才能孵化。请带上灵兽蛋在#G北俱芦洲#W与野怪战斗，帮助灵兽降世。#r战斗满10场后就有几率孵化灵兽蛋，满#R50#W场后100%孵化。#r战斗：'..self.进度..'/50'
end

function 任务:添加任务(玩家)
    return true
end

function 任务:添加进度(玩家)
    self.进度 = self.进度 + 10
    self:是否孵化(玩家)
end

function 任务:是否孵化(玩家)
    if self.进度 >= 50 then
        self:完成(玩家)
    else
        if self.进度 >= 10 then
            local 几率 = self.进度 * 0.02
            if math.random() <= 几率 then
                self:完成(玩家)
            else
                玩家:提示窗口('#R你的灵兽蛋吸纳了妖魔的元气，似乎快要孵化出来了！')
            end
        end
    end
end

function 任务:完成(玩家)
    玩家:提示窗口('#R恭喜你！你的灵兽蛋已经成功孵化了，赶快去释放它吧！')
    self.孵蛋成功 = true
    -- self:删除()
end


function 任务:战斗初始化(玩家, NPC)
end

function 任务:战斗回合开始(dt)
end

function 任务:战斗结束(x, y)

end

return 任务
