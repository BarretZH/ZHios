//
//  JCTagView.h
//  JCLabel
//
//  Created by QB on 16/4/26.
//  Copyright © 2016年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RelatedCoursesDelegate;
/**
 *  使用
 *  1.在使用的时候直接创建JCTagView控件，自定义控件的frame (origin,width)高度随着传入的数组的变量变化自适应
 *  2.保留了几个属性 方便使用者定义控件的的背景颜色JCbackgroundColor，JCSignalTagColor
 *  3.在定义好JCTagView控件后，一定要调用 “标签文本这个方法”
 *
 *  
 */

@interface JCTagView : UIView

@property(nonatomic,assign)id<RelatedCoursesDelegate> delegate;

///设置整个View的背景颜色
@property (nonatomic, retain) UIColor *JCbackgroundColor;

/**
 *  设置单一颜色
 */
@property (nonatomic) UIColor *JCSignalTagColor;

@property (nonatomic) BOOL isAddLin;

/**
 *  标签 文本赋值
 */
- (void)setArrayTagWithLabelArray:(NSArray *)array;

@end


@protocol RelatedCoursesDelegate <NSObject>
@optional
-(void)relatedCoursesWithID:(NSString *)ID;

-(void)relatedCoursesWithTagView:(JCTagView *)tagView ID:(NSString *)ID;
@end