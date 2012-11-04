//
//  TRShareAdingRewardViewController.m
//  TeamReward
//
//  Created by Peter Arato on 11/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRShareAddingRewardViewController.h"

@interface TRShareAddingRewardViewController ()

@end

@implementation TRShareAddingRewardViewController

@synthesize delegate;

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

- (void)onClickCancel:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(shareAddingRewardDidHitClose)]) {
        [self.delegate shareAddingRewardDidHitClose];
    }
    else {
        [self.view setHidden:YES];
    }
}

- (void)onClickFacebook:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(shareAddingRewardDidHitFacebook)]) {
        [self.delegate shareAddingRewardDidHitFacebook];
    }
}

- (void)onClickTwitter:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(shareAddingRewardDidHitTwitter)]) {
        [self.delegate shareAddingRewardDidHitTwitter];
    }
}

@end
