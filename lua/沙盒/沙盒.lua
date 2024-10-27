-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2022-06-10 13:01:27
-- @Last Modified time  : 2024-05-09 04:14:20
local GGF = require('GGE.函数')
local lfs = require('lfs')

local ENV = {
    print = print,
    pairs = pairs,
    ipairs = ipairs,
    next = next,
    tonumber = tonumber,
    tostring = tostring,
    type = type,
    assert = assert,
    os = os,
    table = table,
    math = math,
    string = string,
    utf8 = utf8
}

local function myload(file) --从文件加载
    local fun, err = loadfile(file)
    if fun then
        return fun() or true
    else
        print(err)
    end
end

local function envload(file) --从文件加载
    local fun, err = loadfile(file, 'bt', ENV)
    if fun then
        return fun() or true
    else
        print(err)
    end
end

local list = {}

__热更 = __世界:定时(
    1000,
    function(ms)
        for _, v in ipairs(list) do
            local time = lfs.attributes(v.file, 'modification')
            if v.time ~= time then
                v.time = time
                print('热更新', v.file)
                if v.fun then
                    v.fun(v.file)
                end
            end
        end
        return ms
    end
)

local function 添加监视(file, fun)
    local time = lfs.attributes(file, 'modification')
    table.insert(list, { file = file, time = time, fun = fun })
end

local function 添加脚本(file, tp)
    添加监视(
        file,
        function()
            if myload(file) then
                if tp == '角色' then
                    require('server'):绑定角色()
                elseif tp == '召唤' then
                    require('server'):绑定召唤()
                elseif tp == '坐骑' then
                    require('server'):绑定坐骑()
                elseif tp == '宠物' then
                    require('server'):绑定宠物()
                elseif tp == '法宝' then
                    require('server'):绑定法宝()
                end
            end
        end
    )
end

if gge.isdebug then
    添加脚本('lua/test.lua')
end
添加脚本('lua/沙盒/接口.lua')

添加脚本('lua/地图/地图.lua')
添加脚本('lua/地图/跳转.lua')
添加脚本('lua/地图/NPC.lua')



添加脚本('lua/对象/角色/摆摊.lua', '角色')
添加脚本('lua/对象/角色/帮派.lua', '角色')
添加脚本('lua/对象/角色/仓库.lua', '角色')
添加脚本('lua/对象/角色/称谓.lua', '角色')
添加脚本('lua/对象/角色/好友.lua', '角色')
添加脚本('lua/对象/角色/法宝.lua', '角色')
添加脚本('lua/对象/角色/宠物.lua', '角色')
添加脚本('lua/对象/角色/地图.lua', '角色')
添加脚本('lua/对象/角色/队伍.lua', '角色')
添加脚本('lua/对象/角色/管理.lua', '角色')
添加脚本('lua/对象/角色/技能.lua', '角色')
添加脚本('lua/对象/角色/交易.lua', '角色')
添加脚本('lua/对象/角色/角色.lua', '角色')
添加脚本('lua/对象/角色/接口.lua', '角色')
添加脚本('lua/对象/角色/界面.lua', '角色')
添加脚本('lua/对象/角色/任务.lua', '角色')
添加脚本('lua/对象/角色/商城.lua', '角色')
添加脚本('lua/对象/角色/属性.lua', '角色')
添加脚本('lua/对象/角色/数据.lua', '角色')
添加脚本('lua/对象/角色/算法.lua', '角色')
添加脚本('lua/对象/角色/通信.lua', '角色')
添加脚本('lua/对象/角色/物品.lua', '角色')
添加脚本('lua/对象/角色/战斗.lua', '角色')
添加脚本('lua/对象/角色/召唤.lua', '角色')
添加脚本('lua/对象/角色/坐骑.lua', '角色')
添加脚本('lua/对象/角色/作坊.lua', '角色')
添加脚本('lua/对象/角色/自动任务.lua', '角色')

添加脚本('lua/对象/物品/接口.lua', '物品')
添加脚本('lua/对象/物品/提交.lua', '物品')
添加脚本('lua/对象/物品/物品.lua', '物品')
添加脚本('lua/对象/物品/装备.lua', '物品')

添加脚本('lua/对象/召唤/接口.lua', '召唤')
添加脚本('lua/对象/召唤/算法.lua', '召唤')
添加脚本('lua/对象/召唤/通信.lua', '召唤')
添加脚本('lua/对象/召唤/战斗.lua', '召唤')
添加脚本('lua/对象/召唤/召唤.lua', '召唤')

添加脚本('lua/对象/坐骑/坐骑.lua', '坐骑')
添加脚本('lua/对象/坐骑/接口.lua', '坐骑')

添加脚本('lua/对象/法宝/法宝.lua', '法宝')
添加脚本('lua/对象/法宝/接口.lua', '法宝')

添加脚本('lua/对象/帮派/帮派.lua', '帮派')
--添加脚本('lua/对象/帮派/接口.lua', '帮派')

添加脚本('lua/对象/法术/战斗.lua', '技能')
添加脚本('lua/对象/法术/技能.lua', '技能')
添加脚本('lua/对象/法术/内丹.lua', '技能')
-- 添加脚本('lua/对象/法术/召唤.lua', '技能')
添加脚本('lua/对象/任务/任务.lua', '任务')
添加脚本('lua/对象/任务/接口.lua', '任务')
添加脚本('lua/对象/宠物.lua', '宠物')

添加脚本('lua/战斗/战场.lua', '战斗')
添加脚本('lua/战斗/回合数据.lua', '战斗')
添加脚本('lua/战斗/对象/对象.lua', '战斗')
添加脚本('lua/战斗/对象/事件.lua', '战斗')
添加脚本('lua/战斗/对象/怪物.lua', '战斗')
添加脚本('lua/战斗/对象/法术.lua', '战斗')
添加脚本('lua/战斗/对象/物品.lua', '战斗')
添加脚本('lua/战斗/对象/BUFF.lua', '战斗')



--=============================================================================
--=============================================================================
--=============================================================================
--=============================================================================

__召唤库 = require('数据库/召唤库')
if GGF.判断文件('scripts/初始化.lua') then
    envload('scripts/初始化.lua')
    添加监视('scripts/初始化.lua', envload)
end

if GGF.判断文件('scripts/奖励池.lua') then
    envload('scripts/奖励池.lua')
    添加监视('scripts/奖励池.lua', envload)
end

if GGF.判断文件('scripts/随机名称.lua') then
    envload('scripts/随机名称.lua')
    添加监视('scripts/随机名称.lua', envload)
end

do --npc
    local function loadnpc(file)
        local r = envload(file)
        if type(r) == 'table' then
            --r.脚本 = file
            __脚本[file] = r
        end
    end

    local function load_npcs()
        local npc = envload('data/npc.lua')
        for i, v in ipairs(npc) do
            local file = v.脚本:gsub('\\', '/')

            if GGF.判断文件(file) then
                loadnpc(file)
                添加监视(file, loadnpc)
            else
                warn('NPC脚本不存在', file)
            end
        end
        for _, v in pairs(__地图) do
            v:加载NPC(npc)
        end
    end

    load_npcs()
    添加监视('data/npc.lua', load_npcs)

    for file, rel in GGF.遍历目录('scripts/task/npc') do
        file = file:gsub('\\', '/')
        loadnpc(file)
        添加监视(file, loadnpc)
    end
    for file, rel in GGF.遍历目录('scripts/event/npc') do
        file = file:gsub('\\', '/')
        loadnpc(file)
        添加监视(file, loadnpc)
    end
    for file, rel in GGF.遍历目录('scripts/npc') do
        file = file:gsub('\\', '/')
        if not __脚本[file] then
            --print('未知脚本', file)
            loadnpc(file)
            添加监视(file, loadnpc)
        end
    end
end

do --jump跳转
    local function load_jumps()
        local jump = envload('data/jump.lua')
        for _, v in pairs(__地图) do
            v:加载跳转(jump)
        end
    end

    load_jumps()
    添加监视('data/jump.lua', load_jumps)
end

do --item物品
    local 基本信息 = require('数据库/角色').基本信息
    local _装备库 = require('数据库/装备库')
    for _, v in pairs(_装备库) do
        if type(v.角色) == 'string' then
            local 角色 = GGF.分割文本(v.角色, '|')
            v.角色 = {}
            for _, mc in ipairs(角色) do
                if 基本信息[mc] then
                    v.角色[基本信息[mc].外形] = true
                else
                    warn('装备角色不存在：', v.名称, '|', mc)
                end
            end
        end
    end

    __物品库 = require('数据库/物品库')

    local function loadchange()
        local 变身卡 = require('数据库/变身卡')
        for _ , v in pairs(变身卡) do
            local mr = envload('scripts/变身卡.lua')
            local t = __物品库[v.name]
            mr.名称 = v.name
            mr.id = v.id
            mr.是否药物 = false
            mr.是否装备 = false
            mr.人物是否可用 = true
            mr.召唤是否可用 = false
            mr.孩子是否可用 = false
            mr.战斗是否可用 = false
            mr.非战斗是否可用 = true
            mr.非死亡是否可用 = false
            mr.死亡是否可用 = false
            mr.隐身是否可用 = false
            mr.非隐身是否可用 = false
            t.脚本 = 'scripts/'..v.name..'.lua'
            __脚本[t.脚本] = mr
        end
    end
    loadchange() --添加变身卡虚拟脚本信息
    添加监视('scripts/变身卡.lua', loadchange)

    --local 物品类别 = {'药物', '装备'}
    local function loaditem(file)
        local r = envload(file)
        if type(r) == 'table' and r.名称 then
            r.是否药物 = r.类别 == 1
            r.是否装备 = r.类别 == 2
            if type(r.对象) == 'number' then
                r.人物是否可用 = r.对象 & 1 ~= 0
                r.召唤是否可用 = r.对象 & 2 ~= 0
                if r.对象 & 4 ~= 0 then
                    r.孩子是否可用 = true
                end
            end
            if type(r.条件) == 'number' then
                r.战斗是否可用 = r.条件 & 1 == 1
                r.非战斗是否可用 = r.条件 & 3 == 3
                r.非死亡是否可用 = r.条件 & 4 == 4
                r.死亡是否可用 = r.条件 & 8 == 8
                r.隐身是否可用 = r.条件 & 16 == 16
                r.非隐身是否可用 = r.条件 & 32 == 32
            end
            if r.是否药物 then
                if not r.排序 then
                    warn('药物必须要有排序值')
                end
                if r.类型 & 1 == 1 then
                    r.取恢复气血值 = function(_, P)
                        if math.tointeger(r.排序) then
                            return r.排序
                        else
                            return math.floor(r.排序 * P.最大气血)
                        end
                    end
                end
                if r.类型 & 2 == 2 then
                    r.取恢复魔法值 = function(_, P)
                        if math.tointeger(r.排序) then
                            return r.排序
                        else
                            return math.floor(r.排序 * P.最大气血)
                        end
                    end
                end
            end
            local t = __物品库[r.名称]
            if t then
                t.脚本 = file --物品库
                r.id = t.id --脚本
            else
                __物品库[r.名称] = { 脚本 = file }
                warn('物品库不存在:', file)
            end
            __脚本[file] = r
        else
            warn('脚本错误', file)
        end
    end

    for file, rel in GGF.遍历目录('scripts/item') do
        file = file:gsub('\\', '/')
        loaditem(file)
        添加监视(file, loaditem)
    end
end

do --task任务
    local function loadtask(file)
        local r = envload(file)
        if type(r) == 'table' and r.名称 then
            r.脚本 = file
            __任务[r.名称] = r
            __脚本[file] = r
            return true
        end
    end

    for file, rel in GGF.遍历目录('scripts/task') do
        file = file:gsub('\\', '/')
        if loadtask(file) then
            添加监视(file, loadtask)
        end
    end
end

do --event事件
    local function loadevent(file)
        local r = envload(file)
        if type(r) == 'table' and r.名称 then
            r.脚本 = file
            if __脚本[file] then
                __脚本[file]:删除定时()
            end
            __事件[r.名称] = r
            __脚本[file] = r
            setmetatable(r, { __index = require('事件') })
            if type(r.事件初始化) == 'function' then
                ggexpcall(r.事件初始化, r)
            end
            return true
        end
    end

    for file, rel in GGF.遍历目录('scripts/event') do
        file = file:gsub('\\', '/')
        if loadevent(file) then
            添加监视(file, loadevent)
        end
    end
end

do --war战斗
    local function loadwar(file)
        local r = envload(file)
        if type(r) == 'table' then
            r.脚本 = file
            __脚本[file] = r
            return true
        end
    end

    for file, rel in GGF.遍历目录('scripts/war') do
        file = file:gsub('\\', '/')
        if loadwar(file) then
            添加监视(file, loadwar)
        end
    end
end

do --skill技能
    local function loadskill(file)
        local r = envload(file)
        if type(r) == 'table' then
            r.脚本 = file
            r.是否被动 = r.类型 & 2 == 2
            r.是否主动 = r.类型 & 1 == 1
            r.战斗可用 = r.条件 & 1 == 1
            r.存活可用 = r.条件 & 4 == 4
            r.敌方可用 = r.对象 & 2 == 2
            r.己方可用 = r.对象 & 1 == 1
            file = string.format("scripts/skill/%s/%s.lua", r.类别, r.名称)
            __脚本[file] = r
            return true
        end
    end

    for file, rel in GGF.遍历目录('scripts/skill') do
        file = file:gsub('\\', '/')
        if loadskill(file) then
            添加监视(file, loadskill)
        end
    end
end

do --shop商店
    local function loadshop(file)
        local r = envload(file)
        if type(r) == 'table' then
            r.脚本 = file
            __脚本[file] = r
            return true
        end
    end

    for file, rel in GGF.遍历目录('scripts/shop') do
        file = file:gsub('\\', '/')
        if loadshop(file) then
            添加监视(file, loadshop)
        end
    end
end

do --map
    local function loadmap(file)
        local r = envload(file)
        if type(r) == 'table' then
            --r.脚本 = file
            __脚本[file] = r
        end
    end
    
    for file, rel in GGF.遍历目录('scripts/map') do
        file = file:gsub('\\', '/')
        if loadmap(file) then
            添加监视(file, loadmap)
        end
    end
end





-- do --dan内丹
--     local function loaddan(file)
--         local r = envload(file)
--         if type(r) == 'table' then
--             r.脚本 = file
--             __脚本[file] = r
--             return true
--         end
--     end

--     for file, rel in GGF.遍历目录('scripts/dan') do
--         file = file:gsub('\\', '/')
--         if loaddan(file) then
--             添加监视(file, loaddan)
--         end
--     end
-- end
-- local function loadall(file)
--     local r = envload(file)
--     if type(r) == 'table' then
--         --r.脚本 = file
--         __脚本[file] = r
--     end
-- end
-- for file, rel in GGF.遍历目录('scripts') do
--     file = file:gsub('\\', '/')
--     if not __脚本[file] then
--         loadall(file)
--         添加监视(file, loadall)
--     end
-- end
-- print('初始化完成')

__世界:INFO('初始化完成')
return ENV
