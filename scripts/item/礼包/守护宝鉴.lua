-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:04:54
-- @Last Modified time  : 2023-05-18 18:25:02
local 物品 = {
    名称 = '守护宝鉴',
    叠加 = 999,
    类别 = 11,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}


local _守护宝鉴范围 = { "千年灵狐","龙门水将","护山大神","女贼之灵","玉兔","守护火神","守护复活","巡海夜叉","蟹将军","黄巾力士","金身罗汉","百花之灵","渔见愁","霹雳手","狐不皈","避水金睛兽","火麒麟","桃花娘子","净盘使者","守护符咒" }

function 物品:使用(对象)
    local mc = _守护宝鉴范围[math.random(1, #_守护宝鉴范围)]
    if mc then
        local r = 生成召唤 { 名称 =mc }
        if 对象:添加召唤( r ) then
            r.染色 = tonumber('0x03010101')
            self.数量 = self.数量 - 1
        end
    end
end

return 物品
