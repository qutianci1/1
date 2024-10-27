-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-03-13 14:32:39
-- @Last Modified time  : 2024-05-10 15:37:25

local _ENV = package.loaded.我的函数 or setmetatable({}, {__index = _G})
local json = require("json")
table.print = function(t)
    print(require('lua.serpent').block(t))
end
function 容错表(t)
    if type(t) ~= 'table' then
        t = {}
    end
    return setmetatable(
        t,
        {
            __index = function(t, k)
                return 0
            end
        }
    )
end
-- 写出txt
function 写出管理日志(name, data)
    local str = json.encode(data)
    local file = io.open(name, "a")
    if file then
        file:write(str .. "\n")
        file:close()
    else
        print("无法打开文件！")
    end
end

--写出txt
function 写出txt(name,data)
    -- 将表数据转换为字符串
    local str = json.encode(data)
    -- 打开文件以进行写入
    local file = io.open(name, "w")
    if file then
        -- 写入数据
        file:write(str)
        -- 关闭文件
        file:close()
    else
        print("无法打开文件！")
    end
end
--读取txt
function 读取txt(name)
    local file = io.open(name, "r")
    if file then
        -- 读取文件内容
        local content = file:read("*all")
        -- 将字符串转换为表数据
        local data = json.decode(content)
        -- 关闭文件
        file:close()
        return data
    else
        print("无法打开文件！")
        return {}
    end
end

function line(t)
    return require('lua.serpent').line(t)
end

function block(t)
    return require('lua.serpent').block(t)
end

function pline(t)
    print(require('lua.serpent').line(t))
end

function pblock(t)
    print(require('lua.serpent').block(t))
end

function load(t)
    return require('lua.serpent').load(t)
end

do
    local 重复表 = {}
    local function _检查表(t)
        for k, v in pairs(t) do
            if type(k) ~= 'number' and type(k) ~= 'string' then
                return false
            end
            if type(v) == 'table' and not 重复表[v] then
                重复表[v] = true
                if getmetatable(v) then
                    return false
                end
                return _检查表(v)
            end
        end
        return true
    end

    function 检查表(t) --检查 是否普通表
        重复表 = {}
        return _检查表(t)
    end
end

function 取孩子技能几率(评价,亲密,孝心,技能)
    local 评价系数=评价 * ( 0.4 + 8 * 10^-4 * ( 亲密 + 孝心 )) * 0.01
    local 几率=0
    if 技能=="金刚护体" or 技能=="嗜血狂攻" then
        几率 = 评价系数
    elseif 技能=="猛毒术" or 技能=="飞龙在天" then
        几率 = 0.3 * 评价系数
    elseif 技能=="龙腾" or 技能=="清风徐来" or 技能=="激流暗涌" or 技能=="江枫渔火" or 技能=="紫电一闪" then
        几率 = 50000 * 评价系数
    elseif 技能=="玄冰甲" or 技能=="烈火甲" or 技能=="天雷甲" or 技能=="狂风甲" then
        几率 = 600 * 评价系数
    elseif 技能=="孙子兵法" or 技能=="千里冰封" or 技能=="肝肠寸断" or 技能=="先发制人" or 技能=="摄气诀" then
        几率 = 0.25 * 评价系数
    elseif 技能=="水系吸收" or 技能=="火系吸收" or 技能=="雷系吸收" or 技能=="风系吸收" then
        几率 = 450 * 评价系数
    elseif 技能=="定心咒" or 技能=="风卷残云" or 技能=="排江倒海" or 技能=="芳华绝代" or 技能=="雷霆万钧" then
        几率 = 50000 * 评价系数
    elseif 技能=="混乱术" or 技能=="封印术" or 技能=="昏睡术" or 技能=="震慑强化" or 技能=="清心咒" then
        几率 = 0.175 * 评价系数
    elseif 技能=="摇篮曲" then
        几率 = 0.4 * 评价系数
    elseif 技能=="破冰术" or 技能=="解毒术" then
        几率 = 0.2 * 评价系数
    elseif 技能=="龙神心法" or 技能=="破甲" or 技能=="铁布衫" or 技能=="丹青妙手" then
        几率 = 0.75 * 评价系数
    elseif 技能=="莲台心法" then
        几率 = 0.25 * 评价系数
    end
    -- 几率 = 100
    return 几率
end

function 取孩子随机天资()
    local 列表={"先发制人","清风徐来","激流暗涌","江枫渔火","紫电一闪","震慑强化","水系吸收","火系吸收","雷系吸收","风系吸收","破甲","混乱术","封印术","猛毒术","昏睡术","清心咒","破冰术","解毒术","定心咒","铁布衫","先发制人","清风徐来","激流暗涌","江枫渔火","紫电一闪","震慑强化","水系吸收","火系吸收","雷系吸收","风系吸收","破甲","混乱术","封印术","猛毒术","昏睡术","清心咒","破冰术","解毒术","定心咒","铁布衫","龙腾","风卷残云","排江倒海","芳华绝代","雷霆万钧","摄气诀","玄冰甲","烈火甲","天雷甲","狂风甲","嗜血狂攻","孙子兵法","千里冰封","肝肠寸断","摇篮曲","莲台心法",'飞龙在天',"丹青妙手","龙神心法","金刚护体"}
    return 列表[math.random(1,#列表)]
end

function 取孩子高级天资()
    local 列表={"龙腾","风卷残云","排江倒海","芳华绝代","雷霆万钧","摄气诀","玄冰甲","烈火甲","天雷甲","狂风甲","嗜血狂攻","孙子兵法","千里冰封","肝肠寸断","摇篮曲","莲台心法",'飞龙在天',"丹青妙手","龙神心法","金刚护体"}
    return 列表[math.random(1,#列表)]
end

function 取孩子装备性别限制(名称)
    local 女性={"粗布裙","麻裙","轻纱小裙","丝绸长裙","织女彩裙","银簪","玉钗","珍珠头钗","凤钗","织女花环","绣花鞋","云靴","织女彩鞋","木剑","竹剑","青铜剑","越女剑","龙泉剑"}
    local 男性={"粗布衣","麻衣","丝绸外衣","书生服","八卦道袍","布帽","方巾","纶巾","书生巾","天师法冠","马靴","书生履","天师履","翎毛扇","白羽扇","鹅毛扇","鹤毛扇","塵尾扇"}
    local 通用={"草鞋","布鞋","木筝","宝螺筝","楠木花奔筝","红木山水画筝","骨雕飞天筝","庄子","孟子","论语","道德经","周易"}
    for i=1,#女性 do
        if 名称==女性[i] then
            return "女"
        end
    end
    for i=1,#男性 do
        if 名称==男性[i] then
            return "男"
        end
    end
    for i=1,#通用 do
        if 名称==通用[i] then
            return "通用"
        end
    end
end

--装备部位,1=武器,2=帽子,3=衣服,4=鞋子
function 取孩子装备类型(名称)
    local 武器 = {"木剑","竹剑","青铜剑","越女剑","龙泉剑","翎毛扇","白羽扇","鹅毛扇","鹤毛扇","塵尾扇","木筝","宝螺筝","楠木花奔筝","红木山水画筝","骨雕飞天筝","庄子","孟子","论语","道德经","周易"}
    local 其他 = {"粗布裙","麻裙","轻纱小裙","丝绸长裙","织女彩裙","银簪","玉钗","珍珠头钗","凤钗","织女花环","绣花鞋","云靴","织女彩鞋","粗布衣","麻衣","丝绸外衣","书生服","八卦道袍","布帽","方巾","纶巾","书生巾","天师法冠","马靴","书生履","天师履","草鞋","布鞋"}
    for k,v in pairs(武器) do
        if 名称 == v then
            return '武器'
        end
    end
    for k,v in pairs(其他) do
        if 名称 == v then
            return '其他'
        end
    end
end

function rank( min,max,num,sum )
  local go={}
  for i=1,num do
    if i<num then
      local newmin=math.floor(sum*min)
      if newmin<10 and sum==100 then
        newmin=10
      end
      local newmax=math.floor(sum*max)
      if newmax<10 and sum==100 then
        newmax=10
      end
      go[i]=math.random(newmin,newmax)
      sum=sum-go[i]
    else
      go[i]=sum
    end
  end
  return go
end

function 取宠物蛋奖励()
    return _宠物蛋奖励
end

function 取地图在线奖励()
    return _地图在线奖励
end

return _ENV
