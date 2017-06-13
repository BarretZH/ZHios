//
//  SMDialog.m
//  ShowMuse
//
//  Created by liuyonggang on 2/6/2016.
//  Copyright © 2016 show zh. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "SMDialog.h"
#import "Masonry.h"
//#import "SMPaymentButton.h"

// 支付按钮 - 之间 - 间距 6、6s、6 P、6s P
#define ContentButtonToButtonBigPadding ((kPayMethodDialogBigWidth - kContentViewLeftPadding - kContentViewRightPadding) - kPayButtonWidth * self.contentBtnArr.count) / (self.contentBtnArr.count + 1)
// 支付按钮 - 之间 - 间距 4s、5、5c、5s、5SE
#define ContentButtonToButtonSmallPadding ((kPayMethodDialogSmallWidth - kContentViewLeftPadding - kContentViewRightPadding) - kPayButtonWidth * self.contentBtnArr.count) / (self.contentBtnArr.count + 1)

@interface SMDialog ()
/** 大背景图片 */
@property (weak, nonatomic) UIImageView *backgoundView;
/** 包裹内容的父控件 */
@property (weak, nonatomic) UIView *contentView;
/** 关闭按钮 */
@property (weak, nonatomic) UIButton *closebutton;
/** 关闭按钮背景 */
@property (weak, nonatomic) UIView *closeBtnBgView;
/** 内部分割线 */
@property (weak, nonatomic) UIView *separator;
/** 标题文字 */
@property (weak, nonatomic) UILabel *titleLabel;
/** 内容 */
@property (weak, nonatomic) UILabel *contentLabel;
/** 徽章描述 */
@property (weak, nonatomic) UILabel *descLabel;
/** 内容按钮 -- 分享 */
@property (weak, nonatomic) SMPaymentButton *contentButton;
/** 取消按钮文字 */
@property (copy, nonatomic) NSString *cancelBtnTitle;
/** 确认按钮文字 */
@property (copy, nonatomic) NSString *confirmBtnTitle;
/** WebView控件 */
@property (weak, nonatomic) UIWebView *webView;
/** 保存所有分享按钮 */
@property (strong, nonatomic) NSMutableArray *contentBtnArr;
/** 标题文字 */
@property (copy, nonatomic) NSString *title;
/** 内容文字 */
@property (copy, nonatomic) NSString *contentText;
/** 徽章的描述 */
@property (copy, nonatomic) NSString *descText;
/** 保存url */
@property (copy, nonatomic) NSString *urlStr;
/** 保存内容文字的高度 */
@property (assign, nonatomic) CGFloat contentTextH;
/** 保存徽章描述文字的高度 */
@property (assign, nonatomic) CGFloat desTextH;

@end

#pragma - mark - SMPaymentButton Implementation
@implementation SMPaymentButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.width);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat y = CGRectGetMaxY(self.imageView.frame);
    return CGRectMake(0, y, contentRect.size.width, 20);
}

@end

#pragma - mark - SMDialog Implementation
@implementation SMDialog

#pragma mark - lazy
- (NSMutableArray *)contentBtnArr
{
    if (!_contentBtnArr) {
        _contentBtnArr = [NSMutableArray array];
    }
    return _contentBtnArr;
}
#pragma mark - 返回需要的对话框
// 消息对话框
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)contentText delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle
{
    if (self = [super init]) {
        self.cancelBtnTitle = leftButtonTitle;
        self.confirmBtnTitle = rightButtonTitle;
        self.title = title;
        self.contentText = contentText;
        self.delegate = delegate;
        // 添加子控件
        [self setupMessageDialogChildWedgets];
        // 内容文字label
        [self addContentLabel];
    }
    // 强制布局拿到计算后的高度
    [self layoutSubviews];
    
    // 计算自己的尺寸
    CGFloat dialogH = kContentViewTopPadding + kSeparatorLineToContentLabelPadding + 1 + kLeftOrRightButtonTopPadding + kLeftOrRightButtonHeight + 15 + kContentViewBottomPadding;
    if (self.title) {
        
        dialogH += kTitleLabelTopPadding + kTitleLabelHeight + kContentLabelTopPadding;
    } else {
        dialogH += kContentLabelToContentViewTopPadding;
    }
    
    dialogH += self.contentText ? self.contentTextH : 10;
    if (SMScreenWidth > 320) { // 6 6s 6P 6sP
        self.bounds = CGRectMake(0, 0, kMessageDialogBigWidth, dialogH);
    } else {
        self.bounds = CGRectMake(0, 0, kMessageDialogSmallWidth, dialogH);
    }
    self.center = CGPointMake(SMScreenWidth * 0.5, SMScreenHeight * 0.4);
    
    return self;
}
// 支付方式对话框
- (instancetype)initWithTitle:(NSString *)title contentButtons:(NSDictionary *)buttons delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle
{
    if (self = [super init]) {
        self.cancelBtnTitle = leftButtonTitle;
        self.confirmBtnTitle = rightButtonTitle;
        self.title = title;
        self.delegate = delegate;
        [self setupPayMethodChildWedgets];
        [self addPaymethodButton:buttons];
    }
    // 计算自己的尺寸
    CGFloat dialogH = kContentViewTopPadding + kTitleLabelTopPadding + kTitleLabelHeight + kPayButtonTopPadding + kPayButtonHeight + kSeparatorLineToContentButtonPadding + 1 + kLeftOrRightButtonTopPadding + kLeftOrRightButtonHeight + 12 + kContentViewBottomPadding;

    if (SMScreenWidth > 320) {
        self.bounds = CGRectMake(0, 0, kPayMethodDialogBigWidth, dialogH);
    } else {
        self.bounds = CGRectMake(0, 0, kPayMethodDialogSmallWidth, dialogH);
    }
    self.center = CGPointMake(SMScreenWidth * 0.5, SMScreenHeight * 0.4);
    
    return self;
}
// html对话框
- (instancetype)initWithTitle:(NSString *)title htmlString:(NSString *)html delegate:(id)delegate leftbuttonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle
{
    if (self = [super init]) {
        self.cancelBtnTitle = leftButtonTitle;
        self.confirmBtnTitle = rightButtonTitle;
        self.urlStr = html;
        self.title = title;
        self.delegate = delegate;
        [self setupHTMLDialogChildWedgets];
        [self layoutSubviews];
    }
    // 计算自己的尺寸
    CGFloat dialogH = kContentViewTopPadding + kSeparatorLineToWebViewPadding + 1 + kLeftOrRightButtonTopPadding + kLeftOrRightButtonHeight + 12 + kContentViewBottomPadding + kWebViewHeight;
    if (self.title) { // 有标题
        dialogH += kTitleLabelTopPadding + kTitleLabelHeight + kWebViewTopPadding;
    } else { // 没标题
        dialogH += kWebViewToContentViewPading;
    }
    if (SMScreenWidth > 320) {
        self.bounds = CGRectMake(0, 0, kMessageDialogBigWidth, dialogH);
    } else {
        self.bounds = CGRectMake(0, 0, kMessageDialogSmallWidth, dialogH);
    }
    self.center = CGPointMake(SMScreenWidth * 0.5, SMScreenHeight * 0.4);
    
    return self;
}
// 徽章对话框
- (instancetype)initWithImage:(UIImage *)image contentText:(NSString *)contentText delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle
{
    if (self = [super init]) {
        self.cancelBtnTitle = leftButtonTitle;
        self.confirmBtnTitle = rightButtonTitle;
        self.descText = contentText;
        self.delegate = delegate;
        [self setupPictureDialogWedgets];
        [self addBadgeView:image];
    }
    // 强制布局拿到计算后的高度
    [self layoutSubviews];
    // 计算自己的尺寸
    CGFloat dialogH = kContentViewTopPadding + kBadgeViewTopPadding + kBadgeViewWidth + kDesLabelPadding * 2 + 1 + kLeftOrRightButtonTopPadding + kLeftOrRightButtonHeight + 12 + kContentViewBottomPadding;
    dialogH += self.desTextH ? self.desTextH : 10;
    if (SMScreenWidth > 320) { // 6 6s 6P 6sP
        self.bounds = CGRectMake(0, 0, kMessageDialogBigWidth, dialogH);
    } else {
        self.bounds = CGRectMake(0, 0, kMessageDialogSmallWidth, dialogH);
    }
    self.center = CGPointMake(SMScreenWidth * 0.5, SMScreenHeight * 0.4);
    return self;
}

#pragma mark - 不同对话框需要的子控件
- (void)setupCommentChildWedgets
{
    // bgView
    [self addBackgroundView];
    // contentView
    [self addContentView];
    // 关闭按钮
    [self addCloseButton];
    // 分割线
    [self addSeparatorLine];
    
}
/**  添加添加消息内容对话框 */
- (void)setupMessageDialogChildWedgets
{
    [self setupCommentChildWedgets];
    if (self.title) {
        // 标题文字
        [self addTitleLabel];
    }
    [self addLeftButton];
    [self addRightButton];
    
}
/**  添加支付方式对话框 */
- (void)setupPayMethodChildWedgets
{
    // 标题文字
    [self setupCommentChildWedgets];
    [self addTitleLabel];
    [self addLeftButton];
    [self addRightButton];

}
/**  添加HTML对话框 */
- (void)setupHTMLDialogChildWedgets
{
    
    [self setupCommentChildWedgets];
    if (self.title) {
        // 标题文字
        [self addTitleLabel];
    }
    [self addLeftButton];
    [self addRightButton];
    [self addWebView];
}
/**  添加徽章对话框 */
- (void)setupPictureDialogWedgets
{
    [self setupCommentChildWedgets];
    [self addDescLabel];
    [self addLeftButton];
    [self addRightButton];
}
#pragma mark - 添加子控件

- (void)addBackgroundView
{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.userInteractionEnabled = YES;
    if (SMScreenWidth > 320) {
        bgView.image = [self stretchImageWithImageName:@"Popup_background"];
    } else {
        bgView.image = [self stretchImageWithImageName:@"Popup_background_small"];
    }
    
    [self addSubview:bgView];
    self.backgoundView = bgView;
    
}

#pragma mark - 图片拉伸
/**
 *  返回一张保持原样拉伸过的图片
 */
- (UIImage *)stretchImageWithImageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    // 设置左边端盖宽度
    NSInteger leftCapWidth = image.size.width * 0.5;
    // 设置上边端盖高度
    NSInteger topCapHeight = image.size.height * 0.5;
    
    return [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
}
/**  添加contentView */
- (void)addContentView
{
    UIView *contentView = [[UIView alloc] init];
//    contentView.backgroundColor = [UIColor randomColor];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.userInteractionEnabled = YES;
    contentView.layer.cornerRadius = 6;
    contentView.layer.masksToBounds = YES;
    [self.backgoundView addSubview:contentView];
    self.contentView = contentView;
}
/**  添加关闭按钮 */
- (void)addCloseButton
{
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (SMScreenWidth > 320) {
        [closeBtn setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
    } else {
        [closeBtn setImage:[UIImage imageNamed:@"shanchu_small"] forState:UIControlStateNormal];
    }
//    closeBtn.backgroundColor = [UIColor randomColor];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    self.closebutton = closeBtn;
}

/**  分割线 */
- (void)addSeparatorLine
{
    UIView *separator = [[UIView alloc] init]; 
    separator.backgroundColor = colorWithRGB(208, 208, 208);
    [self.contentView addSubview:separator];
    self.separator = separator;
}
/**  标题文字 */
- (void)addTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.title;
    titleLabel.textColor = colorWithRGB(56, 56, 56);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18.0];
//    titleLabel.backgroundColor = [UIColor randomColor];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
}
/**  内容文字 */
- (void)addContentLabel
{
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:16.0];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = self.contentText;
    contentLabel.numberOfLines = 0;
//    contentLabel.backgroundColor = [UIColor randomColor];
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}
/**  左边按钮 */
- (void)addLeftButton
{
    UIButton *leftBtn = [self createButtonWithTitle:self.cancelBtnTitle action:@selector(leftBtnClick)];
    self.leftButton = leftBtn;
}
/**  右边按钮 */
- (void)addRightButton
{
    UIButton *rightButton = [self createButtonWithTitle:self.confirmBtnTitle action:@selector(rightBtnClick)];
    self.rightButton = rightButton;
}

- (UIButton *)createButtonWithTitle:(NSString *)title action:(SEL)sel
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = kLeftOrRightButtonHeight * 0.5;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:button];
    button.backgroundColor = colorWithRGB(55, 54, 62);
    return button;
}

/**  添加支付方式子控件 */
- (void)addPaymethodButton:(NSDictionary *)buttons
{
    NSArray *allValues = [buttons allValues];
    NSInteger i = 0;
    for (NSString *key in buttons) {
        
        // 加按钮
        SMPaymentButton *contentBtn = [SMPaymentButton buttonWithType:UIButtonTypeCustom];
//        contentBtn.backgroundColor = [UIColor randomColor];
        contentBtn.tag = i;
        [contentBtn setImage:[UIImage imageNamed:allValues[i]] forState:UIControlStateNormal];
        [contentBtn setTitle:key forState:UIControlStateNormal];
        [contentBtn setTitleColor:colorWithRGB(81, 81, 81) forState:UIControlStateNormal];
        contentBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        contentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [contentBtn addTarget:self action:@selector(contentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:contentBtn];
        [self.contentBtnArr addObject:contentBtn]; // 加到数组中
        self.contentButton = contentBtn;
        i++;
        
    }
}
/**  添加WebView控件 */
- (void)addWebView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor whiteColor];
    NSURL *url = [NSURL URLWithString:self.urlStr];
    if (url) {
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
    } else {
        [webView loadHTMLString:self.urlStr baseURL:nil];
    }
    [self.contentView addSubview:webView];
    self.webView = webView;
    
}
/**  添加徽章图片 */
- (void)addBadgeView:(UIImage *)image
{
    UIImageView *badge = [[UIImageView alloc] init];
    badge.image = image;
//    badge.backgroundColor = [UIColor randomColor];
    [self.contentView addSubview:badge];
    self.badgeView = badge;
}
/**  添加徽章文字label */
- (void)addDescLabel
{
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.font = [UIFont systemFontOfSize:14.0];
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.text = self.descText;
    desLabel.numberOfLines = 0;
//    desLabel.backgroundColor = [UIColor randomColor];
    [self.contentView addSubview:desLabel];
    self.descLabel = desLabel;
}
#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 布局大背景图片
    [self.backgoundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.right.equalTo(self.right);
        make.left.equalTo(self.left);
        make.bottom.equalTo(self.bottom);
    }];
     // 布局contentView
    if (SMScreenWidth > 320) {
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backgoundView.left).offset(kContentViewLeftPadding);
            make.right.equalTo(self.backgoundView.right).offset(-kContentViewRightPadding);
            make.top.equalTo(self.backgoundView.top).offset(kContentViewTopPadding);
            make.bottom.equalTo(self.backgoundView.bottom).offset(-kContentViewBottomPadding);
        }];
    } else {
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backgoundView.left).offset(kContentViewLeftPadding);
            make.right.equalTo(self.backgoundView.right).offset(-kContentViewSmallTopPadding);
            make.top.equalTo(self.backgoundView.top).offset(kContentViewSmallTopPadding);
            make.bottom.equalTo(self.backgoundView.bottom).offset(-kContentViewLeftPadding);
        }];
    }
    
    // 布局关闭按钮
    if (SMScreenWidth > 320) {
        [self.closebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right);
            make.top.equalTo(self.top);
            make.size.equalTo(CGSizeMake(kCloseButtonWidth, kCloseButtonWidth));
        }];
    } else {
        [self.closebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.right);
            make.top.equalTo(self.top);
            make.size.equalTo(CGSizeMake(kCloseButtonSmallWidth, kCloseButtonSmallWidth));
        }];
    }
    
     //布局标题文字
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(kTitleLabelTopPadding);
        make.left.equalTo(self.contentView.left);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(kTitleLabelHeight);
    }];
    
    // 内容文字label
    if (self.contentLabel) {
        if (self.title) { // 有标题问题
            [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.bottom).offset(kContentLabelTopPadding);
                make.left.equalTo(self.contentView.left).offset(kContentLabelLeftPadding);
                make.right.equalTo(self.contentView.right).offset(-kContentLabelLeftPadding);
            }];
            // 计算内容文字的高度
            [self calculateTextHeight];
        } else { // 没有标题问题
            [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.top).offset(kContentLabelToContentViewTopPadding);
                make.left.equalTo(self.contentView.left).offset(kContentLabelLeftPadding);
                make.right.equalTo(self.contentView.right).offset(-kContentLabelLeftPadding);
            }];
            // 计算内容文字的高度
            [self calculateTextHeight];
        }
    }
    
    // 布局分割线
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (self.contentLabel) { // 按内容label计算
            make.top.equalTo(self.contentLabel.bottom).offset(kSeparatorLineToContentLabelPadding);
        } else if (self.contentButton) { // 按支付按钮
            make.top.equalTo(self.contentButton.bottom).offset(kSeparatorLineToContentButtonPadding);
        } else if (self.webView) { // webView
            make.top.equalTo(self.webView.bottom).offset(kSeparatorLineToWebViewPadding);
        } else { // 徽章
            make.top.equalTo(self.descLabel.bottom).offset(10);
        }
        make.left.equalTo(self.contentView.left).offset(kSeparatorLineLeftPadding);
        make.right.equalTo(self.contentView.right).offset(-kSeparatorLineRightPadding);
        make.height.equalTo(1);
    }];
    
    // 布局左右按钮
    if (self.cancelBtnTitle != nil && self.confirmBtnTitle != nil) {
        
        // 左边按钮
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.separator.bottom).offset(kLeftOrRightButtonTopPadding);
            make.left.equalTo(self.contentView.left).offset(kLeftButtonLeftPadding);
            make.size.equalTo(CGSizeMake(kLeftOrRightButtonWidth, kLeftOrRightButtonHeight));
        }];
        // 右边按钮
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.separator.bottom).offset(kLeftOrRightButtonTopPadding);
            make.right.equalTo(self.contentView.right).offset(-kRightButtonRightPadding);
            make.size.equalTo(CGSizeMake(kLeftOrRightButtonWidth, kLeftOrRightButtonHeight));
        }];

    } else if (self.cancelBtnTitle == nil && self.confirmBtnTitle != nil) { // 右边按钮
        
        [self.leftButton removeFromSuperview];
        [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.separator.bottom).offset(kLeftOrRightButtonTopPadding);
            make.centerX.equalTo(self.contentView.centerX);
            make.size.equalTo(CGSizeMake(kLeftOrRightButtonWidth, kLeftOrRightButtonHeight));
        }];
        
    } else if (self.cancelBtnTitle != nil && self.confirmBtnTitle == nil) {// 左边按钮
        
        [self.rightButton removeFromSuperview];
        [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.separator.bottom).offset(kLeftOrRightButtonTopPadding);
            make.centerX.equalTo(self.contentView.centerX);
            make.size.equalTo(CGSizeMake(kLeftOrRightButtonWidth, kLeftOrRightButtonHeight));
        }];
        
    } else {
        
        [self.rightButton removeFromSuperview];
        [self.leftButton removeFromSuperview];
    }
    
    // 内容按钮布局
    NSInteger count = self.contentBtnArr.count;
    if (count) {
        for (NSInteger i = 0; i < count; i++) {
            if (i == 0) { // 第一个按钮
                
                SMPaymentButton *button = self.contentBtnArr[i];
                if (SMScreenWidth > 320) { // 6 6s 6P 6sP
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.contentView.left).offset(ContentButtonToButtonBigPadding);
                        make.top.equalTo(self.titleLabel.bottom).offset(kPayButtonTopPadding);
                        make.size.equalTo(CGSizeMake(kPayButtonWidth, kPayButtonHeight));
                    }];
                } else { // 4s 5 5c 5s 5SE
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.contentView.left).offset(ContentButtonToButtonSmallPadding);
                        make.top.equalTo(self.titleLabel.bottom).offset(kPayButtonTopPadding);
                        make.size.equalTo(CGSizeMake(kPayButtonWidth, kPayButtonHeight));
                    }];
                }
                
                
            } else { // 后面的按钮
                SMPaymentButton *preBtn = self.contentBtnArr[i - 1];
                SMPaymentButton *curBtn = self.contentBtnArr[i];
                
                if (SMScreenWidth > 320) { // 6 6s 6P 6sP
                    [curBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(preBtn.right).offset(ContentButtonToButtonBigPadding);
                        make.top.equalTo(preBtn.top);
                        make.size.equalTo(CGSizeMake(kPayButtonWidth, kPayButtonHeight));
                    }];
                } else { // 4s 5 5c 5s 5SE
                    [curBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(preBtn.right).offset(ContentButtonToButtonSmallPadding);
                        make.top.equalTo(preBtn.top);
                        make.size.equalTo(CGSizeMake(kPayButtonWidth, kPayButtonHeight));
                    }];
                }
                
            }
        }
    }

    // 布局WebView
    if (self.webView) {
        if (self.title) {
            [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.bottom).offset(kWebViewTopPadding);
                make.left.equalTo(self.contentView.left).offset(kWebViewLeftPadding);
                make.right.equalTo(self.contentView.right).offset(-kWebViewRightPadding);
                make.height.equalTo(kWebViewHeight);
            }];
        } else {
            [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.top).offset(kWebViewToContentViewPading);
                make.left.equalTo(self.contentView.left).offset(kWebViewLeftPadding);
                make.right.equalTo(self.contentView.right).offset(-kWebViewRightPadding);
                make.height.equalTo(kWebViewHeight);
            }];
        }
        
    }
    
    // 布局徽章
    [self.badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.top).offset(kBadgeViewTopPadding);
        make.centerX.equalTo(self.contentView.centerX);
        make.size.equalTo(CGSizeMake(kBadgeViewWidth, kBadgeViewWidth));
    }];
    
    // 布局徽章Label
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.badgeView.bottom).offset(kDesLabelPadding);
        make.left.equalTo(self.contentView.left).offset(kDesLabelPadding);
        make.right.equalTo(self.contentView.right).offset(-kDesLabelPadding);
    }];
    
    CGFloat desTextH = 0.0;
    if (self.descText) {
        if (SMScreenWidth > 320) { // 6、6s、6 P、6s P
            CGFloat textW = kMessageDialogBigWidth - kContentViewRightPadding - kContentViewLeftPadding - kDesLabelPadding * 2;
            CGSize maxSize = CGSizeMake(textW, MAXFLOAT);
            desTextH = [self.descText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size.height;
            self.descLabel.height = desTextH;
            self.desTextH = desTextH;
        } else { // 4s、5、5c、5s、5SE
            CGFloat textW = kMessageDialogSmallWidth - kContentViewSmallTopPadding - kContentViewLeftPadding - kDesLabelPadding * 2;
            CGSize maxSize = CGSizeMake(textW, MAXFLOAT);
            desTextH = [self.descText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size.height;
            self.descLabel.height = desTextH;
            self.desTextH = desTextH;
        }
    } else {
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(10);
        }];
    }
}

/**
 *  计算contentLabel内容文字的高度
 */
- (void)calculateTextHeight
{
    // 计算内容文字的高度
    CGFloat textH = 0.0;
    if (self.contentText) {
        if (SMScreenWidth > 320) { // 6、6s、6 P、6s P
            CGFloat textW = kMessageDialogBigWidth - kContentViewRightPadding - kContentViewLeftPadding - kContentLabelLeftPadding * 2;
            CGSize maxSize = CGSizeMake(textW, MAXFLOAT);
            textH = [self.contentText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]} context:nil].size.height;
            self.contentLabel.height = textH;
            self.contentTextH = textH;
        } else { // 4s、5、5c、5s、5SE
            CGFloat textW = kMessageDialogSmallWidth - kContentViewSmallTopPadding - kContentViewLeftPadding - kContentLabelLeftPadding * 2;
            CGSize maxSize = CGSizeMake(textW, MAXFLOAT);
            textH = [self.contentText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]} context:nil].size.height;
            self.contentLabel.height = textH;
            self.contentTextH = textH;
        }
    } else {
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(10);
        }];
    }
}

#pragma mark - 按钮点击方法
- (void)leftBtnClick
{
    if ([self.delegate respondsToSelector:@selector(dialogLeftButtonDidClick:)]) {
        [self.delegate dialogLeftButtonDidClick:self.leftButton];
    }
}

- (void)rightBtnClick
{
    if ([self.delegate respondsToSelector:@selector(dialogRightButtonDidClick:)]) {
        [self.delegate dialogRightButtonDidClick:self.rightButton];
    }
}
// 关闭按钮点击
- (void)closeBtnClick
{
    if ([self.delegate respondsToSelector:@selector(dialogCloseBtnDidClick:)]) {
        [self.delegate dialogCloseBtnDidClick:self.closebutton];
    }
}
// 支付方式按钮点击
- (void)contentButtonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(dialogContentButtonDidClick:)]) {
        [self.delegate dialogContentButtonDidClick:button];
    }
}


@end
