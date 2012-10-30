//
//  TRRewardFacebookShareViewController.m
//  TeamReward
//
//  Created by Peter Arato on 10/21/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRRewardFacebookShareViewController.h"
#import "TRFacebookConnectionManager.h"
#import <FacebookSDK/FacebookSDK.h>

static TRRewardFacebookShareViewController *sharedInstance = nil;

@interface TRRewardFacebookShareViewController ()

@end

@implementation TRRewardFacebookShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Custom actions

+ (void)openSharingViewControllerOn:(UIViewController *)viewController withText:(NSString *)text {
    if (sharedInstance == nil) {
        sharedInstance = [[TRRewardFacebookShareViewController alloc] initWithNibName:@"TRRewardFacebookShareViewController" bundle:nil];
    }
    
    [viewController presentModalViewController:sharedInstance animated:YES];
    sharedInstance.messageTextView.text = text;
}

+ (BOOL)isOpen {
    return sharedInstance.isViewLoaded && sharedInstance.view.window;
}

- (void)onClickClose:(id)sender {
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (void)onClickShare:(id)sender {
    NSDictionary *params = [NSDictionary dictionaryWithKeysAndObjects:
                            @"link", @"http://itarato.blogspot.com",
                            @"name", @"TeamReward",
                            @"caption", @"I've just received a thank you!",
                            @"description", self.messageTextView.text,
                            nil];
    [[TRFacebookConnectionManager sharedManager] publishToWall:params withCompletion:^{
        [[self presentedViewController] dismissModalViewControllerAnimated:YES];
    }];
}

@end
