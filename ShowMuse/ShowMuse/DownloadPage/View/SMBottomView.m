//
//  SMBottomView.m
//  ShowMuse
//
//  Created by ygliu on 7/27/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "SMBottomView.h"
#import "Masonry.h"
#import <ZFDownloadManager.h>

@interface SMBottomView ()
/** top separator line */
@property (nonatomic,weak) UIView *topSepLine;
/** restStorageLabel */
@property (nonatomic,weak) UILabel *restStorageLabel;
/** bgGrayView */
@property (nonatomic,weak) UIView *grayView;
/** redView */
@property (nonatomic,weak) UIView *redView;
/** bottom button separator line */
@property (nonatomic,weak) UIView *btnSepLine;
/** stop all tasks button */
@property (nonatomic,weak) UIButton *stopAllBtn;
/** start all tasks button */
@property (nonatomic,weak) UIButton *startAllBtn;
/** record current selected button */
@property (nonatomic,weak) UIButton *selectedBtn;
/** separatorLine */
@property (nonatomic,weak) UIView *middleLine;

@end

@implementation SMBottomView
#pragma mark - init method
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addChildWedgets];
        [self addConstraints];
    }
    return self;
}
#pragma mark - create child wedgets and layout
- (void)addChildWedgets
{
    UIView *topSepLine = [self createSeparatorLineWithColor:[UIColor darkGrayColor] alpha:0.2];
    self.topSepLine = topSepLine;
    
    UILabel *restStorageLabel = [[UILabel alloc] init];
    restStorageLabel.font = [UIFont systemFontOfSize:12.0];
    restStorageLabel.attributedText = [self createAttributeString];
    restStorageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:restStorageLabel];
    self.restStorageLabel = restStorageLabel;
    
    // percentage view
    UIView *grayView = [[UIView alloc] init];
    [self addSubview:grayView];
    grayView.backgroundColor = colorWithRGB(207, 207, 207);
    self.grayView = grayView;
    
    CGFloat percentage = [[self getFreeDiskSpace] floatValue] / [[self getTotalDiskSpace] floatValue];
    percentage = 1 - percentage;
    UIView *redView = [[UIView alloc] init];
    redView.frame = CGRectMake(0, 0, SMScreenWidth * percentage, 5);
    [self.grayView addSubview:redView];
    redView.backgroundColor = [UIColor redColor];
    self.redView = redView;
    
    UIView *buttonSepLine = [self createSeparatorLineWithColor:[UIColor lightGrayColor] alpha:0.2];
    self.btnSepLine = buttonSepLine;

    UIButton *stopAllBtn = [self createButtonWithButtonName:NSLocalizedString(@"DOWNLOAD_PAGE_STOPALL", nil)];
    stopAllBtn.tag = 0;
    self.stopAllBtn = stopAllBtn;
    
    UIButton *startAllBtn = [self createButtonWithButtonName:NSLocalizedString(@"DOWNLOAD_PAGE_BEGINALL", nil)];
    stopAllBtn.tag = 1;
    self.startAllBtn = startAllBtn;
    
    UIView *middleLine = [self createSeparatorLineWithColor:[UIColor blackColor] alpha:0.07];
    self.middleLine = middleLine;
    
}

- (void)addConstraints
{
    [self.topSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.height.equalTo(kDownloadSepLineH);
    }];
    
    [self.restStorageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topSepLine.bottom);
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.height.equalTo(kDownloadBottomStorageLabelH);
    }];
    
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.restStorageLabel.bottom);
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.height.equalTo(kDownloadVideoMargin);
    }];
    
    [self.btnSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.grayView.bottom).offset(kDownloadBottomMargin);
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.height.equalTo(0.5);
    }];
    
    [self.stopAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnSepLine.bottom);
        make.left.equalTo(self.left);
        make.right.equalTo(self.startAllBtn.left);
        make.bottom.equalTo(self.bottom);
        make.width.equalTo(self.startAllBtn.width);
        
    }];
    
    [self.startAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stopAllBtn.top);
        make.right.equalTo(self.right);
        make.bottom.equalTo(self.stopAllBtn.bottom);
    }];
    
    [self.middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stopAllBtn.top).offset(kDownloadBottomMargin);
        make.bottom.equalTo(self.stopAllBtn.bottom).offset(-kDownloadBottomMargin);
        make.width.equalTo(kDownloadSepLineH);
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.stopAllBtn.centerY);
    }];
}

- (UIButton *)createButtonWithButtonName:(NSString *)btnName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:btnName forState:UIControlStateNormal];
    [button setTitleColor:colorWithRGB(109, 217, 241) forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(stopOrStartBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (UIView *)createSeparatorLineWithColor:(UIColor *)color alpha:(CGFloat)alpha
{
    UIView *line = [[UIView alloc] init];
    [self addSubview:line];
    line.backgroundColor = color;
    line.alpha = alpha;
    return line;
}
#pragma mark - listen buttons tap
- (void)stopOrStartBtnClick:(UIButton *)selectedBtn
{
    if ([ZFDownloadManager sharedDownloadManager].downinglist.count == 0) return;
    
    self.selectedBtn.enabled = YES;
    selectedBtn.enabled = NO;
    self.selectedBtn = selectedBtn;
    // call delegate
    if ([self.delegate respondsToSelector:@selector(bottomViewButtonDidClick:)]) {
        [self.delegate performSelector:@selector(bottomViewButtonDidClick:) withObject:self.selectedBtn];
    }
}

#pragma mark - handle system storage info
- (NSAttributedString *)createAttributeString
{
    CGFloat totalSize = [[self getTotalDiskSpace] floatValue];
    totalSize = totalSize / 1024 / 1024 / 1024;
    CGFloat freeSize = [[self getFreeDiskSpace] floatValue];
    freeSize = freeSize / 1024 / 1024 / 1024;
    CGFloat useSize = totalSize - freeSize;
    NSString *infoStr = nil;
    NSString *sysLanguage = [NSLocale preferredLanguages][0];
    if ([sysLanguage isEqualToString:@"en"]) { // english
        infoStr = [NSString stringWithFormat:@"total size %.1fG / used %1.fG / free %.1fG", totalSize, useSize, freeSize];
    } else if ([sysLanguage isEqualToString:@"zh-Hans"] || [sysLanguage isEqualToString:@"zh-Hans-CN"]) { // chinese
        infoStr = [NSString stringWithFormat:@"总空间为%.1fG / 已用%1.fG / 剩余%.1fG", totalSize, useSize, freeSize];
    } else if ([sysLanguage isEqualToString:@"zh-Hant"] || [sysLanguage isEqualToString:@"zh-Hant-CN"] || [sysLanguage isEqualToString:@"zh-TW"] || [sysLanguage isEqualToString:@"zh-HK"]) { // troditional chinese
        infoStr = [NSString stringWithFormat:@"總空間為%.1fG / 已用%1.fG / 剩餘%.1fG", totalSize, useSize, freeSize];
    } else {
        infoStr = [NSString stringWithFormat:@"total size%.1fG / used%1.fG / free%.1fG", totalSize, useSize, freeSize];
    };
    NSMutableAttributedString *textAttributes = [[NSMutableAttributedString alloc] initWithString:infoStr];
    NSString *pattern = @"\\d+(\\.\\d+)?";
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matchesArr = [reg matchesInString:infoStr options:NSMatchingReportCompletion range:NSMakeRange(0, infoStr.length)];
    if (matchesArr.count != 0) {
        NSTextCheckingResult *result0 = matchesArr[0];
        NSRange range0 = [result0 range];
        [textAttributes setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} range:range0];
        NSTextCheckingResult *result1 = matchesArr[1];
        NSRange range1 = [result1 range];
        [textAttributes setAttributes:@{NSForegroundColorAttributeName : colorWithRGB(252, 49, 49), NSFontAttributeName : [UIFont systemFontOfSize:14]} range:range1];
        NSTextCheckingResult *result2 = matchesArr[2];
        NSRange range2 = [result2 range];
        [textAttributes setAttributes:@{NSForegroundColorAttributeName : colorWithRGB(109, 217, 241), NSFontAttributeName : [UIFont systemFontOfSize:14]} range:range2];
    }
    return textAttributes;
}

#pragma mark - get disk space and free space
- (NSNumber *)getTotalDiskSpace
{
    return [[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemSize];
}
- (NSNumber *)getFreeDiskSpace
{
    return [[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemFreeSize];
}
@end
