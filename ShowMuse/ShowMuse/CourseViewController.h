//
//  CourseViewController.h
//  ShowMuse
//
//  Created by show zh on 16/5/11.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Courses;

@interface CourseViewController : UIViewController

@property (strong, nonatomic) Courses *courses;

@property (strong, nonatomic) NSMutableArray *lessonGroupsArray;

@property (copy, nonatomic) NSString *ID;

@end
