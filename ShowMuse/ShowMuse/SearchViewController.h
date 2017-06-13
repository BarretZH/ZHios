//
//  SearchViewController.h
//  ShowMuse
//
//  Created by show zh on 16/5/30.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic) BOOL isTeacher;

@property (nonatomic) int categoriesID;
@end
