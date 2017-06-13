//
//  ShopNetWork.m
//  ShowMuse
//
//  Created by show zh on 16/5/26.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "ShopNetWork.h"

#import "ShowMuseURLString.h"

#import "TokenManager.h"



@implementation ShopNetWork


+(void)shopSubscriptionsWithComplete:(completeShop)completeShop {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@",[ShowMuseURLString URLStringWithPath:@"/v2/shop/subscriptions"]];
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeShop) {
            completeShop(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeShop) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeShop(nil,error);
        }
    }];

}


+(void)weixinpayWithProductID:(NSString *)productId paymentGateway:(NSString *)paymentGateway complete:(completeShop)completeShop {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSError *error;
    NSString* URLString = [NSString stringWithFormat:@"%@",[ShowMuseURLString URLStringWithPath:@"/v2/shop/order"]];
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    NSString * type = @"application/json";
    [manager.requestSerializer setValue:type forHTTPHeaderField:@"Content-Type"];
    NSDictionary * dic = @{@"productId":productId,@"paymentGateway":paymentGateway};
   
//    NSDictionary *parameters= [NSDictionary dictionaryWithObjectsAndKeys:[dic JSONString],@"json",nil];
    [manager PUT:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeShop) {
            completeShop(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeShop) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeShop(nil,error);
        }
    }];
    
}

+(void)weixinVerifyWithOrderNo:(NSString *)orderNo parameters:(NSDictionary *)requestParameters complete:(completeShop)completeShop {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@%@/verify",[ShowMuseURLString URLStringWithPath:@"/v2/shop/order/"],orderNo];
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    [manager POST:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeShop) {
            completeShop(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeShop) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeShop(nil,error);
        }
    }];
}


+(void)weixinCancelWithOrderNo:(NSString *)orderNo complete:(completeShop)completeShop {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@%@/cancel",[ShowMuseURLString URLStringWithPath:@"/v2/shop/order/"],orderNo];
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    [manager PATCH:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeShop) {
            completeShop(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeShop) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeShop(nil,error);
        }
    }];

}






@end
