//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"
#import "ShowMuseURLString.h"

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
*/
- (void)onResp:(BaseResp *)resp
{
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }

}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

+ (NSString *)jumpToBizPay {
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:@"weixin_pay_result" object:nil];
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = [ShowMuseURLString URLStringWithPath:@"/v2/shop/order"];
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseString = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"responseString = %@",responseString);
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
    SMLog(@"dic ---- > %@", dic);
    NSDictionary *dict = dic[@"weixinPackage"];
    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    //调起支付
    PayReq *req = [[PayReq alloc]init];
    req.partnerId = dict[@"partnerid"];//@"10000100";//商家id
    req.prepayId = dict[@"prepayid"];//@"wx20160222181228eabc76df380849802454";//预支付订单
    req.package = dict[@"package"];  //@"Sign=WXPay";//扩展字段  暂填写固定值Sign=WXPay
    req.nonceStr = dict[@"noncestr"];//@"758d476b9ebdc37e698ccfbdbcd21906";//随机串，防重发
    req.timeStamp = stamp.intValue; //@"1456135948";//时间戳
    req.sign = dict[@"sign"];//@"61EC78AB39E256B2624D54C7E1390D70";//商家根据微信开放平台文档对数据做的签名
    [WXApi sendReq:req];
  
    
    NSLog(@"\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    
    return @"";
}

@end
