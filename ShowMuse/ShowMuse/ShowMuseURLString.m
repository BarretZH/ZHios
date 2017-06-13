//
//  ShowMuseURLString.m
//  ShowMuse
//
//  Created by show zh on 16/4/22.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "ShowMuseURLString.h"

//NSString* const HOST = @"http://api.dev.showmuse.so";

@implementation ShowMuseURLString

//   app/preferences请求的地址
+ (NSString *)URLStringHost:(NSString *)path {
//    SMLog(@"------->HOST<------------%@",[NSString stringWithFormat:@"%@%@", HOST, path]);
    return [NSString stringWithFormat:@"%@%@", HOST, path];
}
//其余请求的地址
+ (NSString *)URLStringWithPath:(NSString* )path {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * host = [userDefaults objectForKey:@"URL_HOST"];
//    SMLog(@"-- fullPath -- > %@%@", host, path);
    return [NSString stringWithFormat:@"%@%@", host, path];
}


+ (NSError *)errorWithPerform:(NSError *)error {
    
    NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
    NSDictionary * dic = [self parse:ErrorResponse];
    error = (NSError *)dic;
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    if ([dic[@"error"] isEqualToString:@"invalid_grant"]) {
        
        [userDefaults setObject:@"invalid_grant" forKey:@"invalid_grant"];
        
    }
    if (error == nil) {
        [userDefaults setObject:@"NO" forKey:@"network"];
    }
    [userDefaults synchronize];
    return error;
}


+ (NSDictionary *)parse:(NSString *)jsonString  {
    //    if ([NSString isNullOrEmptyString:jsonString])  {return nil;}
    
    return [self parseJSONData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
}

//--------------------------------------------------------------------------------------------------
+ (NSDictionary *)parseJSONData:(NSData *)jsonData  {
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error != nil)  {
        //        BZDLog(@"### %@", error);
        return nil;
    }
    
    return jsonObject;
}


@end
