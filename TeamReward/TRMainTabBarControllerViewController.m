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

@end

@implementation TRMainTabBarControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TRLoginViewController *loginViewController = [TRLoginViewController sharedLoginViewController];
    [self.view addSubview:loginViewController.view];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
