//
//  SMRelatedProduct.h
//  ShowMuse
//
//  Created by ygliu on 9/13/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMRelatedProduct : NSObject

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *url;

+ (instancetype)productWithDict:(NSDictionary *)dict;

@end
