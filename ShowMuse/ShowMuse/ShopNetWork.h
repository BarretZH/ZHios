//
//  ShopNetWork.h
//  ShowMuse
//
//  Created by show zh on 16/5/26.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^completeShop)(id json, NSError* error);
@interface ShopNetWork : NSObject

/**
 *  获取会员套餐列表
 *
 *
 */
+(void)shopSubscriptionsWithComplete:(completeShop)completeShop;
/**
 *  获取购买信息
 *
 *  @param productId      商品id
 *  @param paymentGateway 支付方式，weixin，applestore
 *
 */
+(void)weixinpayWithProductID:(NSString *)productId paymentGateway:(NSString *)paymentGateway complete:(completeShop)completeShop;
/**
 *  成功购买发的请求
 *
 *  @param orderNo      订单id
 *  
 */
/**
 *  成功购买发的请求
 *
 *  @param orderNo           订单id
 *  @param requestParameters 请求参数 微信为nil，苹果需要传
 *
 */
+(void)weixinVerifyWithOrderNo:(NSString *)orderNo parameters:(NSDictionary *)requestParameters complete:(completeShop)completeShop;
/**
 *  购买失败发的请求
 *
 *  @param orderNo      订单id
 *
 */
+(void)weixinCancelWithOrderNo:(NSString *)orderNo complete:(completeShop)completeShop;
@end
