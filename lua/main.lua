-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2023-03-13 14:32:39
-- @Last Modified time  : 2024-08-12 15:13:03
-- 试试
if gge.isdebug and os.getenv('LOCAL_LUA_DEBUGGER_VSCODE') == '1' then
    package.loaded['lldebugger'] = assert(loadfile(os.getenv('LOCAL_LUA_DEBUGGER_FILEPATH')))()
    require('lldebugger').start()
end

local GGF = require('GGE.函数')
MYF = require('我的函数')

local t = os.clock()
do
    __管理角色 = {'天赐','天赐1'}
    __体验码 = { "8888" }
    __配置 = require('数据库/配置')
    require('战斗/对象/对象')
    __NPC = setmetatable({}, { __mode = 'v' })
    __玩家 =
    setmetatable(
        {},
        {
            __mode = 'v',
            __index = setmetatable({}, { __mode = 'v' }) --名称索引
        }
    )
    --s
    __物品 = setmetatable({}, { __mode = 'v' })
    __召唤 = setmetatable({}, { __mode = 'v' })
    __宠物 = setmetatable({}, { __mode = 'v' })
    __坐骑 = setmetatable({}, { __mode = 'v' })
    __法宝 = setmetatable({}, { __mode = 'v' })
    __怪物 = setmetatable({}, { __mode = 'v' })
    __技能 = setmetatable({}, { __mode = 'v' })
    __内丹 = setmetatable({}, { __mode = 'v' })
    __任务 = setmetatable({}, { __mode = 'v' })
    __垃圾 = {}
    __战场 = {}
    __帮战 = {}

    __副本地图 = setmetatable({}, { __mode = 'v' })
    __地图 = setmetatable({}, {__index = __副本地图})

    __机器人 = setmetatable({}, { __mode = 'v' })
    __机器人ID = 1000000

    
    __帮派 = {}
    __事件 = {}
    __脚本 = {}
    _宠物蛋奖励 = require('数据库/宠物蛋奖励库')
    _地图在线奖励 = require('数据库/地图在线奖励')
    _角色 = {}
    __存档 = require('数据库/存档')
    __CDK = require('CDK')
    __仙玉 = __存档.仙玉
    __活动限制 = MYF.读取txt('daily.txt')
    -- MYF.写出txt('Record.txt',{召唤兽宝卷 = 3200 , 神兵奖励 = 600 , 龙之骨奖励 = 500 , 一阶仙器奖励 = 200 , 龙涎丸奖励 = 500 , 水陆数据 = {} })
    __外置数据 = MYF.读取txt('Record.txt')
    __水陆数据 = __外置数据.水陆数据 or {}
    __水陆大会 = {}
    __水陆匹配 = {计时 = 0 , 状态 = '' , 选手组 = {}}
    -- table.print(__外置数据)
    __五倍时间 = MYF.容错表({})
    __双倍时间 = MYF.容错表({})
    -- __奖励池 = require('奖励池')
    __对象 =
    setmetatable(
        {},
        {
            __mode = 'v',
            __index = function(_, k)
                return __物品[k] or __召唤[k] or __宠物[k] or __坐骑[k] or __法宝[k] or __NPC[k]
            end
        }
    ) --所有

    -->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


    --==================================================================
    __世界 = require('世界')
    function gge.onerror(err)
        __世界:ERROR(err)
    end

    function _生成ID()
        return require('nanoid').generate()
    end

    __世界:INFO('读取地图')
    for _, t in ipairs(require('data/map')) do
        local id = t.id
        if id < 100000 and id > 10000 then
            id = id % 10000
        end
        t.障碍 = GGF.读入文件(string.format('data/map/%d.cell', id))
        __地图[t.id] = require('地图/地图')(t)
    end

    __世界:INFO('读取脚本')
    __沙盒 = require('沙盒/沙盒')
    require('沙盒/接口')
    local _munpack = require('cmsgpack.safe').unpack
    for k, v in pairs(__存档.帮派读取()) do
        local bp = require('对象/帮派/帮派')(v,true)
    end
    __rpc = require('server')
    __lnk = require('link')
end
引擎:print('\x1b[32;1m服务启动耗时:\x1b[0m', os.clock() - t..'s')
print('--------------------------------------------------------------------------------------------------------------------')
if gge.isdebug then
    require('test')
end

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

function read_csv_file(file_name)
    local headers = {"card_number",  "Value"}
    local file = io.open(file_name, "r")
    if not file then
        return {}
    end
    local data = {}
    local is_header = true
    for line in file:lines() do
        if is_header then
            is_header = false
        else
            local values = {}
            for value in line:gmatch("[^,]+") do
                table.insert(values, value)
            end
            table.insert(data, values)
        end
    end
    file:close()
    return data, headers
end

function write_csv_file(file_name, data, headers)
    local file = io.open(file_name, "a")
    if file:seek("end") == 0 then
        file:write(table.concat(headers, ",") .. "\n")
    end
    for _, values in ipairs(data) do
        file:write(table.concat(values, ",") .. "\n")
    end
    file:close()
end

function validate_card(file_name, card_number)
    local data, headers = read_csv_file(file_name)
    for _, values in ipairs(data) do
        if values[1] == card_number then
            return false
        end
    end
    return true
end

function record_card(file_name, card_number, value, account, reference,time)
    print(file_name, card_number,value, account, reference, time)
    local data, headers = read_csv_file(file_name)
    table.insert(data, {card_number,value, account, reference, time})
    write_csv_file(file_name, {data[#data]}, headers)
end

--[[活动安排

周一:夺镖任务
周二:天元盛典
周三:花灯报吉
周四:城东保卫战
周五:孔庙祭祀
周末:龙宫寻宝


]]--

--[[
简单
    左键选中道具
    仓库拿起

    跨地图
    地图旗子

    叠加选项
    玩家信息
    
    变身卡
    炼妖

    PK
    帮派
    
困难
    WIN7
    日志
    存档缓存 redis

未开始
    法宝
    宝宝
    好友
    可接任务
    全局喇叭

手机
    左上角点不到
    物品 使用 丢弃
    移动    整理
    
]]
