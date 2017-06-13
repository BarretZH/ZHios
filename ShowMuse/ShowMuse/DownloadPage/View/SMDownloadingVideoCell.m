//
//  SMDownloadingVideoCell.m
//  ShowMuse
//
//  Created by ygliu on 7/27/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#define SmallVideoImageWith 80
#define BigVideoImageWith 100

#import "SMDownloadingVideoCell.h"
#import "Masonry.h"
#import <ZFDownloadManager.h>

@interface SMDownloadingVideoCell ()

/** videoBtn */
@property (nonatomic,weak) UIButton *videoBtn;
/** videoNameLabel */
@property (nonatomic,weak) UILabel *videoNameLabel;
/** progressView */
@property (nonatomic,weak) UIProgressView *progressView;
/** status or speed label */
@property (nonatomic,weak) UILabel *statusLabel;
/** check button */
@property (nonatomic,weak) UIView *separatorLine;

@end

@implementation SMDownloadingVideoCell

#pragma mark - setter
- (void)setFileInfo:(ZFFileModel *)fileInfo
{
    _fileInfo = fileInfo;
    self.videoNameLabel.text = fileInfo.fileName;
    if ([fileInfo.fileSize longLongValue] == 0) {
        self.statusLabel.text = NSLocalizedString(@"DOWNLOAD_PAGE_WAITING", nil);
        self.progressView.progress = 0.0;
        return;
    }
    // 下载进度
    float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];
    self.progressView.progress = progress;
    self.statusLabel.text = [NSString stringWithFormat:@"%@/s", [ZFCommonHelper getFileSizeString:[NSString stringWithFormat:@"%lu", [ASIHTTPRequest averageBandwidthUsedPerSecond]]]];
    [self.videoBtn setBackgroundImage:fileInfo.fileimage forState:UIControlStateNormal];
    
    if (fileInfo.downloadState == ZFDownloading) { //文件正在下载
        self.videoBtn.selected = NO;
    } else if (fileInfo.downloadState == ZFStopDownload&&!fileInfo.error) {
        self.videoBtn.selected = YES;
        self.statusLabel.text = NSLocalizedString(@"DOWNLOAD_PAGE_PAUSE", nil);
    }else if (fileInfo.downloadState == ZFWillDownload&&!fileInfo.error) {
        self.videoBtn.selected = YES;
        self.statusLabel.text = NSLocalizedString(@"DOWNLOAD_PAGE_WAITING", nil);
    } else if (fileInfo.error) {
        self.videoBtn.selected = YES;
        self.statusLabel.text = NSLocalizedString(@"DOWNLOAD_PAGE_ERROR", nil);;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChildWedgets];
        
    }
    return self;
}

- (void)setupChildWedgets
{
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    videoBtn.backgroundColor = [UIColor randomColor];
    [videoBtn setImage:[UIImage imageNamed:@"icon_down"] forState:UIControlStateNormal];
    [videoBtn setImage:[UIImage imageNamed:@"icon_stop"] forState:UIControlStateSelected];
    [videoBtn addTarget:self action:@selector(downloadOrPauseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:videoBtn];
    self.videoBtn = videoBtn;
    
    UILabel *videoNameLabel = [[UILabel alloc] init];
    videoNameLabel.textColor = colorWithRGB(67, 67, 67);
    videoNameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:videoNameLabel];
    self.videoNameLabel = videoNameLabel;
//    videoNameLabel.backgroundColor = [UIColor randomColor];
    
    UIProgressView *progress = [[UIProgressView alloc] init];
    progress.progressTintColor = colorWithRGB(109, 217, 241);
    progress.trackTintColor = colorWithRGB(209, 209, 209);
    [self.contentView addSubview:progress];
    self.progressView = progress;
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.font = [UIFont systemFontOfSize:12.0];
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.textColor = colorWithRGB(67, 67, 67);
    [self.contentView addSubview:statusLabel];
//    statusLabel.backgroundColor = [UIColor randomColor];
    self.statusLabel = statusLabel;
    
    UIView *separatorLine = [[UIView alloc] init];
    separatorLine.backgroundColor = colorWithRGB(240, 242, 245);
    [self.contentView addSubview:separatorLine];
    self.separatorLine = separatorLine;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.contentView.left).offset(kDownloadingCellStatusLabelH);
        make.width.equalTo(SMScreenWidth == 320 ? SmallVideoImageWith : BigVideoImageWith);
        make.height.equalTo((SMScreenWidth == 320 ? SmallVideoImageWith : BigVideoImageWith) * 9 / 16);
    }];
    
    [self.videoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoBtn.top).offset(kDownloadVideoMargin);
        make.left.equalTo(self.videoBtn.right).offset(kDownloadBottomMargin);
        make.right.equalTo(self.contentView.right).offset(-kDownloadingCellStatusLabelH);
        make.height.equalTo(kDownloadBottomStorageLabelH);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.videoNameLabel.bottom).offset(kDownloadVideoMargin);
        make.left.equalTo(self.videoNameLabel.left);
        make.right.equalTo(self.videoNameLabel.right);
        make.height.equalTo(kDownloadVideoMargin);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.bottom).offset(kDownloadVideoMargin);
        make.right.equalTo(self.progressView.right);
        make.width.equalTo(kDownloadingCellStatusLabelW);
        make.height.equalTo(kDownloadingCellStatusLabelH);
    }];
    
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left);
        make.bottom.equalTo(self.contentView.bottom);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(kDownloadSepLineH);
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)downloadOrPauseClick:(UIButton *)button
{
    button.userInteractionEnabled = NO;
    if (self.fileInfo.downloadState == ZFDownloading) {
        self.videoBtn.selected = YES;
        [[ZFDownloadManager sharedDownloadManager] stopRequest:self.request];
    } else {
        self.videoBtn.selected = NO;
        [[ZFDownloadManager sharedDownloadManager] resumeRequest:self.request];
    }
    if (self.downloadBlock) {
        self.downloadBlock();
    }
    button.userInteractionEnabled = YES;
}

- (void)setVideoButtonStatusWithSelection:(BOOL)selected
{
    self.videoBtn.selected = selected ? YES : NO;
}

@end
