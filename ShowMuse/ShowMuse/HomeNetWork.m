//
//  HomeNetWork.m
//  ShowMuse
//
//  Created by show zh on 16/5/6.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "HomeNetWork.h"

#import "ShowMuseURLString.h"

#import "TokenManager.h"

@implementation HomeNetWork


//course请求
//问题请求
+(void)questionNetWorkWithOffset:(NSString *)offset Complete:(completeHome)completeHome {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [ShowMuseURLString URLStringWithPath:@"/v2/courses"];
    
    NSDictionary* requestParameters = @{@"limit":@"10",@"offset":offset,@"withGroups":@"1"};
    
    //添加请求头
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];

//    NSString* phoneModel = [[UIDevice currentDevice] model];
//    [manager.requestSerializer setValue:phoneModel forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    
    [manager GET:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeHome) {
            completeHome(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeHome) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeHome(nil,error);
        }
    }];
    
}



//大师请求
+(void)teachersNetWorkComplete:(completeHome)completeHome {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [ShowMuseURLString URLStringWithPath:@"/v2/teachers"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //添加请求头
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    
    
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeHome) {
            completeHome(operation,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeHome) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeHome(nil,error);
        }
    }];


}

//用户请求
+(void)userDataNetWorkComplete:(completeHome)completeHome {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [ShowMuseURLString URLStringWithPath:@"/v2/teachers"];
    
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//获取用户手机唯一id
    NSDictionary* requestParameters = @{@"deviceId":identifierStr};
    
    //添加请求头
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    
    [manager POST:URLString parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeHome) {
            completeHome(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeHome) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeHome(nil,error);
        }
    }];
    
}

/**
 *  获取主页banners图
 *
 *
 */
+(void)fullScreenBannersComplete:(completeHome)completeHome {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [ShowMuseURLString URLStringWithPath:@"/v2/ads/full-screen-banners"];
    //添加请求头
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeHome) {
            completeHome(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeHome) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeHome(nil,error);
        }
    }];
}
/**
 *  告诉服务器干过的banner
 *
 *  @param ID           banner ID
 *
 */
+(void)postFullScreenBannersID:(NSString *)ID Complete:(completeHome)completeHome {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@/%@/read",[ShowMuseURLString URLStringWithPath:@"/v2/ads/full-screen-banners"],ID];
    //添加请求头
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    [manager POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeHome) {
            completeHome(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeHome) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeHome(nil,error);
        }
    }];

}

//菜单分类请求
+(void)caregoriesComplete:(completeHome) completeHome {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [ShowMuseURLString URLStringWithPath:@"/v2/categories"];
    //添加请求头
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeHome) {
            completeHome(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeHome) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeHome(nil,error);
        }
    }];

}

//点击关注发送请求
+(void)favouritesTeacherWithisPUT:(BOOL)isPUT teacherID:(NSString *)teacherID Complete:(completeHome) completeHome {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@/%@/favourites",[ShowMuseURLString URLStringWithPath:@"/v2/teachers"],teacherID];
    //添加请求头
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    if (isPUT) {
        [manager PUT:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (completeHome) {
                completeHome(responseObject,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (completeHome) {
                error = [ShowMuseURLString errorWithPerform:error];
                completeHome(nil,error);
            }
        }];
    }else {
        [manager DELETE:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (completeHome) {
                completeHome(responseObject,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (completeHome) {
                error = [ShowMuseURLString errorWithPerform:error];
                completeHome(nil,error);
            }
        }];

    }

}


@end
