//
//  SystemMessages.m
//  ShowMuse
//
//  Created by show zh on 16/5/17.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "SystemMessages.h"

@implementation SystemMessages

- (id)initWithDictionary:(NSDictionary* )dictionary {
    if (self = [super init]) {
        self.message40301 = dictionary[@"40301"];
        self.message40302 = dictionary[@"40302"];
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.message40302 forKey:@"40302"];
        [userDefaults setObject:self.message40301 forKey:@"40301"];
        [userDefaults synchronize];
    }
    return self;
    
}



@end
