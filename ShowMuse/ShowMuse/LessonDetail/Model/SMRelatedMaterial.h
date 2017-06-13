//
//  SMRelatedMaterial.h
//  ShowMuse
//
//  Created by ygliu on 9/13/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMRelatedMaterial : NSObject

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *url;

+ (instancetype)materialWithDict:(NSDictionary *)dict;

@end
