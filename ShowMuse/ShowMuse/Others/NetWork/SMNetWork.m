//
//  SMNetWork.m
//  ShowMuse
//
//  Created by ygliu on 9/13/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMNetWork.h"
#import "ShowMuseURLString.h"
#import "TokenManager.h"


@implementation SMNetWork

+ (void)sendRequestWithSessionManager:(AFHTTPSessionManager *)manager method:(NSString *)method pathComponentsArr:(NSArray *)pathComponentsArr parameters:(nullable id)paramters success:(SuccessWithResponseObject)successData failure:(FailureWithError)failureError
{
    NSString *path = pathComponentsArr[0];
    for (NSInteger i = 1; i < pathComponentsArr.count; i++) {
        path = [path stringByAppendingString:pathComponentsArr[i]];
    }
//    SMLog(@"-- path -- > %@", path);
    NSString *request = [ShowMuseURLString URLStringWithPath:path];
    NSString *bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    if ([method.uppercaseString isEqualToString:@"PUT"]) {
        [manager PUT:request parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
            successData(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failureError(task, error);
        }];
    } else if ([method.uppercaseString isEqualToString:@"GET"]) {
        [manager GET:request parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
            successData(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failureError(task, error);
        }];
    } else if ([method.uppercaseString isEqualToString:@"POST"]) {
        [manager POST:request parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
            successData(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failureError(task, error);
        }];
        
    } else if ([method.uppercaseString isEqualToString:@"DELETE"]) {
        [manager DELETE:request parameters:paramters success:^(NSURLSessionDataTask *task, id responseObject) {
            successData(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failureError(task, error);
        }];
    }
    
}

+ (void)sendRequestWithOperationManager:(nonnull AFHTTPRequestOperationManager *)manager method:(nonnull NSString *)method pathComponentsArr:(nonnull NSArray *)pathComponentsArr parameters:(nullable id)paramters success:(nullable SuccessAndResponseObject)successData failure:(nullable FailureAndError)failureError
{
    NSString *path = pathComponentsArr[0];
    for (NSInteger i = 1; i < pathComponentsArr.count; i++) {
        path = [path stringByAppendingString:pathComponentsArr[i]];
    }
    NSString *request = [ShowMuseURLString URLStringWithPath:path];
    NSString *bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    if ([method.uppercaseString isEqualToString:@"PUT"]) {
        [manager PUT:request parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (successData) { successData(operation, responseObject); }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failureError) {
                error = [ShowMuseURLString errorWithPerform:error];
                failureError(operation, error);
            }
        }];
    } else if ([method.uppercaseString isEqualToString:@"GET"]) {
        [manager GET:request parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (successData) { successData(operation, responseObject); }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failureError) {
                error = [ShowMuseURLString errorWithPerform:error];
                failureError(operation, error);
            }
        }];
    } else if ([method.uppercaseString isEqualToString:@"POST"]) {
        [manager POST:request parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (successData) { successData(operation, responseObject); }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failureError) {
                error = [ShowMuseURLString errorWithPerform:error];
                failureError(operation, error);
            }
        }];
    } else if ([method.uppercaseString isEqualToString:@"DELETE"]) {
        [manager DELETE:request parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (successData) { successData(operation, responseObject); }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failureError) {
                error = [ShowMuseURLString errorWithPerform:error];
                failureError(operation, error);
            }
        }];
    }
    
}

@end
