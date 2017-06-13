//
//  CategroriesNetWork.h
//  ShowMuse
//
//  Created by show zh on 16/6/20.
//  Copyright © 2016年 ShowMuse. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^completeCategrories)(id json, NSError* error);
@interface CategroriesNetWork : NSObject


+(void)categoriesLessonWithID:(NSString *)ID offset:(NSString *)offset Complete:(completeCategrories)completeCategrories;
@end
