//
//  ViewController.m
//  UIWebViewProgress
//
//  Created by xxsy-ima001 on 15/1/21.
//  Copyright (c) 2015年 ___xiaoxiangwenxue___. All rights reserved.
//

#import "ViewController.h"
#import "UIView+BookReader.h"
#import "DRProgressWebView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet DRProgressWebView *webView1;
@property (weak, nonatomic) IBOutlet DRProgressWebView *webView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView1.delegate = self;
    self.webView2.delegate = self;
    [self.webView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ios2.xxsy.net/pages2/default.aspx"]]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reTryButtonClicked:(id)sender {
    [self.webView2 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ios2.xxsy.net/pages2/default.aspx"]]];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [webView showActivityindicator];
    [webView hiddleReloadButton];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView hiddleActivityindicator];
    [webView hiddleTipMessage];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@,%d",error.localizedDescription,error.code);
    [webView hiddleActivityindicator];
    if (error.code != NSURLErrorCancelled) {
        __weak DRProgressWebView *weakWebView = (DRProgressWebView*)webView;
        [webView showReLoadButtoClicked:^{
            if (weakWebView) {
                NSString *url = [weakWebView.request.URL absoluteString];
                if (url && ![url isEqualToString:@""]) {
                   [weakWebView reload];
                }else if(weakWebView.loadUrl){
                    [weakWebView loadRequest:[NSURLRequest requestWithURL:weakWebView.loadUrl]];
                }
                
                NSLog(@"reload:%@",weakWebView.request);
            }
        }];
    }
}
@end
