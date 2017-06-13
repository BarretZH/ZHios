//
//  RelatedProductsModel.m
//  ShowMuse
//
//  Created by show zh on 16/5/16.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "RelatedProductsModel.h"

@implementation RelatedProductsModel


-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self=[super init];
    if (self) {
        self.url = dic[@"url"];
        self.title = dic[@"title"];
    }
    return self;
}



@end
