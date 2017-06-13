//
//  SystemMessages.h
//  ShowMuse
//
//  Created by show zh on 16/5/17.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMessages : NSObject

@property(copy,nonatomic)NSString * message40301, * message40302;

- (id)initWithDictionary:(NSDictionary* )dictionary;
@end
