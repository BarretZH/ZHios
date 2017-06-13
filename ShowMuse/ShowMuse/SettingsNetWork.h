//
//  SettingsNetWork.h
//  ShowMuse
//
//  Created by show zh on 16/5/26.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^completeSetting)(id json, NSError* error);
@interface SettingsNetWork : NSObject


//退出登录
+(void)logOutWithComplete:(completeSetting)completeSetting;


//发送邀请码
+(void)redeemCodeShopWith:(NSString *)code Complete:(completeSetting)completeSetting;



//是否显示字幕
+(void)userSettingsDictionary:(NSDictionary *)requestParameters Complete:(completeSetting)completeSetting;

@end
