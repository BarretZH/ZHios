//
//  UserSubscriptionsNetWork.m
//  ShowMuse
//
//  Created by show zh on 16/5/25.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "UserSubscriptionsNetWork.h"

#import "ShowMuseURLString.h"

#import "TokenManager.h"


@implementation UserSubscriptionsNetWork

+(void)userSubscriptionsComplete:(completeUserSub)completeUserSub {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@",[ShowMuseURLString URLStringWithPath:@"/v2/user/subscriptions"]];
    

    
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeUserSub) {
            completeUserSub(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeUserSub) {
            
            error = [ShowMuseURLString errorWithPerform:error];
            
            completeUserSub(nil,error);
        }
    }];
}





@end
