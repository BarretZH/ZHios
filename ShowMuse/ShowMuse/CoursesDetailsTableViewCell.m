//
//  CoursesDetailsTableViewCell.m
//  ShowMuse
//
//  Created by show zh on 16/5/16.
//  Copyright © 2016年 show zh. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "CoursesDetailsTableViewCell.h"
#import "Masonry.h"

@implementation CoursesDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.downloadBtn.backgroundColor = [UIColor randomColor];
//    [self.downloadBtn setTitle:@"下载中" forState:UIControlStateDisabled];
//    self.downloadBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [self.downloadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [self.downloadButton addTarget:self action:@selector(downloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)downloadButtonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(courseDetailDownloadButtonDidClick:)]) {
        [self.delegate courseDetailDownloadButtonDidClick:self.downloadButton];
    }
}

@end
