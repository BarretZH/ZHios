//
//  JCTagView.m
//  JCLabel
//
//  Created by QB on 16/4/26.
//  Copyright © 2016年 JC. All rights reserved.
//

#import "JCTagView.h"
#import "RelatedCoursesModel.h"
#import "Materials.h"

#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING   3.0f
#define LABEL_MARGIN       10.0f
#define BOTTOM_MARGIN      10.0f

///随机颜色
#define RandomColor  [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];

@interface JCTagView ()
{
    CGRect _previousFrame;
    int _totalHeight;
    UIButton *_tag;
    
    int numberTag;
    
    int abc;
}

@end

@implementation JCTagView

//初始化方法
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _totalHeight = 0;
        numberTag = 0;
        self.frame = frame;
    }
    
    return self;
}


//设置 标签数组
- (void)setArrayTagWithLabelArray:(NSArray *)array {
    //设置frame
    _previousFrame = CGRectZero;
    _totalHeight = 0;
    abc = 0;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        RelatedCoursesModel * RCmodel = obj;
        [self setupBtnWithNSString:obj];
        
    }];
    ///设置整个View的背景
    if(_JCbackgroundColor){
        
        self.backgroundColor = _JCbackgroundColor;
//        NSLog(@"--------%@",_JCbackgroundColor);
    }else{
        self.backgroundColor=[UIColor whiteColor];
    }
//    NSLog(@"---+++++-----%@",_JCbackgroundColor);
}


//初始化按钮
- (void)setupBtnWithNSString:(id)sender {
//    RelatedCoursesModel * RCmodel = (RelatedCoursesModel*)sender;
    abc = abc+1;
    NSString * str = @"";
    //初始化按钮
    _tag = [UIButton buttonWithType:UIButtonTypeCustom];
    if (_isAddLin) {
        Materials * RCmodel = (Materials *)sender;
        str = RCmodel.title;
        NSMutableAttributedString *strs = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange strRange = {0,[strs length]};
        [strs addAttribute:NSForegroundColorAttributeName value:colorWithRGBA(89, 212, 234, 1) range:strRange];//字体颜色
        [strs addAttribute:NSUnderlineColorAttributeName value:colorWithRGBA(89, 212, 234, 0.6) range:strRange];//下划线颜色
        [strs addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [_tag setAttributedTitle:strs forState:UIControlStateNormal];
        _tag.tag = numberTag;
        numberTag = numberTag + 1;
    }else {
        RelatedCoursesModel * RCmodel = (RelatedCoursesModel*)sender;
        str = RCmodel.title;
        [_tag setTitle:str forState:UIControlStateNormal];
        _tag.tag = RCmodel.ID;
        [_tag setTitleColor:[UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1] forState:UIControlStateNormal];
    }
//    NSString * titleStr = str;
    _tag.frame = CGRectZero;
    if (_JCSignalTagColor) {
        _tag.backgroundColor = _JCSignalTagColor;
    }else {
        _tag.backgroundColor = RandomColor;
    }
    //设置内容水平居中
    _tag.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    //设置字体的大小
    _tag.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _tag.layer.cornerRadius = 10;
    _tag.layer.masksToBounds = YES;
    //设置字体的颜色
//    [_tag setTitleColor:[UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1] forState:UIControlStateNormal];
//    [_tag setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //设置方法
    [_tag addTarget:self action:@selector(clickHandle:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]};
    CGSize StrSize = [str sizeWithAttributes:attribute];
    StrSize.width += HORIZONTAL_PADDING * 2;
    StrSize.height += VERTICAL_PADDING *2;
    if (StrSize.width > SMScreenWidth-20) {
        StrSize.width = SMScreenWidth-20;
    }
    _tag.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    ///新的 SIZE
    CGRect  NewRect = CGRectZero;
    /**/
    if (/*_previousFrame.origin.x + _previousFrame.size.width + StrSize.width + LABEL_MARGIN > self.bounds.size.width*/abc>1) {
        if (_previousFrame.origin.x + _previousFrame.size.width + StrSize.width + LABEL_MARGIN > self.bounds.size.width) {
            NewRect.origin = CGPointMake(10, _previousFrame.origin.y + StrSize.height + BOTTOM_MARGIN);
            _totalHeight += StrSize.height + BOTTOM_MARGIN;
        }else {
            NewRect.origin = CGPointMake(_previousFrame.origin.x + _previousFrame.size.width + LABEL_MARGIN, _previousFrame.origin.y);
        }
    }else {
        NewRect.origin = CGPointMake(_previousFrame.origin.x + _previousFrame.size.width + LABEL_MARGIN, _previousFrame.origin.y);
    }
    NewRect.size = StrSize;
    [_tag setFrame:NewRect];
    _previousFrame = _tag.frame;
    [self setHight:self andHight:_totalHeight + StrSize.height + BOTTOM_MARGIN];
    [self addSubview:_tag];
    ///设置背景 颜色
   

}

#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}


#pragma mark==========按钮的处理方法

///按钮的处理方法
- (void)clickHandle:(UIButton *)sender{
//    NSLog(@"点击了，点解了%ld",sender.tag);
    NSString * str = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    if ([_delegate respondsToSelector:@selector(relatedCoursesWithID:)]) {
        [_delegate relatedCoursesWithID:str];
    }
    if ([_delegate respondsToSelector:@selector(relatedCoursesWithTagView:ID:)]) {
        [_delegate relatedCoursesWithTagView:self ID:str];
    }
}

@end
