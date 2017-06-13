//
//  MainNetWorking.m
//  ShowMuse
//
//  Created by show zh on 16/4/22.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "MainNetWorking.h"

#import "ShowMuseURLString.h"

#import "TokenManager.h"

#import "JPUSHService.h"

#import <AdSupport/AdSupport.h>

@implementation MainNetWorking


//版本更新
+ (void)versionUpdateComplete:(complete)complete {
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [ShowMuseURLString URLStringHost:@"/v2/app/preferences"];
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//获取用户手机唯一id
//    CFUUIDRef cfuuid =CFUUIDCreate(kCFAllocatorDefault);
    NSString *adId =[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];//获取手机的idfa
//    NSString *cfuuidString =(NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
//    NSString * jpushID = [JPUSHService registrationID];//获取极光的registrationID
    NSDictionary* requestParameters = @{@"deviceId":identifierStr,@"idfa":adId/*,@"jpushid":jpushID*/};
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




////第三方登录接口
//+ (void)thirdPartyLoginWithGrantType:(NSString *)grant_type UserID:(NSString *)user_id UserAccessToken:(NSString *)user_access_token Complete:(complete)complete {
//    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
//    
//    NSString* URLString = [ShowMuseURLString URLStringWithPath:@"/oauth/v2/token"];
//    
//    NSDictionary* requestParameters = @{@"grant_type":grant_type,@"user_id":user_id,@"user_access_token":user_access_token,@"client_id":@"1_63m9kupyk000g4skgko488w4ogog8g4cw8ocwo4s8wokowc080",@"client_secret":@"10fvv1yzpcjk4c4skcsg0k0gg48sk8cg4s8scckg0w8kk4kkcc"};
//    
//    [manager GET:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //返回内容
//        if (complete) {
//            complete(responseObject,nil);
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //返回错误信息
//        if (complete) {
//            complete(nil,error);
//        }
//
//    }];
//    
//    
//    
//}

//判断是否有新的导航页
+ (void)syncbannersComplete:(complete)complete {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [ShowMuseURLString URLStringWithPath:@"/v2/user/sync"];
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//获取用户手机唯一id
    NSDictionary* requestParameters = @{@"deviceId":identifierStr};
    //添加请求头
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    
    
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


//用户请求
+(void)userDataNetWorkComplete:(complete)complete {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [ShowMuseURLString URLStringWithPath:@"/v2/user/sync"];
    
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//获取用户手机唯一id
    
    NSString * jpushID = [JPUSHService registrationID];//获取极光的registrationID
    if (jpushID == nil) {
        jpushID = @"";
    }else {
    }
    NSDictionary* requestParameters = @{@"deviceId":identifierStr,@"jpushId":jpushID};
    
    //添加请求头
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    
    [manager POST:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (complete) {
            complete(responseObject,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (complete) {
            error = [ShowMuseURLString errorWithPerform:error];
            complete(nil,error);
        }
    }];
    
}

+(void)versionID {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://itunes.apple.com/lookup?id=1013698709" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *array = responseObject[@"results"];
        NSDictionary *dict = [array lastObject];
//        NSLog(@"当前版本为：%@", dict[@"version"]);
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:dict[@"version"] forKey:@"APPversion"];
        [userDefaults synchronize];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}
@end
