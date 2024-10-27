-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-09-07 15:15:15
-- @Last Modified time  : 2023-05-17 19:22:39
local NPC = {}
local 对话 = {
    [[我是帮派总管,帮中事务无论大小都经由我处理。
    menu
    我要领取帮派任务
    我是帮主,我要升级帮派
    我要更改帮派宗旨
    随便转转]],

    [[我是帮派总管,帮中事务无论大小都经由我处理。
    menu
    交付任务
    我要取消帮派任务
    我是帮主,我要升级帮派
    我要更改帮派宗旨
    随便转转]],

    [[我是帮派总管,帮中事务无论大小都经由我处理。
    menu
    我要取消帮派任务
    我是帮主,我要升级帮派
    我要更改帮派宗旨
    随便转转]],
}



--其它对话  神秘任务
function NPC:NPC对话(玩家, i)
    -- print(self.帮派,self.帮派.名称)
    local r = 玩家:取任务('日常_帮派任务')
    if r then
        if r.分类 == 1 or r.分类 == 3 or r.分类 == 4 or r.分类 == 5 or r.分类 == 9 then
            return 对话[2]
        else
            return 对话[3]
        end
    end
    return 对话[1]
end

function NPC:NPC菜单(玩家, i)
    if i == '我要领取帮派任务' then
        return self:领取帮派任务(玩家)
    elseif i == '我要取消帮派任务' then
        local r = 玩家:取任务('日常_帮派任务')
        if r then
            r:任务取消(玩家)
            r:删除(玩家)
        end
        玩家:提示窗口('#Y帮派任务已取消。')
    elseif i == '我是帮主,我要升级帮派' then
        local 职务 = self.帮派:取成员(玩家.nid).职务
        if 职务 ~= '帮主' then
            return '去去去,少来消遣我。'
        end
        if self.帮派:是否可升级() then
            self.帮派:帮派升级()
            self.帮派.地图 = nil
            玩家:提示窗口('#Y你的帮派升级到#G'..self.帮派.等级..'#Y级。')
        end
    elseif i == '交付任务' then
        local r = 玩家:取任务('日常_帮派任务')
        if r then
            if r.分类 == 1 then
                玩家:打开给予窗口(self.nid)
            elseif r.分类 == 3 then
                local w = 取召唤外形(r.位置)
                local z
                if w then
                    z = 玩家:寻找召唤兽(w)
                end
                if z then
                    local s = 玩家:删除召唤兽(z)
                    if s then
                        r:完成(玩家)
                    end
                else
                    return "我要的召唤兽呢"
                end
            elseif r.分类 == 4 then
                if r.指定NPC == '帮派总管' then
                    r:完成(玩家)
                else
                    return "你把订单整哪去了#78"
                end
            elseif r.分类 == 5 then
                if r.位置 == '帮派总管' then
                    r:完成(玩家)
                else
                    return "你把银票整哪去了#78"
                end
            elseif r.分类 == 9 then
                玩家:打开给予窗口(self.nid)
            end
        end
    elseif i == '临时测试' then
        self.帮派.守护 = {'大力战神','混乱战神'}
    end
end

local _最后对话 = {
    '帮中的药材已经不多了,你帮我找些#G%s#W来#46',
    '帮里很久没有清理杂草了,我给你一把锄头,你到帮里清理一下杂章#32',
    '帮里需要一批看门的召唤兽,你去给我抓一只#G%s#W来!',--做的不错这是你的奖励

    '最近帮里要订一批酒,你去长安,洛阳,傲来,长寿的酒店老板打听一下价格去,看看要不要订酒#23',--最近生意好差#8,酒价都降了几次了都卖不出去,如果你们帮要可以优惠些给你#56   给他订单    找错人了    你的订单我牧下了,马上给你们送过去#32
    '#G%s#W欠我们帮的银子还没有还,你去顺便要—下。',--这么痛快就把银票给了,看来不能过手瘾了#77
    '帮里的人员名单被叛徒放到锦盒里准备送给斧头帮,被#G无名侠女#W截获了,你去把锦盒拿回来#51',--既然你这个锦盒对你这么重要#23,那我会马上把锦盒送到你们帮里,你放心好了!

    '听说#G%s#W经常有骚扰路人的妖怪#54,你去把它们干掉#54',
    '听说今日有一武官#G%s#W时常欺压民众#78,你去找千里眼问问他所在何处,然后把他解决了吧',
    '近日帮中种植的一些灵植总是无缘无故的枯萎,据说#G%s#W可以改善灵植的生长环境,你去帮我找个来',

    '由于你长期对帮派做出贡献，意外的收到了一条神秘任务#89',


    '你身上有尚未完成的任务！'
}

function NPC:领取帮派任务(玩家)
    if 玩家:取任务('日常_帮派任务') then
        return _最后对话[11]
    end
    if 玩家.等级 < 30 then
        return '你的等级太低了,30级以后再来吧。'
    end
    if 玩家:取活动限制次数('帮派任务') >= 30 then
        return '你做的够多了,明天再来吧'
    end
    local 分类 = 0
    if 玩家.其它.帮派次数 <= 1 then
        分类 = math.random(3)
    elseif 玩家.其它.帮派次数 == 2 then
        if 玩家.等级 >= 70 or 玩家.转生 >= 1 then
            分类 = 8
        else
            分类 = math.random(3)
        end
    elseif 玩家.其它.帮派次数 >2 and 玩家.其它.帮派次数 < 6 then
        if 玩家.其它.帮派次数 == 4 and math.random(100) <= 25 and (玩家.等级 >= 70 or 玩家.转生 >= 1) and 玩家:取活动限制次数('帮派任务') <= 30 then
            分类 = math.random(10)
        else
            分类 = math.random(6)
        end
    elseif 玩家.其它.帮派次数 > 5 then
        if 玩家.其它.帮派次数 == 9 and math.random(100) <= 25 and (玩家.等级 >= 70 or 玩家.转生 >= 1) and 玩家:取活动限制次数('帮派任务') <= 30 then
            分类 = math.random(10)
        else
            分类 = math.random(4,9)
        end
    end
    -- 分类 = 9
    local r = 生成任务 { 名称 = '日常_帮派任务', 分类 = 分类 }
    if r then
        if r:添加任务(玩家) then
            玩家:增加活动限制次数('帮派任务')
            return string.format(_最后对话[分类], r.位置)
        end
    end
end

function NPC:NPC给予(玩家, cash, items)
    local r = 玩家:取任务('日常_帮派任务')
    if r then
        if r.分类 == 1 or r.分类 == 9 then
            if items[1] and items[1].名称 == r.位置 then
                r:完成(玩家)
                if items[1].数量 >= 1 then
                    items[1]:接受(1)
                end
                return '做的不错,这是你的奖励'
            end
        -- elseif r.分类 == 9 then
        --     if items[1] and items[1].名称 == r.位置 then
        --         r:完成(玩家)
        --         if items[1].数量 >= 1 then
        --             items[1]:接受(1)
        --         end
        --         return '做的不错,这是你的奖励'
        --     end
        end
    end
    return '你给我什么东西？'
end

return NPC