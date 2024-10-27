-- @Author              : GGELUA
-- @Last Modified by    : GGELUA2
-- @Date                : 2023-04-11 04:21:54
-- @Last Modified time  : 2023-04-16 17:15:28

local 姓库 = {
    '赵',
    '钱',
    '孙',
    '李',
    '周',
    '吴',
    '郑',
    '王',
    '冯',
    '陈',
    '褚',
    '卫',
    '蒋',
    '沈',
    '韩',
    '杨',
    '朱',
    '秦',
    '尤',
    '许',
    '何',
    '吕',
    '施',
    '张',
    '孔',
    '曹',
    '严',
    '华',
    '金',
    '魏',
    '陶',
    '姜',
    '戚',
    '谢',
    '邹',
    '喻',
    '柏',
    '水',
    '窦',
    '章',
    '云',
    '苏',
    '潘',
    '葛',
    '奚',
    '范',
    '彭',
    '郎',
    '鲁',
    '韦',
    '昌',
    '马',
    '苗',
    '凤',
    '花',
    '方',
    '俞',
    '任',
    '袁',
    '柳',
    '邓',
    '鲍',
    '史',
    '唐',
    '费',
    '廉',
    '岑',
    '薛',
    '雷',
    '贺',
    '倪',
    '汤',
    '藤',
    '殷',
    '罗',
    '毕',
    '郝',
    '邬',
    '安',
    '常',
    '乐',
    '于',
    '时',
    '付',
    '皮',
    '卞',
    '齐',
    '康',
    '伍',
    '余',
    '元',
    '卜',
    '顾',
    '孟',
    '平',
    '黄',
    '和',
    '穆',
    '肖',
    '尹',
    '姚',
    '邵',
    '湛',
    '汪',
    '祁',
    '毛',
    '禹',
    '狄',
    '米',
    '贝',
    '明',
    '藏',
    '计',
    '伏',
    '成',
    '戴',
    '谈',
    '宋',
    '茅',
    '庞',
    '熊',
    '纪',
    '舒',
    '屈',
    '项',
    '祝',
    '董',
    '梁',
    '杜',
    '阮',
    '伏',
    '蓝',
    '闵',
    '席',
    '季',
    '麻',
    '强',
    '贾',
    '路',
    '娄',
    '危',
    '江',
    '童',
    '颜',
    '郭',
    '梅',
    '盛',
    '林',
    '刁',
    '钟',
    '徐',
    '邱',
    '骆',
    '高',
    '夏',
    '蔡',
    '田',
    '樊',
    '胡',
    '凌',
    '霍',
    '虞',
    '万',
    '支',
    '柯',
    '昝',
    '管',
    '卢',
    '莫',
    '经',
    '房',
    '裘',
    '缪',
    '干',
    '解',
    '应',
    '宗',
    '丁',
    '宣',
    '贲',
    '郁',
    '单',
    '杭',
    '洪',
    '包',
    '诸',
    '左',
    '石',
    '崔',
    '吉',
    '钮',
    '龚',
    '程',
    '嵇',
    '邢',
    '滑',
    '裴',
    '陆',
    '荣',
    '翁',
    '荀',
    '羊',
    '惠',
    '甄',
    '上官',
    '欧阳',
    '夏候',
    '诸葛',
    '闻人',
    '东方',
    '赫连',
    '皇甫',
    '尉迟',
    '公羊',
    '澹台',
    '公冶',
    '宗政',
    '濮阳',
    '淳于',
    '单于',
    '太叔',
    '申屠',
    '公孙',
    '仲孙',
    '轩辕',
    '令狐',
    '钟离',
    '宇文',
    '长孙',
    '慕容',
    '鲜于',
    '闾丘',
    '司徒',
    '司空',
    '亓官',
    '司寇',
    '仉督',
    '子车',
    '颛孙',
    '端木',
    '巫马',
    '公西',
    '漆雕',
    '乐正',
    '壤驷',
    '公良',
    '拓拔',
    '夹谷',
    '宰父',
    '谷梁',
    '南宫',
    '百里',
    '段干',
    '东郭',
    '南门',
    '呼延',
    '归海',
    '羊舌',
    '微生',
    '梁丘',
    '左丘',
    '东门',
    '西门',
    '谯笪',
    '楚',
    '晋',
    '闫',
    '法',
    '汝',
    '鄢',
    '涂',
    '钦',
    '岳',
    '帅',
    '缑',
    '亢',
    '况',
    '有',
    '琴',
    '商',
    '牟',
    '佘',
    '耳',
    '伯',
    '赏',
    '墨',
    '哈',
    '年',
    '爱',
    '阳',
    '佟',
    '言',
    '福',
    '曲',
    '家',
    '封',
    '芮',
    '羿',
    '储',
    '靳',
    '汲',
    '邴',
    '糜',
    '松',
    '祖',
    '井',
    '刘',
    '段',
    '富',
    '巫',
    '叶',
    '乌',
    '焦',
    '巴',
    '弓',
    '牧',
    '隗',
    '山',
    '谷',
    '车',
    '侯',
    '全',
    '蓬',
    '景',
    '郗',
    '班',
    '仰',
    '秋',
    '仲',
    '伊',
    '宫',
    '宁',
    '仇',
    '栾',
    '暴',
    '甘',
    '钭',
    '厉',
    '戎',
    '武',
    '符',
    '从',
    '詹',
    '束',
    '龙',
    '幸',
    '司',
    '韶',
    '郜',
    '黎',
    '蓟',
    '薄',
    '印',
    '宿',
    '白',
    '怀',
    '武',
    '蒲',
    '邰',
    '鄂',
    '索',
    '咸',
    '籍',
    '赖',
    '卓',
    '蔺',
    '屠',
    '蒙',
    '池',
    '乔',
    '阴',
    '胥',
    '能',
    '苍',
    '双',
    '闻',
    '莘',
    '党',
    '翟',
    '谭',
    '贡',
    '劳',
    '逄',
    '姬',
    '申',
    '扶',
    '堵',
    '冉',
    '宰',
    '郦',
    '雍',
    '隙',
    '璩',
    '桑',
    '桂',
    '濮',
    '牛',
    '寿',
    '通',
    '边',
    '扈',
    '燕',
    '冀',
    '郏',
    '浦',
    '尚',
    '农',
    '温',
    '别',
    '庄',
    '晏',
    '柴',
    '瞿',
    '阎',
    '充',
    '慕',
    '连',
    '茹',
    '习',
    '宦',
    '艾',
    '鱼',
    '容',
    '向',
    '古',
    '易',
    '慎',
    '戈',
    '廖',
    '庾',
    '终',
    '暨',
    '居',
    '衡',
    '步',
    '都',
    '耿',
    '满',
    '弘',
    '匡',
    '文',
    '国',
    '寇',
    '广',
    '禄',
    '阙',
    '东',
    '欧',
    '殳',
    '沃',
    '利',
    '蔚',
    '越',
    '夔',
    '隆',
    '师',
    '巩',
    '厍',
    '聂',
    '晁',
    '勾',
    '敖',
    '融',
    '訾',
    '冷',
    '辛',
    '阚',
    '那',
    '简',
    '饶',
    '空',
    '曾',
    '毋',
    '沙',
    '乜',
    '养',
    '鞠',
    '须',
    '丰',
    '巢',
    '关',
    '蒯',
    '相',
    '查',
    '后',
    '荆',
    '红',
    '游',
    '竺',
    '权',
    '逯',
    '盖',
    '益',
    '桓',
    '公',
    '俟'
}

local 单字 = {
    '天',
    '夜',
    '晴',
    '瑜',
    '飞',
    '文',
    '弘',
    '松',
    '晓',
    '智',
    '云',
    '易',
    '远',
    '航',
    '笑',
    '白',
    '映',
    '波',
    '代',
    '桃',
    '泽',
    '啸',
    '宸',
    '博',
    '靖',
    '琪',
    '十',
    '君',
    '浩',
    '绍',
    '辉',
    '冷',
    '安',
    '盼',
    '旋',
    '秋',
    '瑾',
    '宇',
    '黎',
    '杰',
    '辉',
    '德',
    '邪',
    '默',
    '磊',
    '豪',
    '寒',
    '瀚',
    '哲',
    '阳',
    '风',
    '皓',
    '世',
    '轩',
    '思',
    '鸿',
    '涛',
    '煜',
    '雄',
    '英',
    '诗',
    '展',
    '聪',
    '俊',
    '海',
    '彤',
    '珍',
    '雨',
    '琴',
    '玉',
    '鹏',
    '祺',
    '命',
    '成',
    '先',
    '忘',
    '幽',
    '威',
    '秀',
    '凡',
    '渊',
    '熙',
    '胜',
    '鸣',
    '姿',
    '芷',
    '芝',
    '筝',
    '真',
    '贞',
    '婴',
    '雯',
    '纹',
    '菀',
    '莞',
    '宛',
    '桐',
    '愫',
    '素',
    '涑',
    '姝',
    '弱',
    '若',
    '蓉',
    '清',
    '青',
    '茗',
    '敏',
    '萍',
    '蓝',
    '兰',
    '莺',
    '萤',
    '弱',
    '怡',
    '紫',
    '芯',
    '雁',
    '嫣',
    '荠',
    '嵩',
    '卿',
    '裘',
    '阁',
    '康',
    '城',
    '焱',
    '穆',
    '枫',
    '翼',
    '鹤',
    '乾'
}

local 双字 = {
    '之玉',
    '越泽',
    '锦程',
    '修杰',
    '烨伟',
    '尔曼',
    '立辉',
    '致远',
    '天思',
    '友绿',
    '聪健',
    '修洁',
    '访琴',
    '初彤',
    '谷雪',
    '平灵',
    '源智',
    '申屠',
    '振家',
    '越彬',
    '子轩',
    '伟宸',
    '晋鹏',
    '觅松',
    '海亦',
    '雨珍',
    '浩宇',
    '嘉熙',
    '志泽',
    '苑博',
    '念波',
    '峻熙',
    '俊驰',
    '子车',
    '南松',
    '聪展',
    '问旋',
    '黎昕',
    '谷波',
    '凝海',
    '靖易',
    '芷烟',
    '渊思',
    '煜祺',
    '乐驹',
    '风华',
    '睿渊',
    '博超',
    '天磊',
    '夜白',
    '初晴',
    '瑾瑜',
    '鹏飞',
    '弘文',
    '伟泽',
    '迎松',
    '雨泽',
    '鹏笑',
    '诗云',
    '白易'
}

return function(n)--1姓 2名 3姓名
    local 名称 = ''
    local 姓 = 姓库[math.random(#姓库)]
    if n==1 then
        return 姓
    end
    if math.random(100) <= 30 then
        名称 = 双字[math.random(#双字)]
    elseif math.random(100) <= 60 then
        名称 = 单字[math.random(#单字)]
    else
        名称 = 单字[math.random(#单字)] .. 单字[math.random(#单字)]
    end
    if n==2 then
        return 名称
    end
    return 姓 ..名称
end
