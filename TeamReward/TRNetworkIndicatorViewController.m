//
//  TRNetworkIndicatorViewController.m
//  TeamReward
//
//  Created by Peter Arato on 10/14/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRNetworkIndicatorViewController.h"

@interface TRNetworkIndicatorViewController ()

@end

@implementation TRNetworkIndicatorViewController

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

#pragma mark Static methods

+ (TRNetworkIndicatorViewController *)sharedIndicator {
    static TRNetworkIndicatorViewController *instance;
    
    if (instance == nil) {
        instance = [[TRNetworkIndicatorViewController alloc] initWithNibName:@"TRNetworkIndicatorViewController" bundle:nil];
        instance.view.center = CGPointMake(160.0f, 240.0f);
    }
    
    return instance;
}

@end
