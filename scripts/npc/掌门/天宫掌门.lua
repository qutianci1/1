-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-04-11 04:21:55
-- @Last Modified time  : 2023-06-01 16:28:03

local NPC = {}
local 对话 = {
[[找我有何事？
menu
向掌门请教绝技
为掌门打工
没事随便逛逛
]],

[[找我有何事？
menu
交付师门任务
取消任务
没事随便逛逛
]],

[[你不是本门弟子
]]
}
--种族 人魔仙鬼
--性别 男女
local _smjn = { '雷霆霹雳', '日照光华', '雷神怒击', '电闪雷鸣', '天诛地灭' }
local _qjxh = { 150000, 200000, 340000, 600000, 900000 }
function NPC:NPC对话(玩家, i)
    if 玩家.种族 == 3 then
        return 对话[1]
    end
    return 对话[3]
end

function NPC:NPC菜单(玩家, i)
    if i == '向掌门请教绝技' then
        local r = self:技能选项(玩家)
        if r then
            local 新对话 = string.format([[练法没有捷径,只有多多使用才能提高。经过大家的努力,昔日常与各大门派派为难的那些人现已全部被收服,但是他们对法术的掌握早已炉火纯青，你可以去找他们练习法术！
menu
%s
]], table.concat(r, "\n"))
            return 新对话
        end
    elseif i == '为掌门打工' then
        if 玩家:取活动限制次数('掌门打工') < 3 then
            if 玩家.体力 then
                if 玩家.体力 >= 30 then
                    玩家.体力 = 玩家.体力 - 30
                    玩家:添加师贡(1000000)
                    玩家:增加活动限制次数('掌门打工')
                else
                    玩家:提示窗口('#Y你的体力不足30')
                end
            end
        else
            玩家:提示窗口('#Y今天你已经太累了,明天再来吧')
        end
    elseif i == '1' or i == '2' or i == '3' or i == '4' or i == '5' then
        if 玩家:扣除师贡(_qjxh[i + 0]) then
            local 基础奖励 = 240
            if math.random(100) <= 10 then
                基础奖励 = 320
                玩家:提示窗口('#Y恭喜你人品爆发,获得80点额外熟练度')
            end
            print(_smjn[i + 0])
            玩家:添加技能熟练度(_smjn[i + 0] , 240)
        end
    end
end

function NPC:技能选项(玩家)
    -- local 列表 = ''
    -- for i=1,#_smjn do
    --     if not 玩家:取技能是否满熟练(_smjn[i]) then
    --         列表 = 列表 .. '请掌门亲自指点' .. _smjn[i] .. '(需师门贡献'.._qjxh[i]..')' .. '\n'
    --     end
    -- end
    local 列表 = {}
    for i=1,#_smjn do
        列表[#列表 + 1] = #列表+1 .. '|' .. '请掌门亲自指点' .. _smjn[i] .. '(需师门贡献'.._qjxh[i]..')'
    end
    return 列表
end

function NPC:领取师门任务(玩家)

end

function NPC:NPC给予(玩家, cash, items)

    return '你给我什么东西？'
end

return NPC