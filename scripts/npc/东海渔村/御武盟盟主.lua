local NPC = {}
local 对话 = [[
您好！欢迎进入复古西游的情义世界！游侠盟是一个崇尚助强，扶弱敬老爱幼的联盟，在这里你能认识到更多的新朋友和热心助人的高手，您愿意加入游侠盟吗？
menu
]]

function NPC:NPC对话(玩家, i)
    return 对话
end

function NPC:NPC菜单(玩家, i)



end

function NPC:NPC给予(玩家, cash, items)
    return '你给我什么东西？'
end
return NPC
