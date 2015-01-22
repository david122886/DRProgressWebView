//
//  DRProgressWebView.m
//  UIWebViewProgress
//
//  Created by xxsy-ima001 on 15/1/21.
//  Copyright (c) 2015年 ___xiaoxiangwenxue___. All rights reserved.
//

#import "DRProgressWebView.h"

@interface DRProgressWebView()

@end

@implementation DRProgressWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)loadRequest:(NSURLRequest *)request{
    self.loadUrl = request.URL;
    [super loadRequest:request];
}
-(void)stopLoading{
    self.errorIsFromStopLoading = YES;
    [super stopLoading];
}

@end
