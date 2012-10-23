//
//  TRLoginViewController.h
//  TeamReward
//
//  Created by Peter Arato on 10/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRSystemConnect;

@interface TRLoginViewController : UIViewController <RKRequestDelegate, RKObjectLoaderDelegate, UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;

- (void)checkLoginState;
- (IBAction)onClickLogin:(id)sender;
- (void)handleValidAuthentication:(TRSystemConnect *)systemConnect;
- (void)logout;
- (IBAction)onHitDoneKey:(id)sender;

+ (TRLoginViewController *)sharedLoginViewController;
+ (void)presentLoginViewControllerOn:(UIViewController *)viewController withActionBlock:(void(^)(TRLoginViewController *loginViewController))block;

@end
