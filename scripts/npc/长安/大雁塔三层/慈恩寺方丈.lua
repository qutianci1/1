-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:55
-- @Last Modified time  : 2023-06-21 20:42:51

local NPC = {}
local 对话 = {
[[终于等到了你，本层的小妖已尽数被我收服，可这妖魔首领却法力高强，侠士，快拿上这块镇妖镜，去和你的同伴合阵铲除本层的妖魔首领吧。
menu
好,快给我镜子
等会,先等我喝酒壮胆
]],--1
[[施主手持镇妖镜前往提示所处,以镇妖镜照之既可使妖魔现行!
menu
我不小心遗失镇妖镜
等会,先等我喝酒壮胆
]],--2
[[阿弥陀佛，这世上诸多妖魔鬼怪，怎能一网打尽。佛我本同，众生皆有佛性。若想除魔，务必—心向善，存佛心、做善事，善哉善哉
menu
进入下一层
等会,先等我喝酒壮胆
]],--3
[[妖魔多为阴险狡诈之辈,我在本层降妖途中,不慎将镇压着本层首领的宝物一-聚魄画轴遗失，怀疑是本层妖魔所为，侠士可愿为我寻回这宝物?
menu
路不拾遗乃侠士所为,交给我了
等会,先等我喝酒壮胆
]],--4
[[侠士莫非害怕了本层的妖魔?
menu
暂时迷路了
]],--5
[[侠士莫非害怕了本层的妖魔?
menu
归还画轴
暂时迷路了
]],--6
[[阿弥陀佛，这世上诸多妖魔鬼怪，怎能一网打尽。佛我本同，众生皆有佛性。若想除魔，务必—心向善，存佛心、做善事，善哉善哉
menu
进入下一层
等会,先等我喝酒壮胆
]],--7
[[万物皆有五行，这五种元素相生相克，使万物循环不已。这层的首领更加狡猾，竟然布下了五行阵而藏匿其中，侠士，只有破除五行阵方能见到怪物真身。#R记住:金克木，木克土，土克水，水克火，火克金!#W那么破除五行阵就先从#G火妖#W开始吧。
menu
看我来破这五行阵
等会,先等我喝酒壮胆
]],--8
[[阿弥陀佛，这世上诸多妖魔鬼怪，怎能一网打尽。佛我本同，众生皆有佛性。若想除魔，务必—心向善，存佛心、做善事，善哉善哉
menu
阿弥陀佛
]],--9
[[阿弥陀佛，这世上诸多妖魔鬼怪，怎能一网打尽。佛我本同，众生皆有佛性。若想除魔，务必—心向善，存佛心、做善事，善哉善哉
menu
阿弥陀佛
]],--10
[[阿弥陀佛，这世上诸多妖魔鬼怪，怎能一网打尽。佛我本同，众生皆有佛性。若想除魔，务必—心向善，存佛心、做善事，善哉善哉
menu
阿弥陀佛
]],--11
[[感谢侠士为天下苍生所做的一切，后面的路就要全靠你们自己了，前方妖魔法力强大，老衲怕自己再没有能力来帮助各位侠士了，祝各位好运。
menu
多谢提醒,送我上去先
内急,稍等啊
]],--12
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
    if i == '1' then
    elseif i == '2' then
    elseif i == '3' then
    elseif i == '4' then
    end
end

return NPC
