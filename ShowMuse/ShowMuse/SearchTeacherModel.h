//
//  SearchTeacherModel.h
//  ShowMuse
//
//  Created by show zh on 16/7/12.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchTeacherModel : NSObject

@property (nonatomic) int ID;

@property (nonatomic) BOOL isFavourite;

@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString * introduction;

@property (nonatomic, copy) NSString * avatar;

@property (nonatomic, copy) NSString * coverImg;


-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
