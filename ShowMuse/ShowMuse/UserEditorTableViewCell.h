//
//  UserEditorTableViewCell.h
//  ShowMuse
//
//  Created by show zh on 16/5/23.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserEditorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *userLabel;


//@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;


@property (weak, nonatomic) IBOutlet UIButton *sex_girButton;
@property (weak, nonatomic) IBOutlet UIButton *sex_boyButton;




@property (weak, nonatomic) IBOutlet UILabel *pictureLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;


@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end
