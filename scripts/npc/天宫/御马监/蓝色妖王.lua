local NPC = {}
local 对话 = {
"看你的样子好像味道不错~",
 "被神仙捉去以后，第一天他们打我，我没有说，第二天他们还打我，我还是没有说，第三天他们送来个漂亮的仙女mm。我说了，第四天我还想说，可是他们把我给砍了，现在我只好在这里当个可怜的鬼怪。",
 "王法？老子就是王法～",
 "做神仙有什么好？那么多规矩，还是妖怪爽，见谁砍谁，哈哈～",
 "钱？命？我都要了～"
}






function NPC:NPC对话(玩家, i)
    return 对话[math.random( #对话 )]
end

function NPC:NPC菜单(玩家, i)

end

return NPC