//
//  CourseDetailsWebViewController.m
//  ShowMuse
//
//  Created by show zh on 16/5/17.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "CourseDetailsWebViewController.h"

#import "MBProgressHUD.h"

@interface CourseDetailsWebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *backItem;

@property (strong, nonatomic) UIBarButtonItem *closeItem;

@end

@implementation CourseDetailsWebViewController

- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(openOrCloseLeftList)];
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"WEBVIEW_PAGE_CLOSE", nil) style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    }
    return _closeItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * titleLanel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLanel.text = self.titleStr;
    titleLanel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:20];
    titleLanel.textAlignment = NSTextAlignmentCenter;
    titleLanel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLanel;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.productsWebView loadRequest:request];
    
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 1;
}
#pragma mark - web代理
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView  didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark - 导航左侧返回按钮
- (void)openOrCloseLeftList
{
    if (_isdeeplink) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        if ([self.productsWebView canGoBack]) {
            [self.productsWebView goBack];
            self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - 按钮点击
- (void)close
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
