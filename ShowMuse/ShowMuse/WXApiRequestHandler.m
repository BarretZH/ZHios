//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import "WXApi.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"



@implementation WXApiRequestHandler


+ (NSString *)jumpToBizPay {
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseString = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"responseString = %@",responseString);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
    
    NSMutableString *stamp  = [dic objectForKey:@"timestamp"];
    //调起支付
    PayReq *req = [[PayReq alloc]init];
    req.partnerId = dic[@"partnerid"];//@"10000100";//商家id
    req.prepayId = dic[@"prepayid"];//@"wx20160222181228eabc76df380849802454";//预支付订单
    req.package = dic[@"package"];  //@"Sign=WXPay";//扩展字段  暂填写固定值Sign=WXPay
    req.nonceStr = dic[@"noncestr"];//@"758d476b9ebdc37e698ccfbdbcd21906";//随机串，防重发
    req.timeStamp = stamp.intValue; //@"1456135948";//时间戳
    req.sign = dic[@"sign"];//@"61EC78AB39E256B2624D54C7E1390D70";//商家根据微信开放平台文档对数据做的签名
    [WXApi sendReq:req];
    
    NSLog(@"\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    
    
    return @"";
}
@end
