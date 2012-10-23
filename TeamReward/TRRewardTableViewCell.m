//
//  TRRewardTableViewCell.m
//  TeamReward
//
//  Created by Peter Arato on 10/17/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRRewardTableViewCell.h"
#import "TRNode.h"

static TRRewardTableViewCell *lastSwipedCell = nil;

@implementation TRRewardTableViewCell

@synthesize recipientField;
@synthesize topView;
@synthesize delegate;
@synthesize rewardNode;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe)];
        [self addGestureRecognizer:swipeGesture];
        
        UISwipeGestureRecognizer *swipeBackGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeBack)];
        swipeBackGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeBackGesture];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Custom actions

- (void)onClickFacebookShare:(id)sender {
    if (self->delegate != nil && [self->delegate respondsToSelector:@selector(TRRewardTableViewCell:DidClickedFacebookOnNode:)]) {
        [self->delegate TRRewardTableViewCell:self DidClickedFacebookOnNode:rewardNode];
    }
}

- (void)onSwipe {
    if (lastSwipedCell != nil && lastSwipedCell != self) {
        [lastSwipedCell onSwipeBack];
    }
    lastSwipedCell = self;
    
    [UIView animateWithDuration:0.3f animations:^{
        CGPoint center = CGPointMake(480.0f, self.topView.center.y);
        self.topView.center = center;
    }];
}

- (void)onSwipeBack {
    [UIView animateWithDuration:0.3f animations:^{
        CGPoint center = CGPointMake(160.0f, self.topView.center.y);
        self.topView.center = center;
    }];
}

@end
