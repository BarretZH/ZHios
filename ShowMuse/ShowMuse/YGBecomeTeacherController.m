//
//  YGBecomeTeacherController.m
//  ShowMuse
//
//  Created by liuyonggang on 12/5/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import "YGBecomeTeacherController.h"

#import "MBProgressHUD.h"

@interface YGBecomeTeacherController () <UIWebViewDelegate>

@property(weak, nonatomic) UIWebView *webView;

@end

@implementation YGBecomeTeacherController

- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    webView.delegate = self;
    self.view = webView;
    self.webView = webView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSString *urlStr= [[NSUserDefaults standardUserDefaults] objectForKey:@"be_a_teacher_url"];
    NSURL *url = [NSURL URLWithString:urlStr];

    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    NSString *teaTitle= [[NSUserDefaults standardUserDefaults] objectForKey:@"teacher_title"];
//    self.title = teaTitle;
    
    UILabel * titleLanel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLanel.text = teaTitle;
    titleLanel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:20];
    titleLanel.textAlignment = NSTextAlignmentCenter;
    titleLanel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLanel;
    
    
}
#pragma mark - web代理
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView  didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UIWebViewDelegate


@end
