//
//  PopupModel.h
//  ShowMuse
//
//  Created by show zh on 16/6/12.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopupModel : NSObject

@property(nonatomic,copy)NSString * contentType;

@property(nonatomic,copy)NSString * content;

- (instancetype)initWithDictionary:(NSDictionary* )dictionary;

+ (instancetype)PopupWithDict:(NSDictionary *)dict;
@end
