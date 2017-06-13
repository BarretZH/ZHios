//
//  SeacherNetWork.h
//  ShowMuse
//
//  Created by show zh on 16/5/30.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^completeSeacher)(id json, NSError* error);
@interface SeacherNetWork : NSObject

/**
 *  搜索请求
 *
 *  @param offset          第几页    10，20，30...
 *  @param search          搜索内容
 *  
 */
+(void)searchLessonWithOffset:(NSString *)offset search:(NSString *)search Complete:(completeSeacher)completeSeacher;
/**
 *  搜索大师
 *
 *  @param search          搜索内容
 *  
 */
+(void)teacherSearchNSString:(NSString *)search Complete:(completeSeacher)completeSeacher;
/**
 *  分类搜索
 *
 *  @param search          搜索内容
 *  @param category        分类ID
 *
 */
+(void)categoriesSearchLessonWithOffset:(NSString *)offset search:(NSString *)search category:(NSString *)category Complete:(completeSeacher)completeSeacher;

@end
