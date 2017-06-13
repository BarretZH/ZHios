//
//  SMDownloadedCell.m
//  ShowMuse
//
//  Created by ygliu on 7/29/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#define SmallVideoImageWith 80
#define BigVideoImageWith 100

#import "SMDownloadedCell.h"
#import "Masonry.h"
#import "ZFFileModel.h"

@interface SMDownloadedCell ()

@property (nonatomic,weak) UIButton *videoBtn;

@property (nonatomic,weak) UILabel *videoNameLabel;

@property (nonatomic,weak) UIView *separatorLine;

@end

@implementation SMDownloadedCell
#pragma mark - setter
- (void)setFileInfo:(ZFFileModel *)fileInfo
{
    _fileInfo = fileInfo;
    self.videoNameLabel.text = fileInfo.fileName;
    [self.videoBtn setBackgroundImage:fileInfo.fileimage forState:UIControlStateNormal];
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
    UIButton *videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    videoBtn.backgroundColor = [UIColor randomColor];
    [videoBtn setImage:[UIImage imageNamed:@"icon_download_play"] forState:UIControlStateNormal];
    [videoBtn addTarget:self action:@selector(downloadedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:videoBtn];
    self.videoBtn = videoBtn;
    
    UILabel *videoNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:videoNameLabel];
    videoNameLabel.textColor = colorWithRGB(67, 67, 67);
    videoNameLabel.font = [UIFont systemFontOfSize:14];
    self.videoNameLabel = videoNameLabel;
    
    UIView *separatorLine = [[UIView alloc] init];
    separatorLine.backgroundColor = colorWithRGB(240, 242, 245);
    [self.contentView addSubview:separatorLine];
    self.separatorLine = separatorLine;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(kDownloadingCellStatusLabelH);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(SMScreenWidth == 320 ? SmallVideoImageWith : BigVideoImageWith);
        make.height.equalTo((SMScreenWidth == 320 ? SmallVideoImageWith : BigVideoImageWith) * 9 / 16);
    }];
    
    [self.videoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.left.equalTo(self.videoBtn.right).offset(kDownloadBottomMargin);
        make.right.equalTo(self.contentView.right).offset(-kDownloadingCellStatusLabelH);
        make.height.equalTo(kDownloadBottomStorageLabelH);
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

- (void)downloadedButtonClick:(UIButton *)button
{
    if (self.playBlock) {
        self.playBlock();
    }
}

@end
