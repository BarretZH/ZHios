//
//  ShopModel.h
//  ShowMuse
//
//  Created by show zh on 16/5/26.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject

/**
 *  ID
 */
@property (nonatomic,copy) NSString * ID;
/**
 *  RMB
 */
@property (nonatomic,copy) NSString * currency;
/**
 *  价格
 */
@property (nonatomic) int price;
/**
 *  标题
 */
@property (nonatomic,copy) NSString * title;


-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
