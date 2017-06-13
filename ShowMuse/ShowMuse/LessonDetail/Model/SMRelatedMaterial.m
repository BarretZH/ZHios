//
//  SMRelatedMaterial.m
//  ShowMuse
//
//  Created by ygliu on 9/13/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMRelatedMaterial.h"

@implementation SMRelatedMaterial

+ (instancetype)materialWithDict:(NSDictionary *)dict
{
    SMRelatedMaterial *material = [[self alloc] init];
    [material setValuesForKeysWithDictionary:dict];
    return material;
}

@end
