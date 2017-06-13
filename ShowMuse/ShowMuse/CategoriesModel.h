//
//  CategoriesModel.h
//  ShowMuse
//
//  Created by show zh on 16/6/20.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoriesModel : NSObject<NSCoding>
@property (copy,nonatomic) NSString * iconImg;

@property (nonatomic) int ID;

@property (nonatomic) int totalNew;

@property (copy, nonatomic) NSString * title;
-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
