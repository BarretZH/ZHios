//
//  LanguageViewController.m
//  ShowMuse
//
//  Created by show zh on 16/9/13.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import "LanguageViewController.h"

//#import "SettingsNetWork.h"
#import "AFNetworking.h"

#import "MBProgressHUD.h"

#import "AppDelegate.h"

@interface LanguageViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSArray *titleArr;
}


@property (nonatomic, retain) UITableView           *tableView;

@property (nonatomic, retain) UIView                *linView;

@property (nonatomic, assign) NSInteger             selectedRow;

@property (nonatomic, retain) NSString              *switchToLanguageCodeString;

@property (nonatomic, retain) NSString              *languageCodeString;
/** 发送网络请求 */
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;


@end

@implementation LanguageViewController
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
    
//    self.title = NSLocalizedString(@"SYSTEM_SETTINGS_LANGUAGE", nil);
//    
//    UIButton *liftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    liftButton.frame = CGRectMake(0, 0, 20, 18);
//    //    [menuBtn setBackgroundImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
//    [liftButton setBackgroundImage:[UIImage imageNamed:@"icon_details_back.png"] forState:UIControlStateNormal];
//    [liftButton addTarget:self action:@selector(goBackClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:liftButton];

    [self addnavigation];
    titleArr = @[@"English",@"简体中文",@"繁體中文"];
    self.view.backgroundColor = colorWithRGB(236, 241, 244);
    [self createTableView];
    
}
-(void)addnavigation {
    UILabel * titleLanel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLanel.text = NSLocalizedString(@"SYSTEM_SETTINGS_LANGUAGE", nil);
    titleLanel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:20];
    titleLanel.textAlignment = NSTextAlignmentCenter;
    titleLanel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLanel;

//    UIButton *liftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    liftButton.frame = CGRectMake(0, 0, 20, 18);
//    //    [menuBtn setBackgroundImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
//    [liftButton setBackgroundImage:[UIImage imageNamed:@"icon_details_back.png"] forState:UIControlStateNormal];
//    [liftButton addTarget:self action:@selector(goBackClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:liftButton];

}


- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SMScreenWidth, SMScreenHeight)
                                                  style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * str = @"cell2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    cell.backgroundColor = colorWithRGBA(236, 241, 244, 1);
    UIView * linView = [[UIView alloc] initWithFrame:CGRectMake(15, 43, SMScreenWidth-30, 1)];
    linView.backgroundColor = colorWithRGBA(226, 230, 233, 1);
    [cell addSubview:linView];
    
    cell.textLabel.text = titleArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textColor = colorWithRGBA(0, 0, 0, 0.8);
    
    
    switch (indexPath.row) {
        case 0: {
            _languageCodeString = @"en";
        }
            break;
        case 1: {
            _languageCodeString = @"zh-Hans";
        }
            break;
        case 2: {
            _languageCodeString = @"zh-Hant";
        }
            break;
            
        default:
            break;
    }
    NSString *currentLanguageString = [[NSUserDefaults standardUserDefaults] objectForKey:ACLanguageUtilLanguageIdentifier];
    if ([_languageCodeString isEqualToString:currentLanguageString]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedRow = indexPath.row;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRow inSection:0]];
    selectedCell.accessoryType = UITableViewCellAccessoryNone;
    UITableViewCell *newSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedRow = indexPath.row;
    newSelectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"EDIT_PROFILE_PAGE_DONE", nil)
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(switchButtonTapped)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    if (indexPath.row == 0) {
        self.switchToLanguageCodeString = @"en";
        _languageCodeString = @"en";
    }
    if (indexPath.row == 1) {
        self.switchToLanguageCodeString = @"zh_CN";
        _languageCodeString = @"zh-Hans";
    }
    if (indexPath.row == 2) {
        self.switchToLanguageCodeString = @"zh_HK";
        _languageCodeString = @"zh-Hant";
    }
}




#pragma mark - done
-(void)switchButtonTapped {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSDictionary * dic = @{@"interface_language":self.switchToLanguageCodeString};
//    [SettingsNetWork userSettingsDictionary:dic Complete:^(id json, NSError *error) {
//        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//        SMLog(@"%@*/*/*/*/*/*/*/*%@",json,error);
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        
//        [appDelegate reDrawAllUIForLanguage:_languageCodeString];
//        NSNotification *notification =[NSNotification notificationWithName:@"showText" object:nil userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//    }];
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"post" pathComponentsArr:@[@"/v2/user/settings"] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [appDelegate reDrawAllUIForLanguage:_languageCodeString];
        NSNotification *notification =[NSNotification notificationWithName:@"showText" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SMNavigationController modalGlobalLoginViewController];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
    

}
-(void)goBackClick {
    [self.navigationController popViewControllerAnimated:YES];
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
