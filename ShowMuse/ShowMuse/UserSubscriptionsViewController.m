//
//  UserSubscriptionsViewController.m
//  ShowMuse
//
//  Created by show zh on 16/5/25.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "UserSubscriptionsViewController.h"

#import "UserSubscriptionsTableViewCell.h"

//#import "UserSubscriptionsNetWork.h"
#import "AFNetworking.h"

#import "UserSubscriptionsModel.h"

#import "VIPShopViewController.h"

@interface UserSubscriptionsViewController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView * _tableView;
    
    NSMutableArray * subscriptionsArray;
    
    int first;
}

@property (strong, nonatomic) UIButton * btn;
/** 发送网络请求 */
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation UserSubscriptionsViewController
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
    subscriptionsArray = [[NSMutableArray alloc] initWithCapacity:0];
    first = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRequestData:) name:SMVIPShopPurchaseSuccessNotification object:nil];
}







-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (first == 0) {
        self.view .backgroundColor = [UIColor clearColor];
        
        _btn = [UIButton buttonWithType:UIButtonTypeSystem];
        _btn.backgroundColor = [UIColor clearColor];
        _btn.frame = CGRectMake(0, 0, SMScreenWidth, self.view.bounds.size.height-20);
        [_btn setTitle:NSLocalizedString(@"SUBSCRIBE_NOW", nil) forState:UIControlStateNormal];
        [_btn setTitleColor:colorWithRGB(167, 167, 167) forState:UIControlStateNormal];
        _btn.alpha = 0;
        [_btn addTarget:self action:@selector(gotoVIPshop:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btn];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height-20) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 60;
        [self.view addSubview:_tableView];
        
        
        [self userSubscriptionNetWorking];

    }
    first++;
}

#pragma mark - 发请求
-(void)userSubscriptionNetWorking {
    if (subscriptionsArray.count > 0) {
        [subscriptionsArray removeAllObjects];
    }
//    [UserSubscriptionsNetWork userSubscriptionsComplete:^(id json, NSError *error) {
//        if (error == nil) {
//            [json[@"subscriptions"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                UserSubscriptionsModel * userSubscriptionsModel = [[UserSubscriptionsModel alloc] initWithDictionary:obj];
//                [subscriptionsArray addObject:userSubscriptionsModel];
//                
//            }];
//            if ([json[@"subscriptions"] count] > 0) {
//                [self.btn setAlpha:0];
//                _tableView.alpha = 1;
//                [_tableView reloadData];
//            }else {
//                [self.btn setAlpha:1];
//                _tableView.alpha = 0;
//            }
//            
//        }
//    }];
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/user/subscriptions"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [responseObject[@"subscriptions"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UserSubscriptionsModel * userSubscriptionsModel = [[UserSubscriptionsModel alloc] initWithDictionary:obj];
            [subscriptionsArray addObject:userSubscriptionsModel];
            
        }];
        if ([responseObject[@"subscriptions"] count] > 0) {
            [self.btn setAlpha:0];
            _tableView.alpha = 1;
            [_tableView reloadData];
        }else {
            [self.btn setAlpha:1];
            _tableView.alpha = 0;
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark - 通知方法
- (void)reloadRequestData:(NSNotification *)note {
    [self userSubscriptionNetWorking];
}

#pragma mark - 表代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return subscriptionsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * str = @"cell";
    UserSubscriptionsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"UserSubscriptionsTableViewCell" owner:nil options:nil]objectAtIndex:0];
    }
    UserSubscriptionsModel * userSubscriptionsModel = subscriptionsArray[indexPath.row];
    cell.amountLabel.text = [NSString stringWithFormat:@"%d",userSubscriptionsModel.amount];
    cell.currencyLabel.text = userSubscriptionsModel.currency;
    cell.createdAtLabel.text = userSubscriptionsModel.createdAt;
    cell.titleLabel.text = userSubscriptionsModel.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}





#pragma mark - 跳转购买界面
- (void)gotoVIPshop:(UIButton *)sender {
    self.navigationController.navigationBar.alpha = 1;
    VIPShopViewController * VC = [[VIPShopViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
