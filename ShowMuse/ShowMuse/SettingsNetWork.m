//
//  SettingsNetWork.m
//  ShowMuse
//
//  Created by show zh on 16/5/26.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "SettingsNetWork.h"

#import "ShowMuseURLString.h"

#import "TokenManager.h"


@implementation SettingsNetWork

//退出登录
+(void)logOutWithComplete:(completeSetting)completeSetting {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@",[ShowMuseURLString URLStringWithPath:@"/v2/user/logout"]];
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeSetting) {
            completeSetting(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeSetting) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeSetting(nil,error);
        }

    }];
}
//优惠码
+(void)redeemCodeShopWith:(NSString *)code Complete:(completeSetting)completeSetting {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@/%@",[ShowMuseURLString URLStringWithPath:@"/v2/shop/redeem"],[code stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    [manager PUT:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeSetting) {
            completeSetting(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeSetting) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeSetting(nil,error);
        }
        
    }];

}

//获取用户是否显示字幕
+(void)userSettingsDictionary:(NSDictionary *)requestParameters Complete:(completeSetting)completeSetting {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [ShowMuseURLString URLStringWithPath:@"/v2/user/settings"];
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    
//    NSDictionary* requestParameters = @{@"video_subtitles_on":video_subtitles_on};
    
    
    [manager POST:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeSetting) {
            completeSetting(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeSetting) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeSetting(nil,error);
        }
        
    }];

}




@end
