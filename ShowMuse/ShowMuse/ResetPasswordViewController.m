//
//  ResetPasswordViewController.m
//  ShowMuse
//
//  Created by show zh on 16/5/5.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "ResetPasswordViewController.h"

#import "LoginNetWork.h"

#import "AFNetworking.h"


@interface ResetPasswordViewController ()
/** 发送网络请求 */
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation ResetPasswordViewController
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
    self.emailTextField.placeholder = NSLocalizedString(@"LOGIN_EMAIL", nil);
    self.emailTextField.tintColor = [UIColor whiteColor];
    [_emailTextField setValue:[UIColor colorWithRed:199/255.0 green:194/255.0 blue:191/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_emailTextField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [_emailTextField addTarget:self  action:@selector(emailTextChange:)  forControlEvents:UIControlEventAllEditingEvents];
    self.resetLabel.text = NSLocalizedString(@"LOGIN_RESET_PASSWORD", nil);
    [self.emailButton setTitle:NSLocalizedString(@"LOGIN_EMAIL_CONFIRMATION", nil) forState:UIControlStateNormal];
}




#pragma mark - 返回
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 按钮
- (IBAction)registerButtonClick:(id)sender {
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    if ([predicate evaluateWithObject:_emailTextField.text]) {
        [LoginNetWork resetPasswordWithEmail:_emailTextField.text complete:^(id json, NSError *error) {
            if (json != nil) {
//                [self showAlert:json[@"message"]];
                [self showAlertView:json[@"message"]];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                if (error) {
                    NSDictionary * dic = (NSDictionary *)error;
                    //                [self showAlert:dic[@"message"]];
                    [self showAlertView:dic[@"message"]];
                }else {
                    [SMNavigationController modalGlobalLoginViewController];
                }
            }
        }];
//        NSDictionary* requestParameters = @{@"email":_emailTextField.text};
//        [SMNetWork sendRequestWithOperationManager:self.manager method:@"post" pathComponentsArr:@[@"/v2/user/reset-password"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [self showAlertView:responseObject[@"message"]];
//            [self.navigationController popViewControllerAnimated:YES];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            if (error) {
//                NSDictionary * dic = (NSDictionary *)error;
//                //                [self showAlert:dic[@"message"]];
//                [self showAlertView:dic[@"message"]];
//            }else {
//                [SMNavigationController modalGlobalLoginViewController];
//            }
//        }];
    }else {
        [self showMessage:@"邮箱格式不正确"];
    }
    
    
}


#pragma mark - 清除按钮
- (IBAction)clearButtonClick:(UIButton *)sender {
    _emailTextField.text = @"";
    sender.alpha = 0;
}

#pragma mark - 输入框的方法
-(void)emailTextChange:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        _emailClearButton.alpha = 0;
    }else {
        _emailClearButton.alpha = 1;
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



#pragma mark - 提示
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}


- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}


-(void)showAlertView:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil) otherButtonTitles:nil, nil] show];
}


//提示文字
-(void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake((self.view.bounds.size.width - LabelSize.width - 20)/2, /*self.view.bounds.size.height - */100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:2.0 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
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
