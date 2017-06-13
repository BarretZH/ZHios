//
//  CategroriesNetWork.m
//  ShowMuse
//
//  Created by show zh on 16/6/20.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import "CategroriesNetWork.h"

#import "ShowMuseURLString.h"

#import "TokenManager.h"

@implementation CategroriesNetWork


+(void)categoriesLessonWithID:(NSString *)ID offset:(NSString *)offset Complete:(completeCategrories)completeCategrories {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@/%@/lessons",[ShowMuseURLString URLStringWithPath:@"/v2/categories"],ID];
    
    NSDictionary* requestParameters = @{@"limit":@"10",@"offset":offset};
    
    //添加请求头
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    
    [manager GET:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeCategrories) {
            completeCategrories(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeCategrories) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeCategrories(nil,error);
        }
    }];

}


@end
