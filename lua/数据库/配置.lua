--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2024-04-20 21:38:56
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2024-07-27 21:51:10
FilePath: \服务端\lua\数据库\配置.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-03-13 14:32:43
-- @Last Modified time  : 2024-10-11 21:37:13


return {
    内网 = {
        地址 = '127.0.0.1',
        端口 = 8000,
        服名='再续情缘'
    },
    外网 = {
        地址 = '127.0.0.1',
        端口 = 9527
    },
    三族 = true,
    乱敏 = false,
    兑换递增 = true,
    递增规则 = { 召唤兽宝卷 = {100 , 8000 , 300 , 3200}, 神兵奖励 = {10 , 4000 , 100 , 600} , 龙之骨奖励 = {5 , 1250 , 50 , 600}, 筋骨提气丸 = {2 , 1600 , 50 , 500}, 龙涎丸奖励 = {5 , 800 , 50 , 500}, 神兽碎片 = {10 , 1000 , 100 , 200} }
}
