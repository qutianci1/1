-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-05-05 22:18:43
-- @Last Modified time  : 2023-11-16 18:46:37

local 物品 = {
    名称 = '夜明珠',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    local map = 对象:取当前地图()
    if map.名称 ~= '龙宫' then
        对象:提示窗口('#Y无法使用')
        return
    end
    local 作用 = ''
    local r = 对象:取任务('【坐骑一】信字当头')
    if r then
        if r.进度 == 9 then
            作用 = '坐骑'
            local v = 对象:进入战斗('scripts/task/坐骑剧情/【坐骑一】信字当头.lua',r)
            if v then
                if math.random(100) <= 50 then
                    对象:添加物品({生成物品 {名称 = '避水珠', 数量 = 1}})
                    r.进度 = 10
                end
            end
            return
        end
    end
    if os.date('%w', os.time()) == '6' or os.date('%w', os.time()) == '0' then
        作用 = '龙宫寻宝'
    end

    if 作用 == '龙宫寻宝' then
        if 对象:取活动限制次数('龙宫寻宝') > 120 then
            对象:常规提示('本日奖励次数已尽,无法继续获得奖励')
            return
        end
        local v = 对象:进入战斗('scripts/war/战斗_龙宫寻宝.lua')
        if v then
            对象:增加活动限制次数('龙宫寻宝')
            local 银子 = 0
            local 经验 = 5000
            对象:添加银子(银子)
            对象:添加任务经验(经验)
            if 对象:检查空位() then--这里调用的奖励池是 服务端/data下的奖励池,不要改错
                local 奖励 = 是否奖励(2002,对象.等级,对象.转生)
                if 奖励 ~= nil and type(奖励) == 'table' then
                    local r = 生成物品 { 名称 = 奖励.道具信息.道具, 数量 = 奖励.道具信息.数量, 参数 = 奖励.道具信息.参数 }
                    if r then
                        对象:添加物品({ r })
                        if 奖励.道具信息.是否广播 == 1 and 奖励.广播 ~= nil then
                            对象:发送系统(奖励.广播, 对象.名称, r.ind, r.名称)
                        end
                    end
                end
            else
                return '你的物品栏已满,无法继续获得物品'
            end
        end
    elseif 作用 == '' then
        对象:提示窗口('#Y无法使用')
    end
end

return 物品
