//
//  Launch.m
//  ShowMuse
//
//  Created by show zh on 16/4/28.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "Launch.h"

@implementation Launch


- (id)initWithDictionary:(NSDictionary* )dictionary {
    if (self = [super init]) {
        self.ID = dictionary[@"id"];
        self.url = dictionary[@"url"];
        
    }
    return self;

}




@end
