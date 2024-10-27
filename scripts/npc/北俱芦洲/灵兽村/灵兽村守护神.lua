-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-08-30 20:04:56
-- @Last Modified time  : 2023-11-03 17:31:55

local NPC = {}
local 对话 = [[
近来镇压修罗界的碑文有所松动，且有小妖出逃。天帝命我将灵兽蛋赠与有缘之人，望孵出的小灵兽能助我等惩恶除奸! 此外，灵兽可找我进行蜕变仪式，”蜕变后的灵兽可还原为相应的灵兽蛋重新孵化。
menu
1|我想将我的坐骑"蜕变"成灵兽蛋
99|我到处参观参观再说吧]]


function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)
    if i == '1' then
        local r = 玩家:取乘骑坐骑()
        if r then
            return '你确定要将坐骑#G'..r.名称..'#W蜕变成灵兽蛋吗？\nmenu\n我确定\n我再想想'
        else
            return "请先将要操作的坐骑设置乘骑状态！#75"
        end
    elseif i == '我确定' then
        local r = 玩家:取乘骑坐骑()
        if r then
            local 管制 = 0
            for k,v in pairs(r.管制) do
                管制 = 管制 + 1
            end
            if 管制 >= 1 then
                return '请先取消召唤兽管制'
            end
            local 几座 = r.几座
            local rr = 玩家:取任务('灵兽降世')
            if rr then
                return '你已经有孵蛋任务了,无法继续领取'
            end
            玩家:删除当前坐骑()
            r:坐骑_乘骑(false)
            玩家:添加物品({生成物品 {名称 = '灵兽蛋', 参数 = 几座}})
            玩家:添加任务('灵兽降世')
        end
    end
end

return NPC
