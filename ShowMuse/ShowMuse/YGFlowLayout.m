//
//  YGFlowLayout.m
//  ShowMusePlanB
//
//  Created by liuyonggang on 16/5/2016.
//  Copyright © 2016 liuyonggang. All rights reserved.
//

#import "YGFlowLayout.h"

@implementation YGFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    if ([UIScreen mainScreen].bounds.size.width == 320.0 ) { // iPhone4 5 5s
        self.itemSize = CGSizeMake(135, 115);
    } else if ([UIScreen mainScreen].bounds.size.width == 375.0){ // iPhone6 6s
        self.itemSize = CGSizeMake(157, 125);
    } else { // Plus
        self.itemSize = CGSizeMake(175, 135);
    }
    
}

@end
