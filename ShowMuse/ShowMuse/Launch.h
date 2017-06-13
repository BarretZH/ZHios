//
//  Launch.h
//  ShowMuse
//
//  Created by show zh on 16/4/28.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Launch : NSObject

@property (nonatomic,strong) NSString * url;

@property (nonatomic,strong) NSString * ID;


- (id)initWithDictionary:(NSDictionary* )dictionary;

@end
