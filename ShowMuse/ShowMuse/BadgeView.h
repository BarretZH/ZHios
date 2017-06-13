//
//  BadgeView.h
//  ShowMuse
//
//  Created by show zh on 16/5/27.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArcValueClass : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic) CGFloat angle;

@end



@interface BadgeView : UIView

<UIGestureRecognizerDelegate>
{
    NSMutableArray *_valuesAndColors;
    
}

/**
 *  if you want to specify a background to the chart.
 */
@property(nonatomic, strong) UIColor *chartBackgroundColor;

//properties to create concentric PI Chart
@property(nonatomic) BOOL isConcentric;                   //specify YES or NO if you want concentric Pie chart.
@property(nonatomic) CGFloat concentricRadius;            //radius of the concentric circle.
@property(nonatomic, strong) UIColor *concentricColor;    //color of the concentric circle.


/**
 *  this method will add the new Pie in the Pie Chart
 *
 *  @param angle    add the value between 0-1 to add a specific pie
 *  @param color    the color of the pie
 */
- (void)addAngleValue:(CGFloat)angle andColor:(UIColor *)color;

/**
 *  this method will insert the new pie in the pie chart instead of just adding it at the last place
 *
 *  @param angle    add the value between 0-1 to add a specific pie
 *  @param color    the color of the pie
 *  @param index    the index at which you want to add the pie
 */
- (void)insertAngleValue:(CGFloat)angle andColor:(UIColor *)color atIndex:(int)index;


/**
 *  resets the current pies array
 */
- (void)reset;






@end
