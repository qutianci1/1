local 物品 = {
    名称 = 'VIP月卡',
    叠加 = 999,
    类别 = 10,
    类型 = 0,
    对象 = 1,
    条件 = 2,
    绑定 = false
}

function 物品:使用(对象)
    if 对象.是否玩家 then
        local yy = 对象:取任务('玉枢返虚丸')
        local lm = 对象:取任务('六脉化神丸')
        local yl = 对象:取任务('疏筋理气丸')
		local yk = 对象:取任务('VIP月卡')


		if yk then 
            yk:添加时间()
			对象:常规提示("#Y您使用了VIP月卡,您的月卡祝福增加了30天")
			 self.数量 = self.数量 - 1
		else
			对象:添加任务('VIP月卡')
            self.数量 = self.数量 - 1
            对象:常规提示("#Y尊贵的VIP玩家,月卡的祝福将伴您30天")
		end
    end

end

return 物品
