-- @Author              : GGELUA
-- @Last Modified by    : baidwwy
-- @Date                : 2022-07-16 01:23:57
-- @Last Modified time  : 2024-08-25 20:09:12

local 角色 = require('角色')
function 角色:宠物_初始化()
    if type(self.宠物) == 'table' then
        for k, v in pairs(self.宠物) do
            local P = require('对象/宠物')(v)
            P.主人 = self
            self.宠物[k] = P
            if P.是否观看 then
                self.观看宠物 = P
            end
            if P.是否选中 then
                self.当前宠物 = P
            end
        end
    else
        self.宠物 = {}
    end
end

function 角色:宠物_添加(P) --pet
    if ggetype(P) == '宠物' then
        P.rid = self.id
        P.主人 = self
        P.获得时间 = os.time()
        self.宠物[P.nid] = P
        if not self.当前宠物 then
            P.是否选中 = true
            self.当前宠物 = P
        end
        return P
    end
end

function 角色:角色_取宠物信息()
    if self.当前宠物 then
        return self.当前宠物
    end
    return
end

function 角色:角色_打开宠物窗口()
    local _名称颜色 = {
        0xFF8C00FF, -- 橙色0转
        0xEE82EEFF, -- 粉色1转
        0x7B68EEFF, -- 紫色2转
        0x0000CDFF, -- 深蓝3转
        0x4B0082FF, -- 深紫4转
    }
    if self.当前宠物 then
        local r = {
            nid = self.当前宠物.nid,
            外形 = self.当前宠物.外形,
            名称 = self.当前宠物.名称,
            名称颜色 = _名称颜色[self.转生+1],
            等级 = self.当前宠物.等级,
            耐力 = self.当前宠物.耐力,
            经验 = self.当前宠物.经验,
            是否观看 = self.当前宠物.是否观看,
            最大耐力 = self.当前宠物.最大耐力,
            最大经验 = self.当前宠物.最大经验
        }
        self.窗口.宠物 = true
        return r
    end
end
