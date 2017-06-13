//
//  SMCommentCell.m
//  ShowMuse
//
//  Created by ygliu on 9/16/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMCommentCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "SMDetailComment.h"

@interface SMCommentCell ()

@property (weak, nonatomic) UIImageView *iconView;

@property (weak, nonatomic) UILabel *nameLabel;

@property (weak, nonatomic) UILabel *timeLabel;

@property (weak, nonatomic) UILabel *commentLabel;

@end

@implementation SMCommentCell

- (void)setComment:(SMDetailComment *)comment
{
    _comment = comment;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:comment.userAvatar] placeholderImage:[UIImage imageNamed:@"head"]];
    self.nameLabel.text = comment.userName;
    self.timeLabel.text = comment.createdAt;
    self.commentLabel.text = comment.body;
    self.commentLabel.height = comment.bodyLabelH;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addChildWidgets];
        self.contentView.backgroundColor = colorWithRGB(238, 241, 243);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)addChildWidgets
{
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.layer.cornerRadius = 20;
    iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = colorWithRGB(137, 141, 143);
    nameLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:8];
    timeLabel.textColor = colorWithRGB(137, 141, 143);
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.font = [UIFont systemFontOfSize:13];
    commentLabel.numberOfLines = 0;
    commentLabel.textColor = colorWithRGB(100, 100, 100);
    [self.contentView addSubview:commentLabel];
    self.commentLabel = commentLabel;
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:sepLine];

    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.leading.equalTo(self.contentView.mas_leading).offset(15);
        make.width.and.height.mas_equalTo(@(40));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconView.mas_top);
        make.leading.mas_equalTo(iconView.mas_trailing).offset(5);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-15);
        make.height.mas_equalTo(@(10));
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom);
        make.leading.mas_equalTo(nameLabel.mas_leading);
        make.trailing.mas_equalTo(nameLabel.mas_trailing);
        make.height.mas_equalTo(@(10));
    }];
    
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeLabel.mas_bottom);
        make.leading.mas_equalTo(timeLabel.mas_leading);
        make.trailing.mas_equalTo(timeLabel.mas_trailing);
        make.height.mas_greaterThanOrEqualTo(@(20));
        make.bottom.mas_equalTo(sepLine.mas_top).offset(-10);
    }];
    
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(iconView.mas_leading);
        make.trailing.equalTo(timeLabel.mas_trailing);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

@end
