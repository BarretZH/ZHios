//
//  UserDetaModel.h
//  ShowMuse
//
//  Created by show zh on 16/5/25.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetaModel : NSObject

@property (nonatomic) int gender;

@property (nonatomic,copy) NSString * avatar, * name, * education, * maritalStatus, * country, * dateOfBirth;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
@end
