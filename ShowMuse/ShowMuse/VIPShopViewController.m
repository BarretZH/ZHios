//
//  VIPShopViewController.m
//  ShowMuse
//
//  Created by show zh on 16/5/26.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "VIPShopViewController.h"
#import "VipShopTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ShopNetWork.h"
#import "ShopModel.h"
#import "WXApiObject.h"
#import "WXApi.h"
//#import "MainNetWorking.h"
#import "JPUSHService.h"
#import "TokenManager.h"
#import "MLIAPManager.h"
#import "SMDialog.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UserBadgesModel.h"
#import "PopupModel.h"

#import "ShowMuseURLString.h"

#import "PiwikTracker.h"


@interface VIPShopViewController ()<UITableViewDelegate,UITableViewDataSource,MLIAPManagerDelegate,SMDialogDelegate>

{
    NSMutableArray * shopModelArray;
    /**
     *  获取订单
     */
    NSString * orderNo;
    
    NSArray * paymentMethodsArray;
    
    NSArray * notesArray;
    
    UIView * bagview;
    
    NSInteger shopID;
}
/** 弹框控件 */
@property (weak, nonatomic) SMDialog *dialog;
/** 吸附动画 */
@property (strong, nonatomic) UIDynamicAnimator *anim;
/** 保存所有对话框 */
@property (strong, nonatomic) NSMutableArray *dialogArr;
/** 保存所有popup模型 */
@property (strong, nonatomic) NSMutableArray *popupArr;
/** 发送网络请求 */
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation VIPShopViewController
#pragma mark - lazy
- (UIDynamicAnimator *)anim
{
    if (!_anim) {
        _anim = [[UIDynamicAnimator alloc] init];
    }
    return _anim;
}

- (NSMutableArray *)dialogArr
{
    if (!_dialogArr) {
        _dialogArr = [NSMutableArray array];
    }
    return _dialogArr;
}

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [[AFHTTPRequestOperationManager alloc] init];
    }
    return _manager;
}

- (NSMutableArray *)popupArr
{
    if (!_popupArr) {
        _popupArr = [NSMutableArray array];
    }
    return _popupArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.alpha = 1.0;
    self.navigationController.navigationBar.translucent = NO;
    
    [[PiwikTracker sharedInstance] sendViews:@"shop", nil];
    
    self.titleLabel.text = NSLocalizedString(@"PURCHASE_PAGE_SUBSCRIPTION", nil);
    
    UILabel * titleLanel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLanel.text = NSLocalizedString(@"PURCHASE_PAGE_SUBSCRIBE_NOW", nil);
    titleLanel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:20];
    titleLanel.textAlignment = NSTextAlignmentCenter;
    titleLanel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLanel;

    [MLIAPManager sharedManager].delegate = self;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [_nameLabel setText:[userDefaults objectForKey:@"userName"]];
//    [_userButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"avatar"]] forState:UIControlStateNormal];
    self.userNameLabel.text = [userDefaults objectForKey:@"userName"];
//    [self.userImage sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"avatar"]]];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"head"]];
    
    if ([[userDefaults objectForKey:@"premium"] boolValue]) {
        //是会员
        [self.promptLabel setText:[userDefaults objectForKey:@"premiumTime"]];
    }else {
        
    }
    shopModelArray = [[NSMutableArray alloc] initWithCapacity:0];
//    [ShopNetWork shopSubscriptionsWithComplete:^(id json, NSError *error) {
//        if (error==nil) {
//            [json[@"subscriptions"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                ShopModel * shopModel = [[ShopModel alloc] initWithDictionary:obj];
//                [shopModelArray addObject:shopModel];
//                
//            }];
//            paymentMethodsArray = [[NSArray alloc] initWithArray:json[@"paymentMethods"]];
//            notesArray = [[NSArray alloc] initWithArray:json[@"notes"]];
//            [_tableView reloadData];
//        }
//    }];
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/shop/subscriptions"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [responseObject[@"subscriptions"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ShopModel * shopModel = [[ShopModel alloc] initWithDictionary:obj];
            [shopModelArray addObject:shopModel];
            
        }];
        paymentMethodsArray = [[NSArray alloc] initWithArray:responseObject[@"paymentMethods"]];
        notesArray = [[NSArray alloc] initWithArray:responseObject[@"notes"]];
        [_tableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SMNavigationController modalGlobalLoginViewController];
    }];
    
    // 注册微信支付回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePayResult:) name:@"weixin_pay_result" object:nil];
}

#pragma mark - 表代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return shopModelArray.count+notesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VipShopTableViewCell * cell = nil;
    if (indexPath.row<shopModelArray.count) {
        static NSString * str = @"cell";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"VipShopTableViewCell" owner:nil options:nil]objectAtIndex:0];
        }
        
        ShopModel * shopModel = shopModelArray[indexPath.row];
        cell.priceLabel.text = [NSString stringWithFormat:@"%d",shopModel.price];
        cell.RMBLabel.text = shopModel.currency;
        cell.titleLabel.text = shopModel.title;
        if (paymentMethodsArray.count > 0) {
            cell.gotoShopButton.alpha = 1;
            [cell.gotoShopButton addTarget:self action:@selector(gotoShopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.gotoShopButton.tag = indexPath.row;
        }else {
            cell.gotoShopButton.alpha = 0;
        }
        [cell.gotoShopButton setTitle:NSLocalizedString(@"PURCHASE_PAGE_SUBSCRIBE", nil) forState:UIControlStateNormal];

    }else {
        static NSString * str = @"cell_1";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"VipShopTableViewCell" owner:nil options:nil]objectAtIndex:1];
        }
        cell.textLabel.text = notesArray[indexPath.row-shopModelArray.count];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (indexPath.row<shopModelArray.count) {
        return 54;
    }else {
        CGRect rect=[notesArray[indexPath.row-shopModelArray.count] boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-28, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        return 32+ceilf(rect.size.height);
    }
    
}




#pragma mark - 去开通按钮

-(void)gotoShopButtonClick:(UIButton *)sender {
    
    shopID = sender.tag;
    
    if (paymentMethodsArray.count == 1) {
        ShopModel * shopModel = shopModelArray[shopID];
        [self appleStoreWith:shopModel];
    }
    if (paymentMethodsArray.count == 2) {
        
        bagview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        bagview.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        bagview.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
        [bagview addGestureRecognizer:tapGesture];
        [tapGesture setNumberOfTapsRequired:1];
        [[UIApplication sharedApplication].delegate.window addSubview:bagview];

        
        
        NSMutableDictionary *buttons = [NSMutableDictionary dictionary];
        buttons[@"微信"] = @"weixin";
//        buttons[@"支付宝"] = @"zhifubao";
        buttons[@"AppStore"] = @"apple";
        SMDialog *dialog = [[SMDialog alloc] initWithTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_PAID_BY", nil) contentButtons:buttons delegate:self leftButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) rightButtonTitle:nil];
        [[UIApplication sharedApplication].delegate.window addSubview:dialog];
        UISnapBehavior *snapB = [[UISnapBehavior alloc] initWithItem:dialog snapToPoint:CGPointMake(SMScreenWidth * 0.5, SMScreenHeight * 0.39)];
        snapB.damping = 0.4;
        [self.anim addBehavior:snapB];
        self.dialog = dialog;

    }
}
-(void)event:(UITapGestureRecognizer *)gesture {
    [bagview removeFromSuperview];
    [self.dialog removeFromSuperview];
}

#pragma mark - 苹果的内购
-(void)appleStoreWith:(ShopModel * )shopModel {
    [[PiwikTracker sharedInstance] sendEventWithCategory:@"click" action:@"pay" name:@"event_applestore" value:@(2)];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [ShopNetWork weixinpayWithProductID:shopModel.ID paymentGateway:@"applestore" complete:^(id json, NSError *error) {
        if (error == nil) {
            orderNo = json[@"order"][@"orderNo"];
            [[MLIAPManager sharedManager] requestProductWithId:json[@"order"][@"subscriptionId"]];
            
        }
    }];
    
}

#pragma mark - **************** MLIAPManager Delegate
- (void)receiveProduct:(SKProduct *)product {
    [bagview removeFromSuperview];
//
    if (product != nil) {
        //购买商品
        if (![[MLIAPManager sharedManager] purchaseProduct:product]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"您禁止了应用内购买权限,请到设置中开启" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
//            [alert show];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        }
    } else {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"失败" message:@"无法连接App store!" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
//        [alert show];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }
//    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

- (void)successfulPurchaseOfId:(NSString *)productId andReceipt:(NSData *)transactionReceipt {
    [bagview removeFromSuperview];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSString  *transactionReceiptString = [transactionReceipt base64EncodedStringWithOptions:0];
    if ([transactionReceiptString length] > 0) {
        // 向自己的服务器验证购买凭证（此处应该考虑将凭证本地保存,对服务器有失败重发机制）
        /**
         服务器要做的事情:
         接收ios端发过来的购买凭证。
         判断凭证是否已经存在或验证过，然后存储该凭证。
         将该凭证发送到苹果的服务器验证，并将验证结果返回给客户端。
         如果需要，修改用户相应的会员权限
         */
        NSDictionary * dic = @{@"paymentResult":transactionReceiptString};
//        [ShopNetWork weixinVerifyWithOrderNo:orderNo parameters:dic complete:^(id json, NSError *error) {
//            if (error == nil) {
//                NSDictionary * dic = json[@"order"];
//                int status = [dic[@"status"] intValue];
//                if (status == 5) {
//                    [self usersyncNetWork];
//                    // user sync
//                    [self GetUserSyncData];
//                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//                    [self showNoticeAfterpayMentWithText:NSLocalizedString(@"PAY_FOR_SUCCESS", nil)];
//                }
//            } else {
//                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//                [self showNoticeAfterpayMentWithText:NSLocalizedString(@"PAY_FOR_FAILURE", nil)];
//            }
//        }];
        [SMNetWork sendRequestWithOperationManager:self.manager method:@"post" pathComponentsArr:@[@"/v2/shop/order/",orderNo,@"/verify"] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * dic = responseObject[@"order"];
            int status = [dic[@"status"] intValue];
            if (status == 5) {
                [self usersyncNetWork];
                // user sync
                [self GetUserSyncData];
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                [self showNoticeAfterpayMentWithText:NSLocalizedString(@"PAY_FOR_SUCCESS", nil)];
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self showNoticeAfterpayMentWithText:NSLocalizedString(@"PAY_FOR_FAILURE", nil)];

        }];
        /*Pay for success ---Pay for failure*/
    }
}

- (void)failedPurchaseWithError:(NSString *)errorDescripiton {
    [bagview removeFromSuperview];
    [ShopNetWork weixinCancelWithOrderNo:orderNo complete:^(id json, NSError *error) {
    }];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}


#pragma mark - 调用微信支付
-(void)sendWXPay:(ShopModel * )shopModel {
    [[PiwikTracker sharedInstance] sendEventWithCategory:@"click" action:@"pay" name:@"event_wechat" value:@(2)];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [ShopNetWork weixinpayWithProductID:shopModel.ID paymentGateway:@"weixin" complete:^(id json, NSError *error) {
        if (error == nil) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"weixin" forKey:@"weixinpay"];
            [userDefaults synchronize];
            
            orderNo = json[@"order"][@"orderNo"];
            NSDictionary * dic = json[@"weixinPackage"];
            NSMutableString *stamp  = [dic objectForKey:@"timestamp"];
            PayReq *req = [[PayReq alloc] init];
            req.partnerId = [NSString stringWithFormat:@"%@",dic[@"partnerid"]]; //商家id
            req.prepayId = dic[@"prepayid"];//@"wx20160222181228eabc76df380849802454";//预支付订单
            req.package = dic[@"package"];  //@"Sign=WXPay";//扩展字段  暂填写固定值Sign=WXPay
            req.nonceStr = dic[@"noncestr"];//@"758d476b9ebdc37e698ccfbdbcd21906";//随机串，防重发
            req.timeStamp = stamp.intValue; //@"1456135948";//时间戳
            req.sign = dic[@"sign"];//@"61EC78AB39E256B2624D54C7E1390D70";//商家根据微信开放平台文档对数据做的签名
            req.openID = dic[@"appid"];
            [WXApi sendReq:req];
            [bagview removeFromSuperview];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        }
    }];
}



/**
 *  处理微信回调
 */
- (void)handlePayResult:(NSNotification *)note
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if ([note.object isEqualToString:@"成功"]) {
        [ShopNetWork weixinVerifyWithOrderNo:orderNo parameters:nil complete:^(id json, NSError *error) {
            
            if (json) {
                NSDictionary *dic = json[@"order"];
                int status = [dic[@"status"] intValue];
                if (status == 5) {
                    [self usersyncNetWork];
                    // user sync
                    [self GetUserSyncData];
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    [self showNoticeAfterpayMentWithText:NSLocalizedString(@"PAY_FOR_SUCCESS", nil)];
                }
            } else {
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                [self showNoticeAfterpayMentWithText:NSLocalizedString(@"PAY_FOR_FAILURE", nil)];
            }
        }];
        
    } else {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [self showNoticeAfterpayMentWithText:NSLocalizedString(@"PAY_FOR_FAILURE", nil)];
        [ShopNetWork weixinCancelWithOrderNo:orderNo complete:^(id json, NSError *error) {
        }];
       
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"weixinpay"];
    [userDefaults synchronize];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weixin_pay_result" object:nil];
}
#pragma mark - payment sussess
- (void)showNoticeAfterpayMentWithText:(NSString *)text
{
    MBProgressHUD *notice = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    notice.mode = MBProgressHUDModeText;
    notice.labelText = text;
    notice.yOffset = -40;
    [notice hide:YES afterDelay:2.0];
}

#pragma mark - 返回
-(void)goBackClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - user syncx相关方法
- (void)GetUserSyncData
{
    // 1.发送购买成功的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:SMVIPShopPurchaseSuccessNotification object:nil];
    // 2.计数器清零
    i = 0;
    [self.dialogArr removeAllObjects];
    NSString *urlStr = [ShowMuseURLString URLStringWithPath:@"/v2/user/sync"];
    NSString *bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [self.manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deviceId"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    params[@"badge"] = @(1);
    params[@"popup"] = @(1);
    [self.manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        SMLog(@"--- responseObject --- > %@", responseObject);
        // popup
        [self addPopupDialogWithData:responseObject];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

// 添加popup对话框
- (void)addPopupDialogWithData:(id)responseObject
{
    if (!responseObject[@"popup"]) return;
    for (NSDictionary *popupDict in responseObject[@"popup"]) {
        PopupModel *popup = [PopupModel PopupWithDict:popupDict];
        [self.popupArr addObject:popup];
        
        if ([popup.contentType isEqualToString:@"text"]) { // 纯文字
            SMDialog *textDialog = [[SMDialog alloc] initWithTitle:nil  content:popup.content delegate:self leftButtonTitle:@"OK" rightButtonTitle:nil];
            [self.dialogArr addObject:textDialog];
            if (self.dialogArr.count == 1) {
                [self addDialogToScreenWithUIDynamicItemName:textDialog dialog:textDialog];
            }
            
        } else if ([popup.contentType isEqualToString:@"url"]) { // url
            SMDialog *urlDialog = [[SMDialog alloc] initWithTitle:nil htmlString:popup.content delegate:self leftbuttonTitle:@"OK" rightButtonTitle:nil];
            [self.dialogArr addObject:urlDialog];
            if (self.dialogArr.count == 1) {
                [self addDialogToScreenWithUIDynamicItemName:urlDialog dialog:urlDialog];
            }
            
        } else if ([popup.contentType isEqualToString:@"html"]) { // html
            SMDialog *htmlDialog = [[SMDialog alloc] initWithTitle:nil htmlString:popup.content delegate:self leftbuttonTitle:@"OK" rightButtonTitle:nil];
            [self.dialogArr addObject:htmlDialog];
            if (self.dialogArr.count == 1) {
                [self addDialogToScreenWithUIDynamicItemName:htmlDialog dialog:htmlDialog];
            }
        }
    }
}

/**
 *  添加一个对话框到屏幕上
 */
- (void)addDialogToScreenWithUIDynamicItemName:(id)UIDynamicItemName dialog:(SMDialog *)dialog
{
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:UIDynamicItemName snapToPoint:CGPointMake(SMScreenWidth * 0.5, SMScreenHeight * 0.39)];
    [self.anim addBehavior:snap];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.view.userInteractionEnabled = NO;
    self.navigationController.view.userInteractionEnabled = NO;
    [keyWindow addSubview:dialog];
}

#pragma mark - SMDialogDelegate
static int i = 0;
- (void)dialogCloseBtnDidClick:(UIButton *)button
{
    if (self.dialog) { // 支付方式弹框
        [bagview removeFromSuperview];
        [self.dialog removeFromSuperview];
    }
    // 提示信息弹框
    if (i < self.dialogArr.count) {
        // 删除view
        SMDialog *dialog = [self.dialogArr objectAtIndex:i];
        [dialog removeFromSuperview];
        self.view.userInteractionEnabled = YES;
        self.navigationController.view.userInteractionEnabled = YES;
        i++;
        if (i <= self.dialogArr.count - 1) {
            // 加View
            SMDialog *dialogNext = [self.dialogArr objectAtIndex:i];
            [self addDialogToScreenWithUIDynamicItemName:dialogNext dialog:dialogNext];
        }
    }
    
}

- (void)dialogLeftButtonDidClick:(UIButton *)button
{
    [self dialogCloseBtnDidClick:button];
    
}

// 提醒信息弹框
- (void)dialogRightButtonDidClick:(UIButton *)button
{
    [self dialogCloseBtnDidClick:button];
}

//支付方式按钮
- (void)dialogContentButtonDidClick:(UIButton *)button
{
    
    ShopModel * shopModel = shopModelArray[shopID];
    if (button.tag == 0) {
        [self appleStoreWith:shopModel];
    }
    if (button.tag == 1) {
        ShopModel *shopModel = shopModelArray[shopID];
        [self sendWXPay:shopModel];
        
    }
    [self.dialog removeFromSuperview];
}


-(void)usersyncNetWork {
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//获取用户手机唯一id
    
    NSString * jpushID = [JPUSHService registrationID];//获取极光的registrationID
    if (jpushID == nil) {
        jpushID = @"";
    }else {
    }
    NSDictionary* requestParameters = @{@"deviceId":identifierStr,@"jpushId":jpushID};
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"post" pathComponentsArr:@[@"/v2/user/sync"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = responseObject;
        [TokenManager saveUserdataWithDictionary:dic];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [self.promptLabel setText:[userDefaults objectForKey:@"premiumTime"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


@end
