-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-08-06 16:13:54
-- @Last Modified time  : 2023-05-21 20:04:09
local 任务 = {
    名称 = '引导_升级检测',
    是否隐藏 = true
}

function 任务:任务初始化(玩家, ...)
    self.一称 = { 飞贼 = 0, 食婴鬼 = 0, 手下 = 0, 小孩 = 0 }
end

function 任务:任务上线(玩家)
    --self:删除()
end

function 任务:任务升级事件(玩家)
    local 转生 = 玩家.转生
    local 等级 = 玩家.等级
    if 转生 == 0 then
        if 等级 == 10 then
            self:触发10级引导(玩家)
        elseif 等级 == 30 then
            self:触发30级引导(玩家)
        elseif 等级 == 50 then
            self:触发50级引导(玩家)
        elseif 等级 == 60 then
            self:触发60级引导(玩家)
        elseif 等级 == 70 then
            self:触发70级引导(玩家)
        elseif 等级 == 80 then
            self:触发80级引导(玩家)
        elseif 等级 == 90 then
            self:触发90级引导(玩家)
        elseif 等级 == 102 then
            self:触发102级引导(玩家)
        end
    elseif 转生 == 1 then
        if 等级 == 80 then
            self:触发1转80级引导(玩家)
        elseif 等级 == 110 then
            self:触发1转110级引导(玩家)
        elseif 等级 == 120 then
            self:触发1转120级引导(玩家)
        elseif 等级 == 122 then
            local r = 生成任务 { 名称 = '转生任务1', 进度 = 1 }
            玩家:添加任务(r)


        end
    elseif 转生 == 2 then
        if 等级 == 100 then
            self:触发2转100级引导(玩家)
        elseif 等级 == 142 then
            local r = 生成任务 { 名称 = '转生任务3', 进度 = 1 }
            -- print(r)
            玩家:添加任务(r)



        end
    end
end

function 任务:触发2转100级引导(玩家)
    -- local r = 生成任务 {名称 = '引导_六坐领取', 进度 = 0}
    -- 玩家:添加任务(r)
end

function 任务:触发1转120级引导(玩家)
    -- local r = 生成任务 {名称 = '引导_五坐领取', 进度 = 0}
    -- 玩家:添加任务(r)
end

function 任务:触发1转110级引导(玩家)
    -- local r = 生成任务 {名称 = '引导_四坐领取', 进度 = 0}
    -- 玩家:添加任务(r)
    r = 生成任务 { 名称 = '引导_修罗任务', 进度 = 0 }
    玩家:添加任务(r)
end

function 任务:触发1转80级引导(玩家)
    -- local r = 生成任务 {名称 = '引导_三坐领取', 进度 = 0}
    -- 玩家:添加任务(r)
end

function 任务:触发102级引导(玩家)
    -- local r = 生成任务 {名称 = '引导_转世轮回', 进度 = 0}
    -- 玩家:添加任务(r)
    local r = 生成任务 { 名称 = '转生任务1', 进度 = 1 }
    玩家:添加任务(r)








end

function 任务:触发90级引导(玩家)
    local r = 生成任务 { 名称 = '引导_鬼王任务', 进度 = 0 }
    玩家:添加任务(r)
    -- r = 生成任务 {名称 = '引导_二坐领取', 进度 = 0}
    -- 玩家:添加任务(r)
end

function 任务:触发80级引导(玩家)
    -- local r = 生成任务 {名称 = '引导_大雁塔降魔', 进度 = 0}
    -- 玩家:添加任务(r)
    -- r = 生成任务 {名称 = '引导_地宫降魔', 进度 = 0}
    -- 玩家:添加任务(r)
end

function 任务:触发70级引导(玩家)
    local r = 生成任务 { 名称 = '引导_天庭任务', 进度 = 0 }
    玩家:添加任务(r)
end

function 任务:触发60级引导(玩家)
    -- local r = 生成任务 {名称 = '引导_200环', 进度 = 0}
    -- 玩家:添加任务(r)
    local r = 生成任务 {名称 = '【坐骑一】信字当头', 进度 = 0}
    玩家:添加任务(r)
end

function 任务:触发50级引导(玩家)
    local r = 生成任务 { 名称 = '引导_大理寺答题', 进度 = 0 }
    玩家:添加任务(r)
end

function 任务:触发30级引导(玩家)
    local r = 生成任务 { 名称 = '引导_情花任务', 进度 = 0 }
    玩家:添加任务(r)
    -- r = 生成任务 { 名称 = '引导_师门任务', 进度 = 0 }
    -- 玩家:添加任务(r)
end

function 任务:触发10级引导(玩家)
    local r = 生成任务 {名称 = '称谓1_教训食婴鬼', 进度 = 0, 对话进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '称谓1_教训飞贼', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '称谓1_教训食婴鬼手下', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '称谓1_失踪的小孩', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '200环1', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '城东保卫战1', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '地煞星1', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '夺镖任务1', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '高级地煞星1', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '花灯报吉1', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '金玉满堂1', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '梨园庙会1', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '年年有余1', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '大雁塔1', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '地宫1', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '五环1', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '万仙方阵1', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '水陆大会1', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '帮战1', 进度 = 0}
    玩家:添加任务(r)
    r = 生成任务 {名称 = '花灯报吉2', 进度 = 0}
    玩家:添加任务(r)

end

function 任务:一称完成检测(玩家, k)
    if not self.一称 then
        self.一称 = { 飞贼 = 0, 食婴鬼 = 0, 手下 = 0, 小孩 = 0 }
    end
    self.一称[k] = 1
    for _, v in pairs(self.一称) do
        if v == 0 then
            return false
        end
    end
    local r = 生成任务 { 名称 = '领取称谓', 进度 = 0, cw = 1 }
    玩家:添加任务(r)
    self.一称 = nil
end

function 任务:二称完成检测(玩家, k)
    if not self.二称 then
        self.二称 = { 心经 = 0, 定魂珠 = 0, 水陆 = 0 }
    end
    self.二称[k] = 1
    for _, v in pairs(self.二称) do
        if v == 0 then
            return false
        end
    end
    local r = 生成任务 { 名称 = '领取称谓', 进度 = 0, cw = 2 }
    玩家:添加任务(r)
    self.二称 = nil
end

function 任务:三称完成检测(玩家, k)
    if not self.三称 then
        self.三称 = { 春三十娘 = 0, 山贼 = 0, 仙露 = 0, 夜光珠 = 0 }
    end
    self.三称[k] = 1
    for _, v in pairs(self.三称) do
        if v == 0 then
            return false
        end
    end
    local r = 生成任务 { 名称 = '领取称谓', 进度 = 0, cw = 3 }
    玩家:添加任务(r)
    self.三称 = nil
end

function 任务:四称完成检测(玩家, k)
    if not self.四称 then
        self.四称 = { 天兵 = 0, 琉璃 = 0, 八戒 = 0, 摄魂鬼 = 0 }
    end
    self.四称[k] = 1
    for _, v in pairs(self.四称) do
        if v == 0 then
            return false
        end
    end
    local r = 生成任务 { 名称 = '领取称谓', 进度 = 0, cw = 4 }
    玩家:添加任务(r)
    self.四称 = nil
end

function 任务:五称完成检测(玩家, k)
    if not self.五称 then
        self.五称 = { 玉酒 = 0, 紫霞 = 0, 名菜 = 0 }
    end
    self.五称[k] = 1
    for _, v in pairs(self.五称) do
        if v == 0 then
            return false
        end
    end
    local r = 生成任务 { 名称 = '领取称谓', 进度 = 0, cw = 5 }
    玩家:添加任务(r)
    self.五称 = nil
end

function 任务:六称完成检测(玩家, k)
    if not self.六称 then
        self.六称 = { 思情 = 0, 老君 = 0, 妖尸 = 0, 孽缘 = 0 }
    end
    self.六称[k] = 1
    for _, v in pairs(self.六称) do
        if v == 0 then
            return false
        end
    end
    local r = 生成任务 { 名称 = '领取称谓', 进度 = 0, cw = 6 }
    玩家:添加任务(r)
    self.六称 = nil
end

function 任务:七称完成检测(玩家, k)
    if not self.七称 then
        self.七称 = { 神鞭 = 0, 唐僧 = 0 }
    end
    self.七称[k] = 1
    for _, v in pairs(self.七称) do
        if v == 0 then
            return false
        end
    end
    local r = 生成任务 { 名称 = '领取称谓', 进度 = 0, cw = 7 }
    玩家:添加任务(r)
    self.七称 = nil
end

function 任务:八称完成检测(玩家, k)
    if not self.八称 then
        self.八称 = { 金箍 = 0, 妙法 = 0 }
    end
    self.八称[k] = 1
    for _, v in pairs(self.八称) do
        if v == 0 then
            return false
        end
    end
    local r = 生成任务 { 名称 = '领取称谓', 进度 = 0, cw = 8 }
    玩家:添加任务(r)
    self.八称 = nil
end

function 任务:九称完成检测(玩家, k)
    if not self.九称 then
        self.九称 = { 悟空 = 0, 白虎 = 0, 山妖 = 0 }
    end
    self.九称[k] = 1
    for _, v in pairs(self.九称) do
        if v == 0 then
            return false
        end
    end
    local r = 生成任务 { 名称 = '领取称谓', 进度 = 0, cw = 9 }
    玩家:添加任务(r)
    self.九称 = nil
end

function 任务:十称完成检测(玩家, k)
    local r = 生成任务 { 名称 = '领取称谓', 进度 = 0, cw = 10 }
    玩家:添加任务(r)
end

function 任务:任务更新(玩家, sec)
end

function 任务:十一称完成检测(玩家, k)
    if not self.十一称 then
        self.十一称 = { 武士 = 0, 紫霞 = 0, 宝物 = 0 }
    end
    self.十一称[k] = 1
    for _, v in pairs(self.十一称) do
        if v == 0 then
            return false
        end
    end
    local r = 生成任务 { 名称 = '领取称谓', 进度 = 0, cw = 11 }
    玩家:添加任务(r)
    self.十一称 = nil
end

function 任务:十二称完成检测(玩家, k)
    if not self.十二称 then
        self.十二称 = { 身世 = 0, 老妇 = 0, 度亡经 = 0 }
    end
    self.十二称[k] = 1
    for _, v in pairs(self.十二称) do
        if v == 0 then
            return false
        end
    end
    local r = 生成任务 { 名称 = '领取称谓', 进度 = 0, cw = 12 }
    玩家:添加任务(r)
    self.十二称 = nil
end

function 任务:十三称完成检测(玩家, k)
    if not self.十三称 then
        self.十三称 = { 偷吃 = 0, 路上 = 0 }
    end
    self.十三称[k] = 1
    for _, v in pairs(self.十三称) do
        if v == 0 then
            return false
        end
    end
    local r = 生成任务 { 名称 = '领取称谓', 进度 = 0, cw = 13 }
    玩家:添加任务(r)
    self.十三称 = nil
end

function 任务:十四称完成检测(玩家, k)
    local r = 生成任务 { 名称 = '领取称谓', 进度 = 0, cw = 14 }
    玩家:添加任务(r)
end

function 任务:任务取详情(玩家)
    return '任务描述 #G' .. tostring((self.时间 - os.time()) / 60)
end

return 任务
