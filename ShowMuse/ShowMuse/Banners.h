//
//  Banners.h
//  ShowMuse
//
//  Created by show zh on 16/6/6.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Banners : NSObject


@property (nonatomic) int ID;
@property (nonatomic) int showTimer;
@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * link;
-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
