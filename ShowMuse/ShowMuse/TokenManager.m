//
//  TokenManager.m
//  ShowMuse
//
//  Created by show zh on 16/4/26.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "TokenManager.h"
#import "JPUSHService.h"

@implementation TokenManager


//存token
+(void)saveToken:(NSString *)token
{
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:token forKey:@"access_token"];
    
    [userDefaults setBool:YES forKey:@"firstStart"];//登录后
    
    [userDefaults synchronize];
}

//取token
+(NSString *)getToken
{
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString * access_token=[userDefaults objectForKey:@"access_token"];
    return access_token;
}

//删除token
+(void)deleteDataToken
{
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"access_token"];
    [userDefaults synchronize];

}

//存guset
+(void)saveeGuest:(BOOL)guest {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:guest forKey:@"guest"];
    [userDefaults synchronize];
}


//取guest
+(BOOL)getGuest {
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    
    BOOL guest = [[userDefaults objectForKey:@"guest"] boolValue];
    
    return guest;
}


+(void)saveUserDataWithName:(NSString *)name avatar:(NSString*)avatar premium:(NSString *)premium premiumStart:(NSString *)premiumStart premiumStop:(NSString *)premiumStop be_a_teacher_url:(NSString *)be_a_teacher_url messages:(NSArray *)messages messagesTotal:(NSInteger)messagesTotal premiumTime:(NSString *)premiumTime teacher_title:(NSString *)teacher_title{
    
//    [TokenManager saveUserDataWithName:json[@"account"][@"name"] avatar:json[@"account"][@"avatar"] premium:json[@"account"][@"premium"] premiumStart:json[@"account"][@"premiumStart"] premiumStop:json[@"account"][@"premiumStop"] be_a_teacher_url:json[@"menu_extra_link"][@"url"] messages:json[@"messages"] messagesTotal:[json[@"messagesTotal"] integerValue] premiumTime:json[@"account"][@"premiumTime"] teacher_title:json[@"menu_extra_link"][@"title"]];
//    NSDictionary * dic = [[NSDictionary alloc] init];
//    NSDictionary * accountDic = dic[@"account"];
//    NSString * name = accountDic[@"name"];
//    NSString * avatar = accountDic[@"avatar"];
//    BOOL premium = [accountDic[@"premium"] boolValue];
//    NSString * be_a_teacher_url = dic[@"menu_extra_link"][@"url"];
//    NSString * premiumTime = accountDic[@"premiumTime"];
//    NSString * teacher_title = dic[@"menu_extra_link"][@"title"];
//    NSInteger  messagesTotal = [dic[@"messagesTotal"] integerValue];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:name forKey:@"userName"];
    [userDefaults setObject:avatar forKey:@"avatar"];
    [userDefaults setObject:premium forKey:@"premium"];
//    [userDefaults setObject:premiumStart forKey:@"premiumStart"];
//    [userDefaults setObject:premiumStop forKey:@"premiumStop"];
    [userDefaults setObject:be_a_teacher_url forKey:@"be_a_teacher_url"];
    [userDefaults setObject:messages forKey:@"messages"];
//    [userDefaults setObject:messagesTotal forKey:@"messagesTotal"];
    [userDefaults setInteger:messagesTotal forKey:@"messagesTotal"];
    [userDefaults setObject:premiumTime forKey:@"premiumTime"];
    [userDefaults setObject:teacher_title forKey:@"teacher_title"];
    [userDefaults synchronize];
}


+(void)saveUserdataWithDictionary:(NSDictionary *)dic {
    NSDictionary * accountDic = dic[@"account"];
    NSString * name = accountDic[@"name"];
    NSString * avatar = accountDic[@"avatar"];
    BOOL premium = [accountDic[@"premium"] boolValue];
    BOOL user_sync_guest = [accountDic[@"guest"] boolValue];
    NSString * be_a_teacher_url = dic[@"menu_extra_link"][@"url"];
    NSString * premiumTime = accountDic[@"premiumTime"];
    NSString * teacher_title = dic[@"menu_extra_link"][@"title"];
    NSInteger  messagesTotal = [dic[@"messagesTotal"] integerValue];
    NSString * video_subtitles_on = dic[@"settings"][@"video_subtitles_on"];
    NSString * auto_play_on_wifi = dic[@"settings"][@"auto_play_on_wifi"];
    NSInteger user_ID = [accountDic[@"id"] integerValue];
    
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger userID = [[userDefaults objectForKey:@"user_ID"] integerValue];
//    SMLog(@"%ld----------userID---------%ld",userID,user_ID);
    if (userID == user_ID) {
        SMLog(@"123");
    }else {
        SMLog(@"456");
        [JPUSHService setTags:nil aliasInbackground:[NSString stringWithFormat:@"%ld",(long)user_ID]];
    }
    
    
    [userDefaults setObject:name forKey:@"userName"];
    [userDefaults setObject:avatar forKey:@"avatar"];
    [userDefaults setObject:be_a_teacher_url forKey:@"be_a_teacher_url"];
    [userDefaults setInteger:messagesTotal forKey:@"messagesTotal"];
    [userDefaults setObject:premiumTime forKey:@"premiumTime"];
    [userDefaults setObject:teacher_title forKey:@"teacher_title"];
    [userDefaults setBool:premium forKey:@"premium"];
    [userDefaults setBool:user_sync_guest forKey:@"user_sync_guest"];
    [userDefaults setObject:video_subtitles_on forKey:@"video_subtitles_on"];
    [userDefaults setObject:auto_play_on_wifi forKey:@"isContinuous"];
    [userDefaults setInteger:user_ID forKey:@"user_ID"];
    
    
    [userDefaults synchronize];
    
}


@end
