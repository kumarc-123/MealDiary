//
//  WebPageVCtr.m
//  MealDiary
//
//  Created by Kumar C on 3/3/16.
//  Copyright © 2016 Kumar C. All rights reserved.
//

#import "WebPageVCtr.h"

#import "HUDUtil.h"

@interface WebPageVCtr () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@property (nonatomic, weak) IBOutlet UIButton *btnRetry;

@property (nonatomic, weak) IBOutlet UILabel *lblError;

- (IBAction)btnRetryTapped:(id)sender;

@end

@implementation WebPageVCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_btnRetry setHidden:YES];
    [_lblError setHidden:YES];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:_webUrl]];
    
    
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.title = @"MEAL DIARIES";
}

- (void) viewDidDisappear:(BOOL)animated
{
    [_webView stopLoading];
    [HUDUtil hideProgressHUD:self];
    
    [super viewDidDisappear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
//    self.navigationController.hidesBarsOnSwipe = YES;
}

- (IBAction)btnRetryTapped:(id)sender
{
    [_btnRetry setHidden:YES];
    [_lblError setHidden:YES];
    [_webView loadRequest:[NSURLRequest requestWithURL:_webUrl]];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_lblError setText:[error.userInfo valueForKey:NSLocalizedDescriptionKey]];
    [HUDUtil hideProgressHUD:self];
    [_lblError setHidden:NO];
    [_btnRetry setHidden:NO];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [HUDUtil hideProgressHUD:self];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [HUDUtil showBlockingHUD:self];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
