//
//  TRMainTabBarControllerViewController.m
//  TeamReward
//
//  Created by Peter Arato on 10/7/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRMainTabBarControllerViewController.h"
#import "TRLoginViewController.h"

@interface TRMainTabBarControllerViewController ()

- (void)onNotifyChangeTabToRewardCreation;

@end

@implementation TRMainTabBarControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifyChangeTabToRewardCreation) name:kTRNotificationOpenTabRewardCreation object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TRLoginViewController *loginViewController = [TRLoginViewController sharedLoginViewController];
    [self.view addSubview:loginViewController.view];
    
//    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bgr.png"]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom action

- (void)onNotifyChangeTabToRewardCreation {
    [self setSelectedIndex:0];
}

@end
