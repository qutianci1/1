-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:55
-- @Last Modified time  : 2023-06-19 14:54:48

local NPC = {}
local 对话 = {
[[终于等到了你，本层的小妖已尽数被我收服，可这妖魔首领却法力高强，侠士，快拿上这块镇妖镜，去和你的同伴合阵铲除本层的妖魔首领吧。
menu
好,快给我镜子
等会,先等我喝酒壮胆
]],--1
[[施主还有何事？
menu
我不小心遗失了镇妖镜(任务道具请勿重复领取)
此地过于危险,我要离开
等会,先等我喝酒壮胆
]],--2
[[阿弥陀佛，这世上诸多妖魔鬼怪，怎能一网打尽。佛我本同，众生皆有佛性。若想除魔，务必—心向善，存佛心、做善事，善哉善哉
menu
进入下一层
等会,先等我喝酒壮胆
]],--3
}



function NPC:NPC对话(玩家, i)
    local r = 玩家:取任务('日常_大雁塔任务')
    if r then
        if r.进度 then
            return 对话[r.进度]
        end
    end
    return '雁塔佛地竟出现妖魔怨气，为了天下生灵，侠士您愿意赶赴塔中，为镇妖封魔而战吗？'
end

function NPC:NPC菜单(玩家, i)
    if i == '此地过于危险,我要离开' then
        local r = 玩家:取任务('日常_大雁塔任务')
        if r then
            r:任务取消(玩家)
        end
        玩家:切换地图(1001, 96, 200)
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
