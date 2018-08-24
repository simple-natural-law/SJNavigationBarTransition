//
//  TranslateBarViewController.m
//  SJNavigationBarTransition
//
//  Created by 张诗健 on 2017/9/29.
//  Copyright © 2017年 张诗健. All rights reserved.
//

#import "TranslateBarViewController.h"

@interface TranslateBarViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end


@implementation TranslateBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.jianshu.com/p/c07de5cb4cd0"]]];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0, 0.0, 70.0, 70.0)];
    self.indicatorView.center = self.view.center;
    self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.indicatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.indicatorView.layer.cornerRadius = 5.0;
    [self.view addSubview:self.indicatorView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.indicatorView)
    {
        [self.indicatorView startAnimating];
    }
}


#pragma mark- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicatorView stopAnimating];
    
    [self.indicatorView removeFromSuperview];
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.title = title;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.indicatorView stopAnimating];
    
    [self.indicatorView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
