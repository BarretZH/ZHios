//
//  SMDownloadHeaderView.m
//  ShowMuse
//
//  Created by ygliu on 7/27/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "SMDownloadHeaderView.h"
#import "Masonry.h"

@interface SMDownloadHeaderView ()
/** separatorLine */
@property (nonatomic,weak) UIView *separatorLine;
/** segmentControl */
@property (nonatomic,weak) UISegmentedControl *pageControl;

@end

@implementation SMDownloadHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupWedgets];
        [self addConstraint];
    }
    return self;
}

- (void)setupWedgets
{
    UISegmentedControl *pageControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"DOWNLOAD_PAGE_DOWNLOADED", nil), NSLocalizedString(@"DOWNLOAD_PAGE_DOWNLOADING", nil)]];
    pageControl.tintColor = colorWithRGB(109, 217, 241);
    [pageControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} forState:UIControlStateNormal];
    [pageControl addTarget:self action:@selector(downloadBtnDidClick:) forControlEvents:UIControlEventValueChanged];
    pageControl.selectedSegmentIndex = 0;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    //separatorLine
    UIView *sepatorLine = [[UIView alloc] init];
    [self addSubview:sepatorLine];
    sepatorLine.backgroundColor = [UIColor lightGrayColor];
    sepatorLine.alpha = 0.3;
    self.separatorLine = sepatorLine;
}

- (void)addConstraint
{
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(kDownloadHeaderPageControlMargin);
        make.left.equalTo(self.left).offset(kDownloadHeaderPageControlMargin);
        make.bottom.equalTo(self.bottom).offset(-kDownloadHeaderPageControlMargin);
        make.right.equalTo(self.right).offset(-kDownloadHeaderPageControlMargin);
    }];
    
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(SMScreenWidth);
        make.bottom.equalTo(self.bottom);
        make.height.equalTo(kDownloadSepLineH);
    }];
}

- (void)downloadBtnDidClick:(UISegmentedControl *)pageControl
{
    // call delegate
    if ([self.headerViewDelegate respondsToSelector:@selector(headerViewSegmentControlDidClick:)]) {
        [self.headerViewDelegate performSelector:@selector(headerViewSegmentControlDidClick:) withObject:self.pageControl];
    }
}

@end
