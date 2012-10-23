//
//  TRRewardFacebookShareViewController.h
//  TeamReward
//
//  Created by Peter Arato on 10/21/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString * (^ TRRewardFacebookShareCompletion)();

@interface TRRewardFacebookShareViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextView *messageTextView;

- (IBAction)onClickClose:(id)sender;
- (IBAction)onClickShare:(id)sender;

+ (void)openSharingViewControllerOn:(UIViewController *)viewController withText:(NSString *)text;
+ (BOOL)isOpen;

@end
