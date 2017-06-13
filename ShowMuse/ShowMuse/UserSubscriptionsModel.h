//
//  UserSubscriptionsModel.h
//  ShowMuse
//
//  Created by show zh on 16/5/25.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSubscriptionsModel : NSObject

@property (nonatomic) int amount;


@property (nonatomic,copy) NSString * currency, * createdAt, * title;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
