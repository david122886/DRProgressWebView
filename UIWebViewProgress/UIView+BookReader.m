//
//  UIView+BookReader.m
//  BookReader
//
//  Created by ZoomBin on 13-5-9.
//  Copyright (c) 2013年 ZoomBin. All rights reserved.
//

#import "UIView+BookReader.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#define kTipMessageLabeTag 999999
#define kActivityIndicatorViewTag 999899
#define kReloadViewTag 999889
#define kTipMessageLabeFontSize 25

@interface DRReloadView : UIView
@property (nonatomic,strong) UIImageView *netWorkImageView;
@property (nonatomic,strong) UIButton *reloadButton;
@end
@implementation DRReloadView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.netWorkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"online_error"]];
        self.netWorkImageView.backgroundColor = [UIColor clearColor];
        self.netWorkImageView.frame = (CGRect){CGRectGetWidth(frame)/2-60,CGRectGetHeight(frame)/2-30,120,60};
        self.netWorkImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:self.netWorkImageView];
        
        self.reloadButton = [[UIButton alloc] initWithFrame:(CGRect){0,0,120,30}];
        self.reloadButton.center = (CGPoint){self.netWorkImageView.center.x,self.netWorkImageView.center.y+10+30+15};
        self.reloadButton.backgroundColor = [UIColor clearColor];
        [self.reloadButton setImage:[UIImage imageNamed:@"wifi_retry"] forState:UIControlStateNormal];
        self.reloadButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:self.reloadButton];
    }
    return self;
}
@end

@interface UIView (private)
@property (nonatomic,strong) void (^retryBlock)();
@end

@implementation UIView (BookReader)

static char BookReaderRetryBlockKey;

-(void)setRetryBlock:(void (^)())retryBlock{
    objc_setAssociatedObject(self, &BookReaderRetryBlockKey,retryBlock,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void (^)())retryBlock{
    return objc_getAssociatedObject(self, &BookReaderRetryBlockKey);
}
+ (UIView *)tableViewFootView:(CGRect)frame andSel:(SEL)selector andTarget:(id)target
{
    UIView *footview = [[UIView alloc]initWithFrame:frame];
    [footview setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(-4, 0, frame.size.width - 4, 26)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitle:@"正在加载数据..." forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:button];
    return footview;
}


-(void)startLayerAnimation{
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setDuration:0.5];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.layer addAnimation:animation forKey:@"PushLeft"];
}
///提示信息
-(void)showTipMessage:(NSString*)tipMsg{
    if (!tipMsg || [tipMsg isEqualToString:@""]) {
        return;
    }
    [self hiddleReloadButton];
    UIButton *button = (UIButton*)[self viewWithTag:kTipMessageLabeTag];
    if (!button) {
        button = [self getShowTipButton];
        [self addSubview:button];
    }
    [button setTitle:tipMsg forState:UIControlStateNormal];
    [button setUserInteractionEnabled:NO];
    [self bringSubviewToFront:button];
    if ([self isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView*)self setScrollEnabled:NO];
    }
}

///提示信息
-(void)showTipMessage:(NSString*)tipMsg withRetryButtonClicked:(void (^)())retryBlock{
    if (!tipMsg || [tipMsg isEqualToString:@""]) {
        return;
    }
    [self hiddleReloadButton];
    self.retryBlock = retryBlock;
    UIButton *button = (UIButton*)[self viewWithTag:kTipMessageLabeTag];
    if (!button) {
        button = [self getShowTipButton];
        [self addSubview:button];
    }
    [button setUserInteractionEnabled:YES];
    [button setTitle:tipMsg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(retryButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self bringSubviewToFront:button];
    if ([self isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView*)self setScrollEnabled:NO];
    }
}

-(UIButton*)getShowTipButton{
    UIButton *button = [[UIButton alloc] initWithFrame:(CGRect){0,0,self.frame.size}];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button.tag = kTipMessageLabeTag;
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button.titleLabel setMinimumScaleFactor:0.2];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    return button;
}

-(void)retryButtonClicked{
    if (self.retryBlock) {
        self.retryBlock();
    }
}

///隐藏提示信息
-(void)hiddleTipMessage{
    self.retryBlock = nil;
    UIView *tipButton = [self viewWithTag:kTipMessageLabeTag];
    [tipButton removeFromSuperview];
    if ([self isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView*)self setScrollEnabled:YES];
    }
}

#pragma mark -
#pragma mark -- 等待状态条
///显示等待状态条
-(void)showActivityindicator{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.tag = kActivityIndicatorViewTag;
    activityView.center = self.center;
    activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    activityView.backgroundColor = [UIColor clearColor];
    [activityView startAnimating];
    [self addSubview:activityView];
    if ([self isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView*)self setScrollEnabled:NO];
    }
}

-(void)hiddleActivityindicator{
    self.retryBlock = nil;
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView*)[self viewWithTag:kActivityIndicatorViewTag];
    [activityView removeFromSuperview];
    [activityView stopAnimating];
    if ([self isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView*)self setScrollEnabled:YES];
    }
}

#pragma mark -
#pragma mark -- 重新刷新按钮
///重新连接网络按钮
-(void)showReLoadButtoClicked:(void (^)())retryBlock{
    [self hiddleTipMessage];
    self.retryBlock = retryBlock;
    DRReloadView *reloadView = (DRReloadView*)[self viewWithTag:kReloadViewTag];
    if (!reloadView) {
        reloadView = [[DRReloadView alloc] initWithFrame:self.bounds];
        reloadView.tag = kReloadViewTag;
        reloadView.backgroundColor = [UIColor whiteColor];
        reloadView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [reloadView.reloadButton addTarget:self action:@selector(retryButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:reloadView];
    }
    [self bringSubviewToFront:reloadView];
    if ([self isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView*)self setScrollEnabled:NO];
    }
}
-(void)hiddleReloadButton{
    UIView *reloadView = [self viewWithTag:kReloadViewTag];
    [reloadView removeFromSuperview];
    if ([self isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView*)self setScrollEnabled:YES];
    }
}
#pragma mark -
@end
