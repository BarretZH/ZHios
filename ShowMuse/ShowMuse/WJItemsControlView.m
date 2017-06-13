//
//  WJItemsControlView.m
//  SliderSegment
//
//  Created by silver on 15/11/3.
//  Copyright (c) 2015年 Fsilver. All rights reserved.
//

#import "WJItemsControlView.h"

#import "Teachers.h"

#import "UIButton+WebCache.h"


@implementation WJItemsConfig

-(id)init
{
    self = [super init];
    if(self){
        
        _itemWidth = 0;
        _itemFont = [UIFont boldSystemFontOfSize:16];
        _textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1];
//        _textColor = [UIColor clearColor];
        _selectedColor = [UIColor colorWithRed:61/255.0 green:209/255.0 blue:165/255.0 alpha:1];
//        _selectedColor = [UIColor clearColor];
        _linePercent = 1;
        _lineHieght = 20;
    }
    return self;
}

@end


@interface WJItemsControlView()

@property(nonatomic,strong)UIView *line;

@property(nonatomic,strong)UILabel * label;





@end


@implementation WJItemsControlView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollsToTop = NO;
        self.tapAnimation = YES;
        
    }
    return self;
}

-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    
    if(!_config){
        NSLog(@"请先设置config");
        return;
    }
    
    float x = 0;
    float y = 0;
    float width = _config.itemWidth;
    float height = self.frame.size.height;
    
    for (int i=0; i<titleArray.count; i++) {
        Teachers * teacher = titleArray[i];
        x = _config.itemWidth*i+(_config.itemWidth-50)/2;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, /*y*/CGRectGetHeight(self.frame) - _config.lineHieght-20-50, /*width, height-40*/50,50)];
        btn.tag = 100+i;
        if ([teacher.avatar isEqual:[NSNull null]]) {
            
        }else {
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:teacher.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [btn setBackgroundImage:[image circleImage] forState:UIControlStateNormal];
            }];
        }
        UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40+btn.frame.origin.x, btn.frame.origin.y+40, 10, 10)];
        if (teacher.isFavourite) {
//            likeImageView.backgroundColor = [UIColor redColor];
            likeImageView.alpha = 1;
            likeImageView.image = [UIImage imageNamed:@"heart_"];
        }else {
//            likeImageView.backgroundColor = [UIColor greenColor];
            likeImageView.alpha = 0;
//            likeImageView.image = [UIImage imageNamed:@"heart_no"];
        }
        likeImageView.tag = [teacher.ID integerValue];
        
        [btn addTarget:self action:@selector(itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self addSubview:likeImageView];
        
        if(i==0){

           [btn setTitleColor:_config.selectedColor forState:UIControlStateNormal];
            _currentIndex = 0;
            self.line = [[UIView alloc] initWithFrame:CGRectMake(_config.itemWidth*(1-_config.linePercent)/2.0, CGRectGetHeight(self.frame) - _config.lineHieght-22, _config.itemWidth*_config.linePercent, _config.lineHieght+22)];
//            _line.backgroundColor = _config.selectedColor;
            [self addSubview:_line];
            self.label = [[UILabel alloc] initWithFrame:CGRectMake(_config.itemWidth*(1-_config.linePercent)/2.0, CGRectGetHeight(self.frame) - _config.lineHieght-22, _config.itemWidth*_config.linePercent, _config.lineHieght+22)];
            self.label.text = teacher.name;
            self.label.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
            self.label.font = [UIFont systemFontOfSize:13 weight:0.3];
            self.label.numberOfLines = 0;
            self.label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_label];
        }
    }
    self.contentSize = CGSizeMake(width*titleArray.count, height);
}

#pragma mark - 关注图片改变状态
-(void)likeImageViewChangeWithTag:(NSInteger)number {
    UIImageView * imgView = [self viewWithTag:number];
    for (int i = 0; i<self.teacherArray.count; i++) {
         Teachers * teacher = self.teacherArray[i];
        if ([teacher.ID integerValue] == number) {
            if (teacher.isFavourite) {
                imgView.alpha = 1;
                imgView.image = [UIImage imageNamed:@"heart_"];
                SMLog(@"----------1");
            }else {
                imgView.alpha = 0;
                SMLog(@"----------0");
            }

        }
    }

}

#pragma mark - 点击事件

-(void)itemButtonClicked:(UIButton*)btn
{
    //接入外部效果
    _currentIndex = btn.tag-100;
    
    if(_tapAnimation){
        
        //有动画，由call is scrollView 带动线条，改变颜色
        
        
    }else{
        
        //没有动画，需要手动瞬移线条，改变颜色
        [self changeItemColor:_currentIndex];
        [self changeLine:_currentIndex];
    }
    
    [self changeScrollOfSet:_currentIndex];
    
    if(self.tapItemWithIndex){
        _tapItemWithIndex(_currentIndex,_tapAnimation);
    }
    
    
}


#pragma mark - Methods

//改变文字焦点
-(void)changeItemColor:(NSInteger)index
{
//    for (int i=0; i<_titleArray.count; i++) {
//        
//        UIButton *btn = (UIButton*)[self viewWithTag:i+100];
//        [btn setTitleColor:_config.textColor forState:UIControlStateNormal];
//        if(btn.tag == index+100){
//            [btn setTitleColor:_config.selectedColor forState:UIControlStateNormal];
//        }
//    }
}

//改变线条位置
-(void)changeLine:(float)index
{
    CGRect rect = _line.frame;
    rect.origin.x = index*_config.itemWidth + _config.itemWidth*(1-_config.linePercent)/2.0;
    _line.frame = rect;
    _label.frame = rect;
//    _label.text =@"123456789";
//    NSLog(@"%f",index);
    for (int i = 0 ; i<_titleArray.count; i++) {
        if (index == i) {
            Teachers * teacher = _titleArray[i];
            _label.text = teacher.name;
        }
    }
    
}


//向上取整
- (NSInteger)changeProgressToInteger:(float)x
{
    
    float max = _titleArray.count;
    float min = 0;
    
    NSInteger index = 0;
    
    if(x< min+0.5){
        
        index = min;
        
    }else if(x >= max-0.5){
        
        index = max;
        
    }else{
        
        index = (x+0.5)/1;
    }
    
    return index;
}


//移动ScrollView
-(void)changeScrollOfSet:(NSInteger)index
{
    float  halfWidth = CGRectGetWidth(self.frame)/2.0;
    float  scrollWidth = self.contentSize.width;
    
    float leftSpace = _config.itemWidth*index - halfWidth + _config.itemWidth/2.0;
    
    if(leftSpace<0){
        leftSpace = 0;
    }
    if(leftSpace > scrollWidth- 2*halfWidth){
        leftSpace = scrollWidth-2*halfWidth;
    }
//    NSLog(@"头像%f",leftSpace);
    [self setContentOffset:CGPointMake(leftSpace, 0) animated:YES];
}



#pragma mark - 在ScrollViewDelegate中回调
-(void)moveToIndex:(float)x
{
    [self changeLine:x];
    NSInteger tempIndex = [self changeProgressToInteger:x];
    if(tempIndex != _currentIndex){
        //保证在一个item内滑动，只执行一次
        [self changeItemColor:tempIndex];
    }
    _currentIndex = tempIndex;
    
}

-(void)endMoveToIndex:(float)x
{
    [self changeLine:x];
    [self changeItemColor:x];
    _currentIndex = x;
    
    [self changeScrollOfSet:x];
}





@end









