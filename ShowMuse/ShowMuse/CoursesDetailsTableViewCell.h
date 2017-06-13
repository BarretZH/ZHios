//
//  CoursesDetailsTableViewCell.h
//  ShowMuse
//
//  Created by show zh on 16/5/16.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CoursesDetailsCellDelegate <NSObject>

@optional
- (void)courseDetailDownloadButtonDidClick:(UIButton *)button;

@end

@interface CoursesDetailsTableViewCell : UITableViewCell
#pragma mark - cell0
@property (weak, nonatomic) IBOutlet UIImageView *bagImage;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *openVIPButton;




#pragma mark - cell1
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;



#pragma mark - cell2
@property (weak, nonatomic) IBOutlet UIButton *teacherImage;
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *productsButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIImageView *downloadImage;





#pragma mark - cell3
@property (weak, nonatomic) IBOutlet UIView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *recommendedLabel;


#pragma mark - cell4
@property (weak, nonatomic) IBOutlet UILabel *numCommentableLabel;

@property (weak, nonatomic) IBOutlet UILabel *CommentsLabel;


#pragma mark - cell5
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImage;
@property (weak, nonatomic) IBOutlet UILabel *useerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;




@property (nonatomic,weak) id<CoursesDetailsCellDelegate> delegate;

@end
