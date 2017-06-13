//
//  CourseDetailsWebViewController.h
//  ShowMuse
//
//  Created by show zh on 16/5/17.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CourseDetailsWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *productsWebView;

@property (copy, nonatomic) NSString *urlStr;

@property (copy, nonatomic) NSString *titleStr;

@property (nonatomic) BOOL isdeeplink;

@end
