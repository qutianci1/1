-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2024-03-18 21:34:43
-- @Last Modified time  : 2024-04-13 06:12:33

-- -- @Author              : GGELUA
-- -- @Last Modified by    : GGELUA2
-- -- @Date                : 2024-03-18 21:34:43
-- -- @Last Modified time  : 2024-03-27 23:09:57

-- -- -- @Author              : GGELUA
-- -- -- @Last Modified by    : baidwwy
-- -- -- @Date                : 2022-06-19 14:29:58
-- -- -- @Last Modified time  : 2022-06-20 05:43:13

local 角色 = require('角色')

function 角色:角色_GM_移动地图(mid, x, y)
    local map = __地图[mid]
    if not self:取称谓是否存在('任我行') then
        return  self.rpc:提示窗口("#Y你没有任我行")
    end
    if map then
        self:移动_切换地图(map, x, y)
    else
        print('地图不存在')
    end
end
