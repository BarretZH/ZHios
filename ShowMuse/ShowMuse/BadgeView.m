//
//  BadgeView.m
//  ShowMuse
//
//  Created by show zh on 16/5/27.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "BadgeView.h"

#define ANGLE(val) DEG2RAD(270 + (val))
#define DEG2RAD(val) (M_PI / 180) * (val)
#define RADIUS_MARGIN 0

@implementation ArcValueClass

@end



@implementation BadgeView

{
    CGPoint _center;
    CGFloat _radius;
}

#pragma mark - initializer methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self bootstrap];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bootstrap];
    }
    return self;
}


- (void)bootstrap
{
    self.backgroundColor = [UIColor clearColor];
    _valuesAndColors = [NSMutableArray array];
}

#pragma mark - Pie addition methods

- (void)addAngleValue:(CGFloat)angle andColor:(UIColor *)color;
{
    ArcValueClass *v = [[ArcValueClass alloc] init];
    v.color = color;
    v.angle = angle;
    
    [_valuesAndColors addObject:v];
    
    [self setNeedsDisplay];
}

- (void)insertAngleValue:(CGFloat)angle andColor:(UIColor *)color atIndex:(int)index;
{
    ArcValueClass *v = [[ArcValueClass alloc] init];
    v.color = color;
    v.angle = angle;
    
    [_valuesAndColors insertObject:v atIndex:index];
    
    [self setNeedsDisplay];
}

- (void)reset {
    [_valuesAndColors removeAllObjects];
}

#pragma mark - drawing methods

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //center of the view
    _center = CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y);
    _radius = (MIN(self.bounds.size.width, self.bounds.size.height) / 2) - RADIUS_MARGIN;
    
    //apply the chart background color
    if(_chartBackgroundColor) {
        CGMutablePathRef path = createArc(_center, _radius, ANGLE(0), ANGLE(360));
        createAndFillArc(context, path, _chartBackgroundColor.CGColor);
    }
    
    /*__block*/ CGFloat startAngle = 0;
    
//    [_valuesAndColors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        
//        ArcValueClass *v = (ArcValueClass *)obj;
//        CGColorRef color = v.color.CGColor;
//        CGFloat value = v.angle;
//        
//        CGFloat angleValue = (360 * value);
//        CGFloat endAngle = startAngle + angleValue;
//        
//        CGMutablePathRef path = createArc(_center, _radius, ANGLE(startAngle), ANGLE(endAngle));
//        createAndFillArc(context, path, color);
//        
//        startAngle += angleValue;
//    }];
    for (int i = 0; i<_valuesAndColors.count; i++) {
        ArcValueClass *v = (ArcValueClass *)_valuesAndColors[i];
        CGColorRef color = v.color.CGColor;
        CGFloat value = v.angle;
        
        CGFloat angleValue = (360 * value);
        CGFloat endAngle = startAngle + angleValue;
        
        CGMutablePathRef path = createArc(_center, _radius, ANGLE(startAngle), ANGLE(endAngle));
        createAndFillArc(context, path, color);
        
        startAngle += angleValue;

    }
    
    //check and apply the concentric circle
    if(_isConcentric && _concentricRadius > 0 && _concentricColor) {
        CGMutablePathRef path = createArc(_center, _concentricRadius, ANGLE(0), ANGLE(360));
        createAndFillArc(context, path, _concentricColor.CGColor);
        
    }
    
    UIGraphicsEndImageContext();
}

void createAndFillArc(CGContextRef context, CGPathRef path, CGColorRef color) {
    CGContextSetFillColorWithColor(context, color);
    CGContextAddPath(context, path);
    
    CGContextDrawPath(context, kCGPathFill);
}

CGMutablePathRef createArc(CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle) {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle, endAngle, 0);
    CGPathAddLineToPoint(path, NULL, center.x, center.y);
    CGPathCloseSubpath(path);
    
    return path;
}

@end
