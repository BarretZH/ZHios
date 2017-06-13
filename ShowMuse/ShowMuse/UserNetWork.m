//
//  UserNetWork.m
//  ShowMuse
//
//  Created by show zh on 16/5/20.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "UserNetWork.h"

#import "ShowMuseURLString.h"

#import "TokenManager.h"


@implementation UserNetWork

//课程列表请求
+(void)CouesesDetailsWithOffset:(NSString *)offset Complete:(completeUSER)completeUSER {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@",[ShowMuseURLString URLStringWithPath:@"/v2/user/lessons"]];
    
    NSDictionary * requestParameters = @{@"limit":@"10",@"offset":offset};
    
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    
    [manager GET:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeUSER) {
            completeUSER(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeUSER) {
            
            error = [ShowMuseURLString errorWithPerform:error];
            
            completeUSER(nil,error);
        }
    }];
}




@end
