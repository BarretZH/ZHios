//
//  UserDetailsNetWork.m
//  ShowMuse
//
//  Created by show zh on 16/5/23.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "UserDetailsNetWork.h"



#import "TokenManager.h"

@implementation UserDetailsNetWork

//获取用户信息
+(void)userDetailsWithUserDeta:(completeUserDeta)completeUserDeta {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@",[ShowMuseURLString URLStringWithPath:@"/v2/user/details"]];
    
//    NSDictionary * requestParameters = @{@"limit":@"10",@"offset":offset};
    
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    
    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeUserDeta) {
            completeUserDeta(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeUserDeta) {
            
            error = [ShowMuseURLString errorWithPerform:error];
            
            completeUserDeta(nil,error);
        }
    }];

}

//上传图片
+(AFHTTPRequestOperation* )PostRequestWithPicUrl:(NSString *)urlStr WithDict:(NSDictionary *)dict WithData:(NSArray* )images  ReturnData:(completeUserDeta)completeUserDeta {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *currentOperation = [[AFHTTPRequestOperation alloc] init];

    
    urlStr = [NSString stringWithFormat:@"%@",[ShowMuseURLString URLStringWithPath:@"/v2/user/details"]];
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];

//    NSMutableDictionary *para = [dict mutableCopy];
//    if (!dict) {
//        dict = [NSMutableDictionary dictionaryWithCapacity:1];
//    }
    //上传图片。
    currentOperation = [manager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //根据当前系统时间生成图片名称
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [formatter stringFromDate:date];
        //上传多张图片
        for (int i = 0; i<images.count; i++) {
            //图片名字
            NSString *fileName = [NSString stringWithFormat:@"%@-%d.png",dateString,i];
            UIImage* image = images[i];
            NSData* data = UIImageJPEGRepresentation(image, 1.0);
            //上传数据。
            [formData appendPartWithFileData:data name:@"profilePictureFile"  fileName:fileName mimeType:@"image/png"];
        }
        //        NSData* data = [NSData dataWithContentsOfFile:<#(nonnull NSString *)#>];
        //上传数据。
        /*[formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"multipart/form-data"];*/
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        //请求成功。
        if (completeUserDeta) {
            completeUserDeta(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求失败。
        if (completeUserDeta) {
            error = [ShowMuseURLString errorWithPerform:error];
            completeUserDeta(nil,error);
        }
    }];
    return currentOperation;
}


+(void)userDetailsWithDic:(NSDictionary *)dic Complete:(completeUserDeta)completeUserDeta {
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    NSString* URLString = [NSString stringWithFormat:@"%@",[ShowMuseURLString URLStringWithPath:@"/v2/user/details"]];
    
    //    NSDictionary * requestParameters = @{@"limit":@"10",@"offset":offset};
    
    NSString * bearer = [NSString stringWithFormat:@"Bearer %@",[TokenManager getToken]];
    [manager.requestSerializer setValue:bearer forHTTPHeaderField:@"Authorization"];
    [manager POST:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completeUserDeta) {
            completeUserDeta(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completeUserDeta) {
            
            error = [ShowMuseURLString errorWithPerform:error];
            
            completeUserDeta(nil,error);
        }
    }];
}




@end
