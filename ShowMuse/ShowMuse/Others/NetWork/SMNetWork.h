//
//  SMNetWork.h
//  ShowMuse
//
//  Created by ygliu on 9/13/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager, AFHTTPRequestOperationManager, AFHTTPRequestOperation;

typedef void(^SuccessWithResponseObject)(NSURLSessionDataTask *task, id responeObjct);
typedef void(^FailureWithError)(NSURLSessionDataTask *task, NSError *error);

typedef void(^SuccessAndResponseObject)(AFHTTPRequestOperation *operation, id responseObject);
typedef void(^FailureAndError)(AFHTTPRequestOperation *operation, NSError *error);

@interface SMNetWork : NSObject
/**
 *  发送网络请求的方法
 *
 *  @param method            请求类型
 *  @param pathComponentsArr 子路径包装成数组传进来
 *  @param paramters         参数
 *  @param successData       成功时的回调
 *  @param failureError      失败时的回调
 */
+ (void)sendRequestWithSessionManager:(AFHTTPSessionManager *)manager method:(NSString *)method pathComponentsArr:(NSArray *)pathComponentsArr parameters:(id)paramters success:(SuccessWithResponseObject)successData failure:(FailureWithError)failureError;
+ (void)sendRequestWithOperationManager:(AFHTTPRequestOperationManager *)manager method:(NSString *)method pathComponentsArr:(NSArray *)pathComponentsArr parameters:(id)paramters success:(SuccessAndResponseObject)successData failure:(FailureAndError)failureError;
@end
