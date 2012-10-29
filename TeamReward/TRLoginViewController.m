//
//  TRLoginViewController.m
//  TeamReward
//
//  Created by Peter Arato on 10/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRLoginViewController.h"
#import "TRSystemConnect.h"
#import "TRUser.h"

#define kTRLoginAlertButtonRegister 0
#define kTRLoginAlertButtonTryLogin 1

@interface TRLoginViewController ()

- (void)offerRegistration;

@end

@implementation TRLoginViewController

@synthesize emailField;
@synthesize passwordField;

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
    
    // Correct position due to the status bar.
    CGPoint selfPos = self.view.center;
    selfPos.y += 20;
    self.view.center = selfPos;
    
    self.emailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 42)];
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 42)];
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    
    [self checkLoginState];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Custom actions

- (void)checkLoginState {
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:kTRServicePathSystemConnect usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodPOST;
        loader.additionalHTTPHeaders = [NSDictionary dictionaryWithKeysAndObjects:@"Content-Type", @"application/x-www-form-urlencoded", nil];
        loader.delegate = self;
    }];
    
    NSLog(@"%s", __FUNCTION__);
}

- (void)onClickLogin:(id)sender {
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:kTRServicePathUserLogin usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodPOST;
        loader.delegate = self;
        loader.params = [NSDictionary dictionaryWithKeysAndObjects:
                         @"username", self.emailField.text,
                         @"password", self.passwordField.text,
                         nil];
    }];
    [self.passwordField resignFirstResponder];
    [self.emailField resignFirstResponder];
}

- (void)handleValidAuthentication:(TRSystemConnect *)systemConnect {
    [TRUser setActiveUser:systemConnect.user];
    
    if (![self.view isHidden]) {
        [self.view setHidden:YES];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTRNotificationDataRefresh object:nil];
}

- (void)logout {
    [[RKClient sharedClient] post:kTRServicePathUserLogout params:nil delegate:self];
}

- (void)onHitDoneKey:(id)sender {}

- (void)offerRegistration {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration" message:@"Seems you're new. Hit [Register] to create an account. If you already have one, choose [Re-try login]." delegate:self cancelButtonTitle:@"Register" otherButtonTitles:@"Re-try login", nil];
    [alert show];
}

#pragma mark RKRequestDelegate

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    NSLog(@"%s with path: %@", __FUNCTION__, [request resourcePath]);
    
    if (response.isJSON) {
        if ([request.resourcePath isEqualToString:kTRServicePathSystemConnect]) {
            id parsedBody = [response parsedBody:NULL];
            NSLog(@"Sessid: %@", [parsedBody objectForKey:@"sessid"]);
            NSLog(@"Full JSON: %@", [response bodyAsString]);
        }
    }
    
    if ([request.resourcePath isEqualToString:kTRServicePathUserLogout]) {
        
    }
}

- (void)request:(RKRequest *)request didReceiveResponse:(RKResponse *)response {
    NSLog(@"%s", __FUNCTION__);
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    NSLog(@"%s", __FUNCTION__);
}

- (void)requestDidCancelLoad:(RKRequest *)request {
    NSLog(@"%s", __FUNCTION__);
}

- (void)requestDidStartLoad:(RKRequest *)request {
    NSLog(@"%s", __FUNCTION__);
}

- (void)requestDidTimeout:(RKRequest *)request {
    NSLog(@"%s", __FUNCTION__);
}

- (void)requestWillPrepareForSend:(RKRequest *)request {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    if ([[objectLoader resourcePath] isEqualToString:kTRServicePathUserLogin]) {
        [self offerRegistration];
    }
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    NSLog(@"%s - %@", __FUNCTION__, objectLoader.resourcePath);
    NSLog(@"Loaded object: %@", object);
    
    if ([objectLoader wasSentToResourcePath:kTRServicePathSystemConnect]) {
        // System connect.
        TRSystemConnect *systemConnect = (TRSystemConnect *)object;
        if ([systemConnect isLoggedIn]) {
            [self handleValidAuthentication:systemConnect];
        }
    }
    else if ([objectLoader wasSentToResourcePath:kTRServicePathUserLogin]) {
        // User login.
        TRSystemConnect *systemConnect = (TRSystemConnect *)object;
        if ([systemConnect isLoggedIn]) {
            [self handleValidAuthentication:systemConnect];
        }
    }
    else if ([objectLoader wasSentToResourcePath:kTRServicePathUserRegister]) {
        [self checkLoginState];
    }
}

#pragma mark Static methods

+ (TRLoginViewController *)sharedLoginViewController {
    static TRLoginViewController *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TRLoginViewController alloc] initWithNibName:@"TRLoginViewController" bundle:nil];
    });
    
    return sharedInstance;
}

+ (void)presentLoginViewControllerOn:(UIViewController *)viewController withActionBlock:(void (^)(TRLoginViewController *))block {
    [[[TRLoginViewController sharedLoginViewController] view] setHidden:NO];
    block([TRLoginViewController sharedLoginViewController]);
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == kTRLoginAlertButtonRegister) {
        NSDictionary *params = [NSDictionary dictionaryWithKeysAndObjects:
                                @"name", self.emailField.text,
                                @"mail", self.emailField.text,
                                @"pass", self.passwordField.text,
                                @"status", [NSNumber numberWithInt:1],
                                nil];
        
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:kTRServicePathUserRegister
                                                        usingBlock:^(RKObjectLoader *loader) {
                                                            loader.method = RKRequestMethodPOST;
                                                            loader.delegate = self;
                                                            loader.params = params;
                                                            loader.additionalHTTPHeaders = [NSDictionary dictionaryWithKeysAndObjects:@"Content-Type", @"application/x-www-form-urlencoded", nil];
                                                        }];
    }
}

@end
