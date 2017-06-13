//
//  SMDialog.h
//  ShowMuse
//
//  Created by liuyonggang on 2/6/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JavaScriptCore/JavaScriptCore.h>

@protocol SMDialogDelegate <NSObject>

@optional
/**
 *  关闭按钮点击
 */
- (void)dialogCloseBtnDidClick:(UIButton *)button;
/**
 *  左边按钮点击
 */
- (void)dialogLeftButtonDidClick:(UIButton *)button;
/**
 *  右边按钮点击
 */
- (void)dialogRightButtonDidClick:(UIButton *)button;
/**
 *  支付方式按钮点击
 */
- (void)dialogContentButtonDidClick:(UIButton *)button;

@end

@interface SMDialog : UIView

/** 关闭按钮代理 */
@property (weak, nonatomic) id<SMDialogDelegate> delegate;

/** 左边按钮 */
@property (weak, nonatomic) UIButton *leftButton;
/** 右边按钮 */
@property (weak, nonatomic) UIButton *rightButton;
/** 保存徽章图片 */
@property (weak, nonatomic) UIImageView *badgeView;

/**
 *  创建一个文字弹框
 *
 *  @param title              弹框的标题
 *  @param content            弹框的内容
 *  @param delegate           弹框的代理
 *  @param cancelButtonTitle  右边按钮文字
 *  @param confirmButtonTitle 左边按钮文字
 *
 *  @return 创建好的弹框
 */
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)contentText delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle;
/**
 *  创建一个支付窗口弹框
 *
 *  @param title    弹框的标题
 *  @param buttons  弹框的内部按钮
 *  @param delegate 弹框的代理
 *
 *  @return 创建好的弹框
 */
- (instancetype)initWithTitle:(NSString *)title contentButtons:(NSDictionary *)buttons delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle;
/**
 *  创建一个html内容的弹框
 *
 *  @param title            弹框的标题
 *  @param html             html内容
 *  @param delegate         弹框的代理
 *  @param leftButtonTitle  左边按钮点击
 *  @param rightButtonTitle 右边按钮点击
 *
 *  @return 创建好的html弹框
 */
- (instancetype)initWithTitle:(NSString *)title htmlString:(NSString *)html delegate:(id)delegate leftbuttonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle;

/**
 *  创建一个图片和内容的弹框
 *
 *  @param imageName        图片名称
 *  @param contentText      内容文字
 *  @param delegate         代理
 *  @param leftButtonTitle  左边按钮
 *  @param rightButtonTitle 右边按钮
 *
 *  @return 创建好的图文弹窗
 */
- (instancetype)initWithImage:(UIImage *)image contentText:(NSString *)contentText delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle;
@end

#pragma mark - SMPaymentButton class
@interface SMPaymentButton : UIButton

@end
