//
//  UserPageViewController.m
//  ShowMuse
//
//  Created by show zh on 16/5/19.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "UserPageViewController.h"

#import "MyQuestionViewController.h"

#import "UIButton+WebCache.h"

#import "UIImageView+WebCache.h"

#import "UserEditorViewController.h"

#import "UserSubscriptionsViewController.h"

#import "SMAvatarBrowser.h"

#import "BadgeViewController.h"



@interface UserPageViewController ()<UIScrollViewDelegate>
//{
//    UIScrollView *footScrollView;
//}

/** 底部滚动的区域 */
@property (strong, nonatomic) UIScrollView *footScrollView;

@end

@implementation UserPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * str = [userDefaults objectForKey:@"avatar"];
    [self.userAvatarImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"head"]];
    
    
    
    [self showUIScrollView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.bagImageHeight setConstant:SMScreenWidth*200/375];
//    self.navigationController.navigationBarHidden = YES;
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
//    [menuBtn setBackgroundImage:[UIImage imageNamed:@"icon_details_back.png"] forState:UIControlStateNormal];
//    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];

    
    self.navigationController.navigationBar.alpha = 0;
//    self.navigationController.navigationBar.translucent = NO;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString * userimageURL = [userDefaults objectForKey:@"avatar"];
    NSString * userName = [userDefaults objectForKey:@"userName"];
    self.userNameLabel.text = userName;
    if (![userimageURL isEqualToString:@""]) {
//        [self.userImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:userimageURL] forState:UIControlStateNormal];
//        [self.userAvatarImage sd_setImageWithURL:[NSURL URLWithString:userimageURL]];
        [self.userAvatarImage sd_setImageWithURL:[NSURL URLWithString:userimageURL] placeholderImage:[UIImage imageNamed:@"head"]];
        [self.userImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:userimageURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"head"]];
        [self.userImageButton addTarget:self action:@selector(magnifyImage) forControlEvents:UIControlEventTouchUpInside];
        
        
        //        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
        //        [self.userAvatarImage addGestureRecognizer:tap];
        
        
    }
    [self.myQuestionButton setTitle:NSLocalizedString(@"USER_CENTER_PAGE_MY_BADGES", nil) forState:UIControlStateNormal];
    [self.myBadgeButton setTitle:NSLocalizedString(@"USER_CENTER_PAGE_MY_TOPICS", nil) forState:UIControlStateNormal];
    [self.myConsumeButton setTitle:NSLocalizedString(@"USER_CENTER_PAGE_RECORDS", nil) forState:UIControlStateNormal];
    if (self.isDeeplink) {
        [self buttonClickNumber:self.numberID];
        self.deeplink = NO;
    }
}

#pragma mark - 滑动视图
-(void)showUIScrollView {
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, /*self.footView.bounds.size.height-50*/SMScreenHeight-SMScreenWidth*200/375-50)];
    
    scrollView.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < 3; i++) {
        
        if (i == 1) {
            MyQuestionViewController * tabviewVC = [[MyQuestionViewController alloc] init];
            tabviewVC.view.frame = CGRectMake(SMScreenWidth*i, 0, SMScreenWidth, scrollView.bounds.size.height);
            [scrollView addSubview:tabviewVC.view];
            
            [self addChildViewController:tabviewVC];
            [tabviewVC didMoveToParentViewController:self];
        }
        
        if (i == 2) {
            UserSubscriptionsViewController * tabviewVC = [[UserSubscriptionsViewController alloc] init];
            tabviewVC.view.frame = CGRectMake(SMScreenWidth*i, 0, SMScreenWidth, scrollView.bounds.size.height);
            [scrollView addSubview:tabviewVC.view];
            
            [self addChildViewController:tabviewVC];
            [tabviewVC didMoveToParentViewController:self];
        }
        
        if (i == 0) {
            BadgeViewController * badgeVC = [[BadgeViewController alloc] init];
            badgeVC.view.frame = CGRectMake(SMScreenWidth*i, 0, SMScreenWidth, scrollView.bounds.size.height);
            [scrollView addSubview:badgeVC.view];
            
            [self addChildViewController:badgeVC];
            [badgeVC didMoveToParentViewController:self];

        }
        
        
    }
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(SMScreenWidth*3, /*self.footView.bounds.size.height-50*/SMScreenHeight-SMScreenWidth*200/375-50);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.footView addSubview:scrollView];
    self.footScrollView = scrollView;
    
}



#pragma mark - 三个按钮
- (IBAction)myButtonClick:(UIButton *)sender {
    
    [self buttonClickNumber:sender.tag];
}

-(void)buttonClickNumber:(NSInteger)number {
    SMLog(@"dianjileanniu----------%ld",(long)number);
    [self.myQuestionButton setTitleColor:colorWithRGB(167, 167, 167) forState:UIControlStateNormal];
    [self.myBadgeButton setTitleColor:colorWithRGB(167, 167, 167) forState:UIControlStateNormal];
    [self.myConsumeButton setTitleColor:colorWithRGB(167, 167, 167) forState:UIControlStateNormal];
    if (number == 200) {
        [self.myQuestionButton setTitleColor:colorWithRGB(86, 213, 225) forState:UIControlStateNormal];
        self.footScrollView.contentOffset = CGPointMake(0, 0);
    }
    if (number == 100) {
        [self.myBadgeButton setTitleColor:colorWithRGB(86, 213, 225) forState:UIControlStateNormal];
        self.footScrollView.contentOffset = CGPointMake(SMScreenWidth, 0);
    }
    if (number == 300) {
        [self.myConsumeButton setTitleColor:colorWithRGB(86, 213, 225) forState:UIControlStateNormal];
        self.footScrollView.contentOffset = CGPointMake(SMScreenWidth*2, 0);
    }

}

#pragma mark - UIScrollViewDelegate
//滑动视图将要开始减速时调用，
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"____scrollViewWillBeginDecelerating_____%f",scrollView.contentOffset.x);
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0) {
        [self.myQuestionButton setTitleColor:colorWithRGB(86, 213, 225) forState:UIControlStateNormal];
        [self.myBadgeButton setTitleColor:colorWithRGB(167, 167, 167) forState:UIControlStateNormal];
        [self.myConsumeButton setTitleColor:colorWithRGB(167, 167, 167) forState:UIControlStateNormal];
    }
    if (scrollView.contentOffset.x == SMScreenWidth) {
        [self.myBadgeButton setTitleColor:colorWithRGB(86, 213, 225) forState:UIControlStateNormal];
        [self.myQuestionButton setTitleColor:colorWithRGB(167, 167, 167) forState:UIControlStateNormal];
        [self.myConsumeButton setTitleColor:colorWithRGB(167, 167, 167) forState:UIControlStateNormal];
    }
    if (scrollView.contentOffset.x == SMScreenWidth*2) {
        [self.myConsumeButton setTitleColor:colorWithRGB(86, 213, 225) forState:UIControlStateNormal];
        [self.myBadgeButton setTitleColor:colorWithRGB(167, 167, 167) forState:UIControlStateNormal];
        [self.myQuestionButton setTitleColor:colorWithRGB(167, 167, 167) forState:UIControlStateNormal];
    }
}


#pragma mark - 返回
- (IBAction)gobackButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 编辑资料
- (IBAction)editorButtonClick:(id)sender {
    
    UserEditorViewController * VC = [[UserEditorViewController alloc] init];
//    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    [self.navigationController pushViewController:VC animated:YES];
}



- (void)magnifyImage
{
//    UIImageView * imageView = [[UIImageView alloc] init];
//    imageView.image
    [SMAvatarBrowser showImage:self.userAvatarImage];//头像放大
}


@end
