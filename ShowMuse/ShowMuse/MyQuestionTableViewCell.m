//
//  MyQuestionTableViewCell.m
//  ShowMuse
//
//  Created by show zh on 16/5/20.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "MyQuestionTableViewCell.h"

@implementation MyQuestionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.titleLabel = [[UILabel alloc] init];
//    self.titleLabel.numberOfLines = 0;
//    self.titleLabel.tintColor = colorWithRGBA(82, 82, 83, 1);
//    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
////    self.titleLabel.text = self.model.title;
//    CGRect rect = [self.model.title boundingRectWithSize:CGSizeMake(SMScreenWidth-192-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
//    SMLog(@"高度是----%f------%@",rect.size.height,self.model.title);
//    if (rect.size.height > 75) {
//        rect.size.height = 75;
//    }
//    self.titleLabel.frame = CGRectMake(192, 22, SMScreenWidth-192-10, rect.size.height);
//    [self addSubview:self.titleLabel];
    
//    UILabel * la = [[UILabel alloc] initWithFrame:CGRectMake(192, 22, 20, 20)];
//    la.backgroundColor = [UIColor redColor];
//    [self addSubview:la];
}
//- (void)setFrame:(CGRect)frame {
//    float x = self.titleLabel.frame.origin.x;
//    float y = self.titleLabel.frame.origin.y;
//    float w = self.titleLabel.frame.size.width;
//    float h = self.titleLabel.frame.size.height;
//    if (self.titleLabel.frame.size.height > 75) {
//        h = 75;
//        self.titleLabel.frame = CGRectMake(x, y, w, h);
//        self.viewsTotalButton.frame = CGRectMake(192, 92, 70, 17);
//        CGRect pro = self.progressLabel.frame;
//        CGRect proview = self.progressView.frame;
//        pro.origin.y = 92;
//        proview.origin.y = 92;
//        self.progressLabel.frame = pro;
//        self.progressView.frame = proview;
//    }
//    [super setFrame:frame];
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
