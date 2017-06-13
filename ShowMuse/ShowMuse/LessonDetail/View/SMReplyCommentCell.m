//
//  SMReplyCommentCell.m
//  ShowMuse
//
//  Created by show zh on 16/11/1.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import "SMReplyCommentCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "SMDetailComment.h"

@interface SMReplyCommentCell ()
@property (weak, nonatomic) UIImageView *iconView;

@property (weak, nonatomic) UILabel *nameLabel;

@property (weak, nonatomic) UILabel *timeLabel;

@property (weak, nonatomic) UILabel *commentLabel;

//@property (weak, nonatomic) UIView *replyView;

@property (weak, nonatomic) UILabel *replyLabel_bg;

@property (weak, nonatomic) UIImageView *reply_iconView;

@property (weak, nonatomic) UILabel *reply_nameLabel;

@property (weak, nonatomic) UILabel *reply_timeLabel;

@property (weak, nonatomic) UILabel *reply_commentLabel;

@end
@implementation SMReplyCommentCell

- (void)setComment:(SMDetailComment *)comment
{
    _comment = comment;
//    [self removeFromSuperview];
//    [self.replyLabel_bg removeFromSuperview];
//    [self addChildWidgets];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:comment.userAvatar] placeholderImage:[UIImage imageNamed:@"head"]];
    self.nameLabel.text = comment.userName;
    self.timeLabel.text = comment.createdAt;
    self.commentLabel.text = comment.body;
    self.commentLabel.height = comment.bodyLabelH;
    
    self.replyLabel_bg.text = comment.children_body;
    self.replyLabel_bg.height = comment.children_bodyLabelH+50;
////
    [self.reply_iconView sd_setImageWithURL:[NSURL URLWithString:comment.children_userAvatar] placeholderImage:[UIImage imageNamed:@"head"]];
    self.reply_nameLabel.text = comment.children_userName;
    self.reply_timeLabel.text = comment.children_createdAt;
    self.reply_commentLabel.text = @"";
    self.reply_commentLabel.text = comment.children_body;
    self.reply_commentLabel.height = comment.children_bodyLabelH;
    
    
//    SMLog(@"*************%@",self.reply_nameLabel.text);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addChildWidgets];
        self.contentView.backgroundColor = colorWithRGB(238, 241, 243);
//        self.contentView.backgroundColor = [UIColor yellowColor];
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
    
    
    
    UILabel * replyLabel_bg = [[UILabel alloc] init];
    replyLabel_bg.backgroundColor = [UIColor whiteColor];
    replyLabel_bg.font = [UIFont systemFontOfSize:13];
    replyLabel_bg.numberOfLines = 0;
    replyLabel_bg.textColor = [UIColor clearColor];
    [self.contentView addSubview:replyLabel_bg];
    self.replyLabel_bg = replyLabel_bg;

    UILabel * replyLabel = [[UILabel alloc] init];
    replyLabel.font = [UIFont systemFontOfSize:13];
//    replyLabel.backgroundColor = [UIColor blackColor];
    replyLabel.numberOfLines = 0;
    replyLabel.text = NSLocalizedString(@"LESSONS_DETAILS_REPLY", nil);
    replyLabel.textColor = colorWithRGB(100, 100, 100);
    [self.contentView addSubview:replyLabel];
    
    UIImageView *reply_iconView = [[UIImageView alloc] init];
    reply_iconView.layer.cornerRadius = 20;
    reply_iconView.layer.masksToBounds = YES;
//    [self.contentView addSubview:iconView];
    [self.contentView addSubview:reply_iconView];
    self.reply_iconView = reply_iconView;
    
    UILabel * reply_nameLabel = [[UILabel alloc] init];
    reply_nameLabel.textColor = colorWithRGB(137, 141, 143);
    reply_nameLabel.font = [UIFont systemFontOfSize:10];
//    reply_nameLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:reply_nameLabel];
    
    self.reply_nameLabel = reply_nameLabel;
    
    UILabel *reply_timeLabel = [[UILabel alloc] init];
    reply_timeLabel.font = [UIFont systemFontOfSize:8];
    reply_timeLabel.textColor = colorWithRGB(137, 141, 143);
    [self.contentView addSubview:reply_timeLabel];
    self.reply_timeLabel = reply_timeLabel;
    
    UILabel *reply_commentLabel = [[UILabel alloc] init];
    reply_commentLabel.font = [UIFont systemFontOfSize:13];
    reply_commentLabel.backgroundColor = [UIColor clearColor];
    reply_commentLabel.text = @"";
    reply_commentLabel.numberOfLines = 0;
    reply_commentLabel.textColor = colorWithRGB(100, 100, 100);
    [self.contentView addSubview:reply_commentLabel];
    self.reply_commentLabel = reply_commentLabel;

    
    
    
    
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
//    sepLine.backgroundColor = [UIColor redColor];
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
//        make.height.mas_greaterThanOrEqualTo(@(20));
        make.bottom.mas_equalTo(replyLabel_bg.mas_top).offset(-5);
    }];
    
    
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(iconView.mas_leading);
        make.trailing.equalTo(timeLabel.mas_trailing);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [replyLabel_bg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(commentLabel.mas_bottom).offset(5);
        make.leading.mas_equalTo(commentLabel.mas_leading);
        make.trailing.mas_equalTo(commentLabel.mas_trailing);
        make.height.mas_greaterThanOrEqualTo(@(70));
        make.bottom.mas_equalTo(sepLine.mas_top).offset(-10);
    }];

    [replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(replyLabel_bg.mas_top).offset(5);
        make.leading.equalTo(replyLabel_bg.mas_leading).offset(10);
        make.trailing.equalTo(replyLabel_bg.mas_trailing).offset(0);
        make.height.mas_equalTo(@(15));
    }];
    
    [reply_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(replyLabel.mas_bottom).offset(0);
        make.leading.equalTo(replyLabel.mas_leading).offset(0);
        make.width.and.height.mas_equalTo(@(40));
    }];
    
    [reply_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(reply_iconView.mas_top);
        make.leading.mas_equalTo(reply_iconView.mas_trailing).offset(5);
        make.trailing.mas_equalTo(replyLabel_bg.mas_trailing).offset(-15);
        make.height.mas_equalTo(@(10));
    }];
    
    [reply_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(reply_nameLabel.mas_bottom);
        make.leading.mas_equalTo(reply_nameLabel.mas_leading);
        make.trailing.mas_equalTo(reply_nameLabel.mas_trailing);
        make.height.mas_equalTo(@(10));
    }];
    
    [reply_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(reply_timeLabel.mas_bottom);
        make.leading.mas_equalTo(reply_timeLabel.mas_leading);
        make.trailing.mas_equalTo(reply_timeLabel.mas_trailing);
        make.height.mas_greaterThanOrEqualTo(@(20));
        make.bottom.mas_equalTo(replyLabel_bg.mas_bottom).offset(-5);
    }];
    
    
    
    
}

@end
