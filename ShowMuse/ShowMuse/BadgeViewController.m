//
//  BadgeViewController.m
//  ShowMuse
//
//  Created by show zh on 16/5/23.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "BadgeViewController.h"

#import "BadgeView.h"

#import "SMUserBadgesNetWork.h"
#import "AFNetworking.h"

#import "UserBadgesModel.h"

#import "UIImageView+WebCache.h"

#import "UIButton+WebCache.h"

#import "SMDialog.h"

#import "CourseDetailsWebViewController.h"

#import "CourseViewController.h"

#import "YGMasterMainViewController.h"

@interface BadgeViewController ()<SMDialogDelegate>{
    UIView * view;
    NSMutableArray * badgesArray;
    
    int first;
    
    UIView * bagview;
}

/** 弹框控件 */
@property (weak, nonatomic) SMDialog *dialog;
/** 吸附动画 */
@property (strong, nonatomic) UIDynamicAnimator *anim;
/** 发送网络请求 */
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;


@end

@implementation BadgeViewController
- (UIDynamicAnimator *)anim
{
    if (!_anim) {
        _anim = [[UIDynamicAnimator alloc] init];
    }
    return _anim;
}
- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [[AFHTTPRequestOperationManager alloc] init];
    }
    return _manager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    badgesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    first = 0;
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (first == 0) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height)];
        self.view.backgroundColor = [UIColor clearColor];
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
        
        if (badgesArray.count >0) {
            [badgesArray removeAllObjects];
        }
//        [SMUserBadgesNetWork userBadgesDataWithComplete:^(id json, NSError *error) {
//            
//            SMLog(@"-- json --- > %@", json);
//            if (error == nil) {
//                [json[@"badges"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    UserBadgesModel *badgesModel = [[UserBadgesModel alloc] initWithDictionary:obj];
//                    [badgesArray addObject:badgesModel];
//                }];
//                [self showBadgesUIWithArray:badgesArray];
//            }else {
//                [SMNavigationController modalGlobalLoginViewController];
//            }
//        }];
        
        [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/user/badges"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [responseObject[@"badges"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UserBadgesModel *badgesModel = [[UserBadgesModel alloc] initWithDictionary:obj];
                [badgesArray addObject:badgesModel];
            }];
            [self showBadgesUIWithArray:badgesArray];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SMNavigationController modalGlobalLoginViewController];
        }];

    }
    first++;
}



-(void)showBadgesUIWithArray:(NSMutableArray *)array {
    int width = 70;
//    if (SMScreenWidth == 320) {
//        width = 68;
//    }
//    int width = 70;
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:view.frame];
    scroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, badgesArray.count/4*(width+50)+20+width+30);
//    scroll.backgroundColor = [UIColor redColor];
    for (int i = 0; i<badgesArray.count; i++) {
        UserBadgesModel * badgesModel = badgesArray[i];
        int col = i%4;
        int row = i/4;
        float x = 15 +col*(width +(SMScreenWidth-30-width*4)/3);
        float y = 20 +row*(width +50);
        
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:badgesModel.img]];
        [scroll addSubview:imgView];
        
        
        BadgeView *halfChart = [[BadgeView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//        halfChart.isConcentric = YES;
//        halfChart.concentricRadius = 50;
        float angle = badgesModel.progress/100.00;
        [halfChart addAngleValue:angle andColor:[UIColor clearColor]/*UIColorFromRGB(0x3C60A3)*/];
        [halfChart addAngleValue:(1-angle) andColor:[UIColor colorWithWhite:1 alpha:0.9]];
        [halfChart resignFirstResponder];
        [imgView addSubview:halfChart];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = imgView.frame;
        button.tag = i;
        [button addTarget:self action:@selector(badgesButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:button];
        
        UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        titleButton.layer.cornerRadius = 10;
        if (badgesModel.isFinished) {
            titleButton.backgroundColor = [UIColor colorWithRed:65/255.0 green:198/255.0 blue:228/255.0 alpha:1];
        }else {
            if (badgesModel.progress == 0) {
                titleButton.backgroundColor = [UIColor colorWithRed:194/255.0 green:197/255.0 blue:204/255.0 alpha:1];
            }else {
                titleButton.backgroundColor = [UIColor colorWithRed:225/255.0 green:96/255.0 blue:75/255.0 alpha:1];
            }
        }
        titleButton.frame = CGRectMake(x, y+width+5, width, 20);
        [titleButton setTitle:badgesModel.progressTitle forState:UIControlStateNormal];
        [titleButton setTintColor:[UIColor whiteColor]];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(badgesButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:titleButton];
        


    }
    for (int i = 0; i<badgesArray.count/4; i++) {
        float x = 15;
        float y = width+60+(width+50)*i;

        UIView * vi = [[UIView alloc] initWithFrame:CGRectMake(x, y, [UIScreen mainScreen].bounds.size.width-2*x, 1)];
        vi.backgroundColor = [UIColor colorWithRed:220/255.0 green:225/255.0 blue:227/255.0 alpha:1];
        [scroll addSubview:vi];
    }

    
    [view addSubview:scroll];
}






#pragma mark - 徽章按钮点击方法
-(void)badgesButtonClick:(UIButton *)sender {
   
    bagview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bagview.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    bagview.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    [bagview addGestureRecognizer:tapGesture];
    [tapGesture setNumberOfTapsRequired:1];
    [[UIApplication sharedApplication].delegate.window addSubview:bagview];
    
    
    UserBadgesModel *badgesModel = badgesArray[sender.tag];
    UIImageView *imgview = [[UIImageView alloc] init];
    [imgview sd_setImageWithURL:[NSURL URLWithString:badgesModel.img]];

    
    SMDialog *dialog = [[SMDialog alloc] initWithImage:imgview.image contentText:badgesModel.progressDescription delegate:self leftButtonTitle:badgesModel.progressPopupBtnTitle rightButtonTitle:nil];
    dialog.leftButton.tag = sender.tag;
    BadgeView *halfChart = [[BadgeView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    float angle = badgesModel.progress/100.00;
    [halfChart addAngleValue:angle andColor:[UIColor clearColor]];
    [halfChart addAngleValue:(1-angle) andColor:[UIColor colorWithWhite:1 alpha:0.9]];
    [halfChart resignFirstResponder];
    [dialog.badgeView addSubview:halfChart];
    
    if (badgesModel.progress == 100) {
        [dialog.leftButton setBackgroundColor:colorWithRGB(65, 198, 228)];
    }else {
        [dialog.leftButton setBackgroundColor:colorWithRGB(225, 96, 75)];
    }
    
    [[UIApplication sharedApplication].delegate.window addSubview:dialog];
    UISnapBehavior *snapB = [[UISnapBehavior alloc] initWithItem:dialog snapToPoint:CGPointMake(SMScreenWidth * 0.5, SMScreenHeight * 0.39)];
    snapB.damping = 0.4;
    [self.anim addBehavior:snapB];
    self.dialog = dialog;

}

-(void)event:(UITapGestureRecognizer *)gesture {
    [bagview removeFromSuperview];
    [self.dialog removeFromSuperview];
}
#pragma mark - SMDialogDelegate
- (void)dialogCloseBtnDidClick:(UIButton *)button
{
    [bagview removeFromSuperview];
    [self.dialog removeFromSuperview];
}
- (void)dialogLeftButtonDidClick:(UIButton *)button {
    
    
    UserBadgesModel *badgesModel = badgesArray[button.tag];
    
//    SMLog(@"-- gotoUrl -- > %@ -- progress -- > %d tag --- > %d", badgesModel.gotoUrl, badgesModel.progress, button.tag);
    if (badgesModel.teacherID != 0) {
        if (badgesModel.progress == 100) {
            if (![badgesModel.gotoUrl isEqualToString:@""]) {
                //跳转web
                self.navigationController.navigationBar.alpha = 1;
                CourseDetailsWebViewController *VC = [[CourseDetailsWebViewController alloc] init];
                VC.titleStr = badgesModel.gotoUrlTitle;
                VC.urlStr = badgesModel.gotoUrl;
                [self.navigationController pushViewController:VC animated:YES];
            }
        }else {
            //跳转课程
            self.navigationController.navigationBar.alpha = 1;
            YGMasterMainViewController *VC = [[YGMasterMainViewController alloc] init];
            VC.teacherID = [NSString stringWithFormat:@"%d",badgesModel.teacherID];
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    }

    [bagview removeFromSuperview];
    [self.dialog removeFromSuperview];
}

@end
