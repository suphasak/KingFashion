//
//  KFPersonalityResultViewController.m
//  KingFashion
//
//  Created by Anh Vu Mai on 10/18/16.
//  Copyright © 2016 Mai Anh Vu. All rights reserved.
//

#import "KFPersonalityResultViewController.h"

@interface KFPersonalityResultViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation KFPersonalityResultViewController

//-------------------------------------------------------------------------------------------------
#pragma mark - Constants
//-------------------------------------------------------------------------------------------------
static NSString *const RESOURCE_NAME_PERSONALITY_RESULT = @"personality_survey_result.html";

//-------------------------------------------------------------------------------------------------
#pragma mark - Initialization
//-------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.delegate = self;
    NSDataAsset *resultData = [[NSDataAsset alloc] initWithName:RESOURCE_NAME_PERSONALITY_RESULT];
    [self.webView loadHTMLString:[[NSString alloc] initWithData:resultData.data
                                                       encoding:NSUTF8StringEncoding]
                         baseURL:nil];
}

//-------------------------------------------------------------------------------------------------
#pragma mark - UIWebViewDelegate
//-------------------------------------------------------------------------------------------------
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
}

@end
