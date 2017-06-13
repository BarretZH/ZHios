//
//  RelatedCoursesModel.h
//  ShowMuse
//
//  Created by show zh on 16/5/16.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelatedCoursesModel : NSObject

@property (nonatomic) int ID;

@property (nonatomic,copy) NSString  * title, * introduction;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
