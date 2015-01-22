//
//  DRProgressWebView.h
//  UIWebViewProgress
//
//  Created by xxsy-ima001 on 15/1/21.
//  Copyright (c) 2015年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <UIKit/UIKit.h>
///添加请求状态条和网络异常提示
@interface DRProgressWebView : UIWebView
///调用stopLoading方法也会回调 -(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error设置此变量做区别
@property (assign,nonatomic) BOOL errorIsFromStopLoading;
@property (strong,nonatomic) NSURL *loadUrl;
///判断是否有加载成功过页面，解决当前已经成功的页面被后面断网后提示信息覆盖
@property (assign,nonatomic) BOOL hasSucessesLoaded;
@end
