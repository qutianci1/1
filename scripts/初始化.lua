-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-07-03 07:16:50
-- @Last Modified time  : 2023-08-25 04:59:11

function 银两颜色(v)
    v = tostring(v)
    if #v < 5 then
        return '#W' .. 格式化货币(v)
    elseif #v < 6 then
        return '#c25da77' .. 格式化货币(v)
    elseif #v < 7 then
        return '#cfc45dc' .. 格式化货币(v)
    elseif #v < 8 then
        return '#cfbd833' .. 格式化货币(v)
    elseif #v < 9 then
        return '#c04fdf4' .. 格式化货币(v)
    elseif #v < 10 then
        return '#c0afd04' .. 格式化货币(v)
    else
        return '#cad1010' .. 格式化货币(v)
    end
end

function 格式化货币(n) -- credit http://richard.warburton.it
    local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. right
end

function 分割文本(text, delimiter)
  local splitIndex = string.find(text, delimiter) -- 查找分隔符的位置
  local result = {} -- 定义一个空的table
  if splitIndex then -- 如果找到了分隔符
    result[1] = string.sub(text, 1, splitIndex - 1) -- 将分隔符前面的部分保存到table中
    result[2] = string.sub(text, splitIndex + 1) -- 将分隔符后面的部分保存到table中
  else -- 如果没有找到分隔符
    result[1] = text -- 将整个文本保存到table中
  end
  return result -- 返回table
end

local 相克 = { 金 = '木', 木 = '土', 水 = '火', 火 = '金', 土 = '水' }

function 取五行属性(目标)
    local 五行={}
    for i, v in ipairs { '金', '木', '水', '火', '土' } do
        五行[v]=目标.抗性[v]/100
    end
    return 五行
end

function 取五行强克(目标)
    local 五行={}
    for i, v in ipairs { '强力克金', '强力克木', '强力克水', '强力克火', '强力克土' } do
        五行[v]=目标.抗性[v]/100+目标.增加强克效果/100
    end
    return 五行
end

function 取五行克制(攻击方五行,挨打方五行)
    local 攻击方结果=0
    local 挨打方结果=0
    if 攻击方五行.金~=nil and 攻击方五行.金~= 0 then
        if 挨打方五行.木~=nil and 挨打方五行.木~=0 then
            攻击方结果=攻击方结果+攻击方五行.金*挨打方五行.木
        end
        if 挨打方五行.火~=nil and 挨打方五行.火~=0 then
            挨打方结果=挨打方结果+挨打方五行.火*攻击方五行.金
        end
    end
    if 攻击方五行.木~=nil and 攻击方五行.木~= 0 then
        if 挨打方五行.土~=nil and 挨打方五行.土~=0 then
            攻击方结果=攻击方结果+攻击方五行.木*挨打方五行.土
        end
        if 挨打方五行.金~=nil and 挨打方五行.金~=0 then
            挨打方结果=挨打方结果+挨打方五行.金*攻击方五行.木
        end
    end
    if 攻击方五行.水~=nil and 攻击方五行.水~= 0 then
        if 挨打方五行.火~=nil and 挨打方五行.火~=0 then
            攻击方结果=攻击方结果+攻击方五行.水*挨打方五行.火
        end
        if 挨打方五行.土~=nil and 挨打方五行.土~=0 then
            挨打方结果=挨打方结果+挨打方五行.土*攻击方五行.水
        end
    end
    if 攻击方五行.火~=nil and 攻击方五行.火~= 0 then
        if 挨打方五行.金~=nil and 挨打方五行.金~=0 then
            攻击方结果=攻击方结果+攻击方五行.火*挨打方五行.金
        end
        if 挨打方五行.水~=nil and 挨打方五行.水~=0 then
            挨打方结果=挨打方结果+挨打方五行.水*攻击方五行.火
        end
    end
    if 攻击方五行.土~=nil and 攻击方五行.土~= 0 then
        if 挨打方五行.水~=nil and 挨打方五行.水~=0 then
            攻击方结果=攻击方结果+攻击方五行.土*挨打方五行.水
        end
        if 挨打方五行.木~=nil and 挨打方五行.木~=0 then
            挨打方结果=挨打方结果+挨打方五行.木*攻击方五行.土
        end
    end
    攻击方结果=攻击方结果-挨打方结果
    if 攻击方结果<0 then
        攻击方结果=0
    end
    return 攻击方结果
end

function 取强力克系数(攻击方强力克,挨打方五行)
    local 攻击方结果=1
    if 攻击方强力克.强力克金~=nil and 攻击方强力克.强力克金~= 0 then
      攻击方结果=攻击方结果+攻击方强力克.强力克金*挨打方五行.金
    end
    if 攻击方强力克.强力克木~=nil and 攻击方强力克.强力克木~= 0 then
      攻击方结果=攻击方结果+攻击方强力克.强力克木*挨打方五行.木
    end
    if 攻击方强力克.强力克水~=nil and 攻击方强力克.强力克水~= 0 then
      攻击方结果=攻击方结果+攻击方强力克.强力克水*挨打方五行.水
    end
    if 攻击方强力克.强力克火~=nil and 攻击方强力克.强力克火~= 0 then
      攻击方结果=攻击方结果+攻击方强力克.强力克火*挨打方五行.火
    end
    if 攻击方强力克.强力克土~=nil and 攻击方强力克.强力克土~= 0 then
      攻击方结果=攻击方结果+攻击方强力克.强力克土*挨打方五行.土
    end
    return 攻击方结果
end

function 取无属性伤害加成(攻击方,挨打方)
  local 加成=1
  if 攻击方.无属性伤害~=nil and 攻击方.无属性伤害>0 then
    if 挨打方.金 == 0 and 挨打方.木== 0 and 挨打方.水 == 0 and 挨打方.火 == 0 and 挨打方.土 == 0 then
      加成=加成+攻击方.无属性伤害/100-挨打方.抗无属性伤害/100
    end
  end
  return 加成
end




function 取五行克伤害系数(攻击方, 挨打方) --1是克2是被克
    local n = 0
    local 抗性1 = 攻击方.抗性
    local 抗性2 = 挨打方.抗性
    for i, v in ipairs { '金', '木', '水', '火', '土' } do
        if 抗性1[v] > 0 then
            n = n + (抗性1[v] / 100) * (抗性2[相克[v]] / 100)
        end
    end
    return n
end

local _强力克 = { 强力克金 = '金', 强力克木 = '木', 强力克水 = '水', 强力克火 = '火', 强力克土 = '土' }
function 取强克伤害系数(攻击方, 挨打方)
    local n = 0
    local 抗性1 = 攻击方.抗性
    local 抗性2 = 挨打方.抗性
    for i, v in ipairs { '强力克金', '强力克木', '强力克水', '强力克火', '强力克土' } do
        if 抗性1[v] > 0 then
            n = n + 抗性1[v] * (抗性2[_强力克[v]] / 100) * 0.01
        end
    end
    return n
end

function 取震慑强克系数(攻击方, 挨打方, 数额)
    local n = 数额
    local 抗性1 = 攻击方.抗性
    local 抗性2 = 挨打方.抗性
    for i, v in ipairs { '强力克金', '强力克木', '强力克水', '强力克火', '强力克土' } do
        if 抗性1[v] > 0 then
            n = n * (抗性1[v] / 100 * 抗性2[_强力克[v]] / 100)
        end
    end
    return n
end

function 强克伤害加成(攻击方, 挨打方, 伤害)
    local n = 0
    local 五行克 = 取五行克伤害系数(攻击方, 挨打方)
    local 五行被克 = 取五行克伤害系数(挨打方, 攻击方)
    local 强力克 = 取强克伤害系数(攻击方, 挨打方)
    local 五行加成 = (1 + 五行克 * 0.4 - 五行被克 * 0.4)
    强力克 = 强力克 + 攻击方.增加强克效果 * 0.01 - 挨打方.抵御强克效果 * 0.01
    if 强力克 < 0 then
        强力克 = 0
    end
    if 五行加成 < 1 then
        五行加成 = 1
    end
    n = 伤害 * (1 + 强力克) --//强力克
    n = n * 五行加成 --//五行克
    if 挨打方.金 == 0 and 挨打方.木 == 0 and 挨打方.水 == 0 and 挨打方.火 ==
        0 and 挨打方.土 == 0 then
        n = n * (1 + 攻击方.无属性伤害 * 0.01 - 挨打方.抗无属性伤害
            * 0.01)
    end
    if n < 1 then
        n = 1
    end

    return math.floor(n)
end

function 内丹系数调整(zhs_zscs, nd_zscs)
    if (zhs_zscs * nd_zscs == 1) then return 1.04;
    elseif (zhs_zscs * nd_zscs == 4) then return 1.071;
    elseif (zhs_zscs * nd_zscs == 6) then return 1.073;
    elseif (zhs_zscs * nd_zscs == 9) then return 1.09;
    else return 1;
    end
end

function 取开天辟地(攻击方)
    local ndjl = 0
    local r = 攻击方:取内丹("开天辟地")
    if r then
        ndjl =
        math.floor(
            (math.pow(攻击方.等级 * r.等级 * 0.04, 1 / 2) * (1 + 0.25 * r.转生) +
                (math.pow(攻击方.亲密, 1 / 6) * 内丹系数调整(攻击方.转生, r.转生) * r.等级) / 50) *
            1000
        ) * 0.000005;
        ndjl = math.ceil(ndjl * 10000) / 100
    end
    return ndjl
end

function 取种族抗性(种族,等级)
    local 抗性 = {}
    if 种族 == 1 then
        抗性.抗混乱 = 30 + 等级 * 0.5
        抗性.抗封印 = 30 + 等级 * 0.4
        抗性.抗昏睡 = 30 + 等级 * 0.3
        抗性.抗中毒 = 30 + 等级 * 0.2
    elseif 种族 == 2 then
        抗性.物理吸收 = 30 + 等级 * 0.2
        抗性.抗混乱 = 20 + 等级 * 0.4
        抗性.抗封印 = 15 + 等级 * 0.3
        抗性.抗昏睡 = 15 + 等级 * 0.2
        抗性.抗中毒 = 15 + 等级 * 0.15
        抗性.抗风 = 5 + 等级 * 0.2
        抗性.抗火 = 5 + 等级 * 0.2
        抗性.抗水 = 5 + 等级 * 0.2
        抗性.抗雷 = 5 + 等级 * 0.2
        抗性.致命几率 = 5 + 等级 * 0.2
        抗性.狂暴几率 = 5 + 等级 * 0.2
    elseif 种族 == 3 then
        抗性.抗混乱 = 10 + 等级 * 0.35
        抗性.抗封印 = 10 + 等级 * 0.2
        抗性.抗昏睡 = 10 + 等级 * 0.1
        抗性.抗风 = 10 + 等级 * 0.35
        抗性.抗火 = 10 + 等级 * 0.35
        抗性.抗水 = 10 + 等级 * 0.35
        抗性.抗雷 = 10 + 等级 * 0.35
    elseif 种族 == 4 then
        抗性.躲闪率 = 5 + 等级 * 0.25
        抗性.抗混乱 = 30 + 等级 * 0.45
        抗性.抗封印 = 20 + 等级 * 0.3
        抗性.抗昏睡 = 20 + 等级 * 0.2
        抗性.抗遗忘 = 35 + 等级 * 0.45
        抗性.抗鬼火 = 10 + 等级 * 0.35
        抗性.抗三尸虫 = 等级 * 200
        抗性.抗风 =  - 等级 * 0.2
        抗性.抗火 =  - 等级 * 0.2
        抗性.抗水 =  - 等级 * 0.2
        抗性.抗雷 =  - 等级 * 0.2
        抗性.上善若水 = - 等级 * 150
    end
    return 抗性
end

function 生成怪物属性(数据,难度,特性,随机法术,随机外观)
    local 属性=数据
    local 属性范围={"根骨","灵性","力量","敏捷"}
    local 四维={}
    for n=1,4 do
        if 数据.等级 >= 10 then
            四维[属性范围[n]]=数据.等级 + math.random(10,数据.等级)
        else
            四维[属性范围[n]]=数据.等级 + math.random(1,10)
        end
    end
    local 成长 = 1.275
    if 数据.成长 then
        成长 = 数据.成长
    end
    属性.气血=math.floor(数据.血初值+(数据.血初值*数据.等级*0.7+四维.根骨*数据.等级)*成长)
    属性.魔法=math.floor(数据.法初值+(数据.法初值*数据.等级*0.7+四维.灵性*数据.等级)*成长)
    属性.攻击=math.floor(数据.攻初值+(数据.攻初值*0.7+四维.力量)*成长*数据.等级/5)
    属性.速度=math.floor((数据.敏初值+四维.敏捷)*成长)
    if not 属性.抗性 then
        属性.抗性={}
    end
    local 五行=取默认五行(数据.外形)
    for k,v in pairs(五行) do
        属性.抗性[k]=v
    end
    if 难度=="简单" then
        属性.抗性.物理吸收=10
        属性.抗性.抗混乱=10
        属性.抗性.抗风=5
        属性.抗性.抗水=5
        属性.抗性.抗雷=5
        属性.抗性.抗火=5
        属性.抗性.抗鬼火=5
        --物理通用属性
        属性.抗性.连击率 = 10
        属性.抗性.连击次数 = 3
        属性.抗性.狂暴几率 = 5
        属性.抗性.致命几率 = 5
        属性.抗性.抗致命几率 = 0
        属性.抗性.忽视防御几率 = 0
        属性.抗性.忽视防御程度 = 0
        属性.抗性.反击率 = 5
        属性.抗性.反击次数 = 1
    elseif 难度=="中等" then
        属性.抗性.物理吸收=30
        属性.抗性.抗混乱=50
        属性.抗性.抗封印=25
        属性.抗性.抗遗忘=25
        属性.抗性.抗昏睡=20
        属性.抗性.抗风=10
        属性.抗性.抗水=10
        属性.抗性.抗雷=10
        属性.抗性.抗火=10
        属性.抗性.抗鬼火=10
        --物理通用属性
        属性.抗性.连击率 = 15
        属性.抗性.连击次数 = 3
        属性.抗性.狂暴几率 = 10
        属性.抗性.致命几率 = 10
        属性.抗性.抗致命几率 = 10
        属性.抗性.忽视防御几率 = 10
        属性.抗性.忽视防御程度 = 30
        属性.抗性.反击率 = 10
        属性.抗性.反击次数 = 1
    elseif 难度=="困难" then
        属性.抗性.物理吸收=50
        属性.抗性.抗混乱=80
        属性.抗性.抗封印=40
        属性.抗性.抗遗忘=40
        属性.抗性.抗昏睡=20
        属性.抗性.抗风=15
        属性.抗性.抗水=15
        属性.抗性.抗雷=15
        属性.抗性.抗火=15
        属性.抗性.抗鬼火=15
        属性.抗性.躲闪率=15
        属性.抗性.抗震慑 = 15
        --物理通用属性
        属性.抗性.连击率 = 20
        属性.抗性.连击次数 = 3
        属性.抗性.狂暴几率 = 15
        属性.抗性.致命几率 = 15
        属性.抗性.抗致命几率 = math.random(15, 30)
        属性.抗性.忽视防御几率 = 15
        属性.抗性.忽视防御程度 = 30
        属性.抗性.反击率 = 15
        属性.抗性.反击次数 = 2
    elseif 难度=="地狱" then
        属性.抗性.物理吸收=90
        属性.抗性.抗混乱=110
        属性.抗性.抗封印=90
        属性.抗性.抗遗忘=60
        属性.抗性.抗昏睡=60
        属性.抗性.抗风=35
        属性.抗性.抗水=35
        属性.抗性.抗雷=35
        属性.抗性.抗火=35
        属性.抗性.抗鬼火=35
        属性.抗性.躲闪率=35
        属性.抗性.抗震慑 = 25
        --物理通用属性
        属性.抗性.连击率 = 25
        属性.抗性.连击次数 = 5
        属性.抗性.狂暴几率 = 20
        属性.抗性.致命几率 = 20
        属性.抗性.抗致命几率 = math.random(20, 40)
        属性.抗性.忽视防御几率 = 20
        属性.抗性.忽视防御程度 = 40
        属性.抗性.反击率 = 25
        属性.抗性.反击次数 = 3
    elseif 难度=="炼狱" then
        属性.抗性.物理吸收=110
        属性.抗性.抗混乱=130
        属性.抗性.抗封印=110
        属性.抗性.抗遗忘=90
        属性.抗性.抗昏睡=90
        属性.抗性.抗风=50
        属性.抗性.抗水=50
        属性.抗性.抗雷=50
        属性.抗性.抗火=50
        属性.抗性.抗鬼火=50
        属性.抗性.躲闪率=50
        属性.抗性.抗震慑 = 40
        --物理通用属性
        属性.抗性.连击率 = 30
        属性.抗性.连击次数 = 5
        属性.抗性.狂暴几率 = 25
        属性.抗性.致命几率 = 25
        属性.抗性.抗致命几率 = math.random(30, 60)
        属性.抗性.忽视防御几率 = 30
        属性.抗性.忽视防御程度 = 50
        属性.抗性.反击率 = 35
        属性.抗性.反击次数 = 5
    end
    if 特性=="铁抗" then
        属性.抗性.物理吸收=200
    elseif 特性=="火免疫" then
        属性.抗性.抗火=200
    elseif 特性=="风免疫" then
        属性.抗性.抗风=200
    elseif 特性=="水免疫" then
        属性.抗性.抗水=200
    elseif 特性=="雷免疫" then
        属性.抗性.抗雷=200
    elseif 特性=="鬼火免疫" then
        属性.抗性.抗鬼火=200
    elseif 特性=="反震" then
        属性.抗性.反震率=100
        属性.抗性.反震程度=50
    end
    local 列表={}
    if 随机法术=='低级法术' or 随机法术=='中级法术' or 随机法术=='高级法术' or 随机法术=='特级法术' then
        属性.技能={}
        local 熟练 = 0
        if 随机法术=='低级法术' then
            列表=取随机低级法术() 熟练 = 5000
        elseif 随机法术=='中级法术' then
            列表=取随机中级法术() 熟练 = 10000
        elseif 随机法术=='高级法术' then
            列表=取随机高级法术() 熟练 = 15000
        elseif 随机法术=='特级法术' then
            列表=取随机特级法术() 熟练 = 20000
        end
        for i=1,3 do
            属性.技能[i]={ 名称 = 列表[math.random(1,#列表)] , 熟练度 = 熟练}
        end
    end
    return 属性
end

function 取随机低级法术()
    local 人族 = {'瞌睡咒', '离魂咒','情真意切', '谗言相加','追魂迷香', '断肠烈散'}
    local 魔族 = {'力神复苏', '狮王之怒','追神摄魄', '魔音摄心','莲步轻舞', '楚楚可怜','急速之魔', '魔神飞舞'}
    local 仙族 = {'日照光华', '雷神怒击','龙腾水溅', '龙啸九天','乘风破浪', '太乙生风','天雷怒火', '三味真火'}
    local 种族 = {人族,魔族,仙族}
    return 种族[math.random(1, #种族)]
end

function 取随机中级法术()
    local 人族 = {'离魂咒','谗言相加','断肠烈散'}
    local 魔族 = {'狮王之怒','魔音摄心','楚楚可怜', '魔神飞舞'}
    local 仙族 = {'雷神怒击','龙啸九天','太乙生风','三味真火'}
    local 种族 = {人族,魔族,仙族}
    return 种族[math.random(1, #种族)]
end

function 取随机高级法术()
    local 人族 = {'离魂咒', '迷魂醉','谗言相加', '借刀杀人','天罗地网', '作壁上观','断肠烈散', '鹤顶红粉'}
    local 魔族 = {'狮王之怒', '兽王神力','魔音摄心', '销魂蚀骨','楚楚可怜', '魔神护体','魔神飞舞', '天外飞魔'}
    local 仙族 = {'雷神怒击', '电闪雷鸣','龙啸九天', '蛟龙出海','太乙生风', '风雷涌动','三味真火', '烈火骄阳'}
    local 种族 = {人族,魔族,仙族}
    return 种族[math.random(1, #种族)]
end

function 取随机特级法术()
    local 人族 = {'百日眠', '失心狂乱', '四面楚歌', '万毒攻心'}
    local 魔族 = {'魔神附身', '阎罗追命', '含情脉脉', '乾坤借速'}
    local 仙族 = {'天诛地灭', '九龙冰封', '袖里乾坤', '九阴纯火'}
    local 种族 = {人族,魔族,仙族}
    return 种族[math.random(1, #种族)]
end

function 获取当日剩余时间()
    local currentDate = os.date("*t")
    currentDate.hour = 23
    currentDate.min = 59
    currentDate.sec = 55
    local endTimeStamp = os.time(currentDate)
    local currentTimeStamp = os.time()
    local secondsRemaining = endTimeStamp - currentTimeStamp
    return secondsRemaining
end

function 取任务链随机装备()
    local 装备表 = {"长刀", "短斧", "朝天棍", "纸扇", "松木拂尘","长剑", "九节鞭", "长枪", "五色缎带", "双钩刀","铁拳套", "铁爪", "木环", "大锤", "布裙","簪子", "布衣", "布帽", "布鞋", "佛珠"}
    return 装备表[math.random(1, #装备表)]
end

function 获取剩余时间(seconds)
  local hours = math.floor(seconds / 3600)
  local minutes = math.floor((seconds % 3600) / 60)
  local seconds = seconds % 60

  return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end