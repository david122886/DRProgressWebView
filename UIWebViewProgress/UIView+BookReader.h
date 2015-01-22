//
//  UIView+BookReader.h
//  BookReader
//
//  Created by 颜超 on 13-5-9.
//  Copyright (c) 2013年 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BookReader)
+ (UIView *)tableViewFootView:(CGRect)frame andSel:(SEL)selector andTarget:(id)target;
///提示信息
-(void)showTipMessage:(NSString*)tipMsg;
///隐藏提示信息
-(void)hiddleTipMessage;

///提示信息
-(void)showTipMessage:(NSString*)tipMsg withRetryButtonClicked:(void (^)())retryBlock;

-(void)startLayerAnimation;

#pragma mark -
#pragma mark -- 等待状态条
///显示等待状态条
-(void)showActivityindicator;

-(void)hiddleActivityindicator;
#pragma mark -

#pragma mark -
#pragma mark -- 重新刷新按钮
///重新连接网络按钮
-(void)showReLoadButtoClicked:(void (^)())retryBlock;
-(void)hiddleReloadButton;
#pragma mark -
@end
