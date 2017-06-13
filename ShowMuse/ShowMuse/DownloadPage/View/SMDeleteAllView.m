//
//  SMDeleteAllView.m
//  ShowMuse
//
//  Created by ygliu on 7/28/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "SMDeleteAllView.h"
#import "Masonry.h"

@interface SMDeleteAllView ()
/** selectAll button */
@property (nonatomic,weak) UIButton *selectAllBtn;
/** delete button */
@property (nonatomic,weak) UIButton *deleteBtn;
/** record current selected button */
@property (nonatomic,weak) UIButton *selectedBtn;
/** separatorLine */
@property (nonatomic,weak) UIView *middleLine;

@end

@implementation SMDeleteAllView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupChildWedgets];
    }
    return self;
}

- (void)setupChildWedgets
{
    UIButton *selectAllBtn = [self createButtonWithButtonName:NSLocalizedString(@"DOWNLOAD_PAGE_SELECTALL", nil)];
    selectAllBtn.tag = 0;
    self.selectAllBtn = selectAllBtn;

    UIButton *deleteBtn = [self createButtonWithButtonName:NSLocalizedString(@"DOWNLOAD_PAGE_DELETE", nil)];
    deleteBtn.tag = 1;
    self.deleteBtn = deleteBtn;
    
    UIView *middleLine = [[UIView alloc] init];
    self.middleLine = middleLine;
    [self addSubview:middleLine];
    middleLine.backgroundColor = [UIColor blackColor];
    middleLine.alpha = 0.07;
    
}

- (UIButton *)createButtonWithButtonName:(NSString *)btnName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:btnName forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self addSubview:button];
    [button addTarget:self action:@selector(selectOrDeleteAllBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateButtonsStatus];
    
    [self.selectAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.bottom.equalTo(self.bottom);
        make.right.equalTo(self.deleteBtn.left);
        make.width.equalTo(self.deleteBtn.width);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.right.equalTo(self.right);
        make.bottom.equalTo(self.bottom);
    }];
    
    [self.middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(kDownloadBottomMargin);
        make.bottom.equalTo(self.bottom).offset(-kDownloadBottomMargin);
        make.width.equalTo(kDownloadSepLineH);
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.centerY);
    }];
}

- (void)selectOrDeleteAllBtnDidClick:(UIButton *)button
{
    self.selectedBtn.backgroundColor = [UIColor whiteColor];
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    button.backgroundColor = colorWithRGB(109, 217, 241);
    
    if ([self.deleteDelegate respondsToSelector:@selector(SMDeleteViewButtonDidClick:)]) {
        [self.deleteDelegate performSelector:@selector(SMDeleteViewButtonDidClick:) withObject:self.selectedBtn];
    }
}

- (void)updateButtonsStatus
{
    self.selectedBtn = nil;
    self.selectAllBtn.selected = NO;
    self.deleteBtn.selected = NO;
    self.selectAllBtn.backgroundColor = [UIColor whiteColor];
    self.deleteBtn.backgroundColor = [UIColor whiteColor];
}

@end
