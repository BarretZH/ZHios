//
//  RelatedProductsModel.h
//  ShowMuse
//
//  Created by show zh on 16/5/16.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelatedProductsModel : NSObject

@property (strong, nonatomic)NSString * url, * title;


-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
