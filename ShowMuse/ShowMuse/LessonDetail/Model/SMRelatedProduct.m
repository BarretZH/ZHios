//
//  SMRelatedProduct.m
//  ShowMuse
//
//  Created by ygliu on 9/13/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMRelatedProduct.h"

@implementation SMRelatedProduct

+ (instancetype)productWithDict:(NSDictionary *)dict
{
    SMRelatedProduct *product = [[self alloc] init];
    [product setValuesForKeysWithDictionary:dict];
    return product;
}

@end
