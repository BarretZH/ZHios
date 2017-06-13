//
//  SMUserBadges.m
//  ShowMuse
//
//  Created by show zh on 16/5/30.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "SMUserBadgesNetWork.h"

#import "ShowMuseURLString.h"

#import "TokenManager.h"



@implementation SMUserBadgesNetWork

+(void)userBadgesDataWithComplete:(completeUserBadges)completeUserBadges {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *URLString = [NSString stringWithFormat:@"%@",[ShowMuseURLString URLStringWithPath:@"/v2/user/badges"]];
    NSString *bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeUserBadges) {
            completeUserBadges(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeUserBadges) {
            
            error = [ShowMuseURLString errorWithPerform:error];
            completeUserBadges(nil,error);
        }
    }];

}


@end
