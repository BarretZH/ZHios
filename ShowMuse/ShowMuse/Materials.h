//
//  Materials.h
//  ShowMuse
//
//  Created by show zh on 16/8/18.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Materials : NSObject
@property (strong, nonatomic)NSString * url, * title;
-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
