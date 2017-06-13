//
//  DetailsNetWork.m
//  ShowMuse
//
//  Created by show zh on 16/5/16.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "DetailsNetWork.h"
#import "ShowMuseURLString.h"
#import "TokenManager.h"

@implementation DetailsNetWork

+(void)lessoDetailsWithLessonID:(NSString *)lessonID CompleteLessonDetails:(completeLessonDetails)completeLessonDetails {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
//    AFURLSessionManager
    NSString *request = [NSString stringWithFormat:@"%@%@",[ShowMuseURLString URLStringWithPath:@"/v2/lessons/"],lessonID];
    NSString *bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    [manager GET:request parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completeLessonDetails) {
            completeLessonDetails(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeLessonDetails) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeLessonDetails(nil,error);
        }
    }];
}
//获取其他视频
+(void)lessonSuggestedwithLessonID:(NSString *)lessonID CompleteLessonDetails:(completeLessonDetails)completeLessonDetails {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@%@/suggested",[ShowMuseURLString URLStringWithPath:@"/v2/lessons/"],lessonID];
    
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeLessonDetails) {
            completeLessonDetails(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeLessonDetails) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeLessonDetails(nil,error);
        }
    }];

}


//点赞
+(void)lessonLikeLessonID:(NSString *)lessonID CompleteLessonDetails:(completeLessonDetails)completeLessonDetails {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@%@/like",[ShowMuseURLString URLStringWithPath:@"/v2/lessons/"],lessonID];
    
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    [manager PUT:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeLessonDetails) {
            completeLessonDetails(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeLessonDetails) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeLessonDetails(nil,error);
        }

    }];
}

//取消点赞
+(void)lessonDelLikeLessonID:(NSString *)lessonID CompleteLessonDetails:(completeLessonDetails)completeLessonDetails {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@%@/like",[ShowMuseURLString URLStringWithPath:@"/v2/lessons/"],lessonID];
    
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    [manager DELETE:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeLessonDetails) {
            completeLessonDetails(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeLessonDetails) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeLessonDetails(nil,error);
        }
        
    }];
}


//评论请求
+(void)commentsWithCommentsID:(NSString *)ID CompleteLessonDetails:(completeLessonDetails)completeLessonDetails {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@%@/comments",[ShowMuseURLString URLStringWithPath:@"/v2/lessons/threads/"],ID];
    
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeLessonDetails) {
            completeLessonDetails(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeLessonDetails) {
//            NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
//            //            [self parseJSONString:ErrorResponse];
//            
//            NSDictionary * dic = [self parse:ErrorResponse];
//            error = (NSError *)dic;
            error = [ShowMuseURLString errorWithPerform:error];
            completeLessonDetails(nil,error);
        }
    }];
}

//发送评论
+(void)sendCommentsWithMessage:(NSString *)Str CommentsID:(NSString *)ID CompleteLessonDetails:(completeLessonDetails)completeLessonDetails {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@%@/comments",[ShowMuseURLString URLStringWithPath:@"/v2/lessons/threads/"],ID];
    
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    
    NSDictionary* requestParameters = @{@"fos_comment_comment[body]":Str};
    
    [manager POST:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeLessonDetails) {
            completeLessonDetails(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeLessonDetails) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeLessonDetails(nil,error);
        }
    }];

}

//分享回调
+(void)shareWithStatus:(NSString *)status platform:(NSString *)platform lessonID:(NSString *)lessonID CompleteLessonDetails:(completeLessonDetails)completeLessonDetails {
    NSString * channel = @"";
    if ([platform isEqualToString:@"22"]) {
        channel = @"wechat";
    }
    if ([platform isEqualToString:@"10"]) {
        channel = @"facebook";
    }
    if ([platform isEqualToString:@"43"]) {
        channel = @"whatsapp";
    }
    if ([platform isEqualToString:@"23"]) {
        channel = @"wechatmoments";
    }
    if ([platform isEqualToString:@"37"]) {
        channel = @"wechatfavorite";
    }
    if ([platform isEqualToString:@"1"]) {
        channel = @"sinaweibo";
    }
    if ([platform isEqualToString:@"19"]) {
        channel = @"sms";
    }
    if ([platform isEqualToString:@"18"]) {
        channel = @"email";
    }
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@/%@/share",[ShowMuseURLString URLStringWithPath:@"/v2/lessons"],lessonID];
    
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    NSDictionary* requestParameters = @{@"status":status,@"channel":channel};
    
    [manager PUT:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeLessonDetails) {
            completeLessonDetails(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeLessonDetails) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeLessonDetails(nil,error);
        }
    }];
}

@end
