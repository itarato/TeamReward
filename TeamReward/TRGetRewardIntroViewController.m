//
//  TRGetRewardIntroViewController.m
//  TeamReward
//
//  Created by Peter Arato on 10/28/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRGetRewardIntroViewController.h"
#import "TRRewardFacebookShareViewController.h"

@interface TRGetRewardIntroViewController ()

@end

@implementation TRGetRewardIntroViewController

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

#pragma mark -
#pragma mark Custom actions

- (void)onClickFacebook:(id)sender {
    [TRRewardFacebookShareViewController openSharingViewControllerOn:self withText:@"Shareeeee"];
}

- (void)onClickTwitter:(id)sender {
    
}

@end