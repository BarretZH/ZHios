//
//  SMProjectConst.h
//  ShowMuse
//
//  Created by ygliu on 8/23/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import <Foundation/Foundation.h>


/***     Dialog      ***/
 // 支付大对话框 - 宽度 6、6s、6 P、6s P
UIKIT_EXTERN CGFloat const kPayMethodDialogBigWidth;
 // 支付小对话框 - 宽度 4s、5、5c、5s、5SE
UIKIT_EXTERN CGFloat const kPayMethodDialogSmallWidth;
 // 消息对话框 - 宽度 6、6s、6 P、6s P
UIKIT_EXTERN CGFloat const kMessageDialogBigWidth;
 // 消息对话框 - 宽度 4s、5、5c、5s、5SE
UIKIT_EXTERN CGFloat const kMessageDialogSmallWidth;
 // contentView距离父控件的边距
UIKIT_EXTERN CGFloat const kContentViewPadding;
 // contentView距离父控件 - 顶部 - 间距
UIKIT_EXTERN CGFloat const kContentViewTopPadding;
 // contentView距离父控件 - 右边 - 间距
UIKIT_EXTERN CGFloat const kContentViewRightPadding;
 // contentView距离父控件 - 右边 - 顶部 - 间距  (4s 5 5c 5s 5SE)
UIKIT_EXTERN CGFloat const kContentViewSmallTopPadding;
 // contentView距离父控件 - 左边 - 间距
UIKIT_EXTERN CGFloat const kContentViewLeftPadding;
 // contentView距离父控件 - 底部 - 间距
UIKIT_EXTERN CGFloat const kContentViewBottomPadding;
 // 关闭按钮 宽度 - 高度
UIKIT_EXTERN CGFloat const kCloseButtonWidth;
 // 关闭按钮 宽 - 高 - 度 4s 5c 5s 5SE
UIKIT_EXTERN CGFloat const kCloseButtonSmallWidth;
 // 标题文字 - 顶部 - 间距
UIKIT_EXTERN CGFloat const kTitleLabelTopPadding;
 // 标题文字 - 高度
UIKIT_EXTERN CGFloat const kTitleLabelHeight;
 // 内容Label 左边 - 右边 间距
UIKIT_EXTERN CGFloat const kContentLabelLeftPadding;
 // 内容Label 顶部 间距
UIKIT_EXTERN CGFloat const kContentLabelTopPadding;
 // 内容Label - 底部 - 间距
UIKIT_EXTERN CGFloat const kContentLabelBottomPadding;
 // 内容label - 顶部 - contentView - 顶部 - 间距（没有title时）
UIKIT_EXTERN CGFloat const kContentLabelToContentViewTopPadding;
 // 分割线距离 - 文字内容label - 底部 - 间距
UIKIT_EXTERN CGFloat const kSeparatorLineToContentLabelPadding;
 // 分割线距离 - 支付按钮 - 底部 - 间距
UIKIT_EXTERN CGFloat const kSeparatorLineToContentButtonPadding;
 // 分割线距离 - webView - 底部 - 间距
UIKIT_EXTERN CGFloat const kSeparatorLineToWebViewPadding;
 // 分割线距离 - contentView - 左边间距
UIKIT_EXTERN CGFloat const kSeparatorLineLeftPadding;
 // 分割线距离 - contentView - 右边间距
UIKIT_EXTERN CGFloat const kSeparatorLineRightPadding;
 // 左边右边按钮 - 取消按钮 - 宽度
UIKIT_EXTERN CGFloat const kLeftOrRightButtonWidth;
 // 左边右边按钮 - 取消按钮 - 高度
UIKIT_EXTERN CGFloat const kLeftOrRightButtonHeight;
 // 左边右边按钮 顶部 间距
UIKIT_EXTERN CGFloat const kLeftOrRightButtonTopPadding;
 // 左边按钮 左边 间距
UIKIT_EXTERN CGFloat const kLeftButtonLeftPadding;
 // 右边按钮 右边 间距
UIKIT_EXTERN CGFloat const kRightButtonRightPadding;
 // 支付按钮 - 宽度
UIKIT_EXTERN CGFloat const kPayButtonWidth;
 // 支付按钮 - 高度
UIKIT_EXTERN CGFloat const kPayButtonHeight;
 // 支付按钮名称 - 宽度
UIKIT_EXTERN CGFloat const kPayMethodLabelWidth;
 // 支付按钮 - 顶部 - 间距
UIKIT_EXTERN CGFloat const kPayButtonTopPadding;
 // webView距离 - 标题label - 间距
UIKIT_EXTERN CGFloat const kWebViewTopPadding;
 // webView距离 - contentView - 顶部 - 间距 （没标题）
UIKIT_EXTERN CGFloat const kWebViewToContentViewPading;
 // webView距离 - contentView左边 - 间距
UIKIT_EXTERN CGFloat const kWebViewLeftPadding;
 // webView距离 - contentView右边 - 间距
UIKIT_EXTERN CGFloat const kWebViewRightPadding;
 // webView高度
UIKIT_EXTERN CGFloat const kWebViewHeight;
 // 徽章 - 长 = 宽度
UIKIT_EXTERN CGFloat const kBadgeViewWidth;
 // 徽章距离 - contentView - 顶部 -  间距
UIKIT_EXTERN CGFloat const kBadgeViewTopPadding;
 // 徽章描述文字的 顶部 = 左边 = 右边 间距
UIKIT_EXTERN CGFloat const kDesLabelPadding;


/***     Download Page      ***/
// 下载页面 - 头部控件 - pageControl - 间距
UIKIT_EXTERN CGFloat const kDownloadHeaderPageControlMargin;
// 下载页面 - 底部控件 - 系统信息Label - 高度
UIKIT_EXTERN CGFloat const kDownloadBottomStorageLabelH;
// 下载页面 - 底部控件 - 公共间距 
UIKIT_EXTERN CGFloat const kDownloadBottomMargin;
// 下载页面 - 下载中Cell - 状态文字 - 高度
UIKIT_EXTERN CGFloat const kDownloadingCellStatusLabelH;
// 下载页面 - 下载中Cell - 状态文字 - 宽度
UIKIT_EXTERN CGFloat const kDownloadingCellStatusLabelW;
// 下载页面 - Cell - 很多地方的一些间距
UIKIT_EXTERN CGFloat const kDownloadVideoMargin;
// 下载页面 - 分割线 - 高度
UIKIT_EXTERN CGFloat const kDownloadSepLineH;


/***     Lesson Detail Page      ***/
// 标签按钮 - 之间 - 间距
UIKIT_EXTERN CGFloat const kTagButtonMargin;
// 标签按钮 - 内部 - 间距
UIKIT_EXTERN CGFloat const kTagButtonPadding;



