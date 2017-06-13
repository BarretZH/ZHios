//
//  YGTeacherCourse.m
//  ShowMusePlanB
//
//  Created by liuyonggang on 16/5/2016.
//  Copyright © 2016 liuyonggang. All rights reserved.
//

#import "YGTeacherCourse.h"

// 姓名label距离顶部间距
#define NAMELABELMARGIN 22
// 姓名label的高度
#define NAMELABELHEIGHT 20
// 介绍label- 姓名 - 顶部间距
#define NAMELABELBOTTOMMARGIN 5
// 介绍文本右边的间距
#define INTROLABELRIGHTMARGIN 18
// introLabel - iconView - left margin
#define INTROLABELLEFTMARGIN 10
// iconView - left - margin
#define ICONVIEWLEFTMARGIN 18
// iconView - width
#define ICONVIEWWIDTH 52
// 介绍文本底部距分割线的间距
#define INTROLABELBOTTOMMARGIN 12
// 分割线的高度
#define SEPARATORHEIGHT 1

@implementation YGTeacherCourse
{
    CGFloat _viewHeight;
}

#pragma mark - getter
- (CGFloat)viewHeight
{
    CGFloat textH = 0.0;
    if (!_viewHeight) {
        // 计算介绍文字的最大Y值
        CGFloat textY = NAMELABELMARGIN + NAMELABELHEIGHT + NAMELABELBOTTOMMARGIN;
        CGFloat textW = SMScreenWidth - ICONVIEWLEFTMARGIN - ICONVIEWWIDTH - INTROLABELLEFTMARGIN - INTROLABELRIGHTMARGIN;
        CGSize maxSize = CGSizeMake(textW, MAXFLOAT);
        textH = [self.introduction boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0]} context:nil].size.height;
        _viewHeight = textY + textH + INTROLABELBOTTOMMARGIN + SEPARATORHEIGHT;
    }
    
    return _viewHeight;
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.ID = [dict[@"id"] integerValue];
        self.name = dict[@"name"];
        self.introduction = dict[@"introduction"];
        self.avatar = dict[@"avatar"];
        self.favourite = [dict[@"isFavourite"] boolValue];
    }
    return self;
}

+ (instancetype)courseWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
