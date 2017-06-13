//
//  LoginNetWork.m
//  ShowMuse
//
//  Created by show zh on 16/4/22.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "LoginNetWork.h"


#import "ShowMuseURLString.h"

@implementation LoginNetWork


//第三方登录接口
+ (void)thirdPartyLoginWithGrantType:(NSString *)grant_type UserID:(NSString *)user_id UserAccessToken:(NSString *)user_access_token Complete:(complete)complete {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [ShowMuseURLString URLStringWithPath:@"/oauth/v2/token"];
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary* requestParameters = @{@"grant_type":grant_type,@"device_id":identifierStr,@"user_id":user_id,@"user_access_token":user_access_token,@"client_id":@"1_63m9kupyk000g4skgko488w4ogog8g4cw8ocwo4s8wokowc080",@"client_secret":@"10fvv1yzpcjk4c4skcsg0k0gg48sk8cg4s8scckg0w8kk4kkcc"};
    
    [manager GET:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //返回内容
        if (complete) {
            complete(responseObject,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //返回错误信息
        if (complete) {
            error = [ShowMuseURLString errorWithPerform:error];
            complete(nil,error);
        }
        
    }];
    
    
    
}

//游客登录
+ (void)guestLoginComplete:(complete)complete {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString *URLString = [ShowMuseURLString URLStringWithPath:@"/oauth/v2/token"];
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//获取用户手机唯一id
    NSDictionary *requestParameters = @{
                                        @"grant_type":@"guest",
                                        @"device_id":identifierStr,
                                        @"client_id":@"1_63m9kupyk000g4skgko488w4ogog8g4cw8ocwo4s8wokowc080",
                                        @"client_secret":@"10fvv1yzpcjk4c4skcsg0k0gg48sk8cg4s8scckg0w8kk4kkcc"
                                        };
    [manager GET:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //返回内容
        if (complete) {
            complete(responseObject,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //返回错误信息
        if (complete) {
            error = [ShowMuseURLString errorWithPerform:error];
            complete(nil,error);
        }
        
    }];
    
    
}
//账号登录
+ (void)accountLoginWithUserName:(NSString *)username password:(NSString *)password complete:(complete)complete {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString *URLString = [ShowMuseURLString URLStringWithPath:@"/oauth/v2/token"];
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary *requestParameters = @{
                                        @"grant_type":@"password",
                                        @"device_id":identifierStr,
                                        @"username":username,
                                        @"password":password,
                                        @"client_id":@"1_63m9kupyk000g4skgko488w4ogog8g4cw8ocwo4s8wokowc080",
                                        @"client_secret":@"10fvv1yzpcjk4c4skcsg0k0gg48sk8cg4s8scckg0w8kk4kkcc"
                                        };
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //返回内容
        if (complete) {
            complete(responseObject,nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //返回错误信息
        if (complete) {
            error = [ShowMuseURLString errorWithPerform:error];
            complete(nil,error);
        }
        
    }];
    
    
}


#pragma mark - 注册
+ (void)registerWithEmail:(NSString *)email password:(NSString *)password complete:(complete)complete {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [ShowMuseURLString URLStringWithPath:@"/v2/user/register"];
    
    NSDictionary* requestParameters = @{@"email":email,@"password":password};
    
    [manager POST:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //返回内容
        if (complete) {
            complete(responseObject,nil);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //返回错误信息
        if (complete) {
            error = [ShowMuseURLString errorWithPerform:error];
            complete(nil,error);
        }

    }];
    
    
}

#pragma mark - 忘记密码
+ (void)resetPasswordWithEmail:(NSString *)email complete:(complete)complete {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [ShowMuseURLString URLStringWithPath:@"/v2/user/reset-password"];
    
    NSDictionary* requestParameters = @{@"email":email};
    
    [manager POST:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //返回内容
        if (complete) {
            complete(responseObject,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //返回错误信息
        if (complete) {
            error = [ShowMuseURLString errorWithPerform:error];
            complete(nil,error);
        }
        
    }];

}




@end
