//
//  FadePresentationVC.m
//  FlicrTest2
//
//  Created by Ivashin Dmitry on 10/21/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import "DimmingPresentationVC.h"
#import "GradientView.h"

@interface DimmingPresentationVC () {
    GradientView *fadeView;
}

@end

@implementation DimmingPresentationVC

-(BOOL)shouldRemovePresentersView {
    return false;
}

-(void)presentationTransitionWillBegin {
    fadeView = [[GradientView alloc] initWithFrame:CGRectZero];
    fadeView.frame = self.containerView.bounds;
    [self.containerView insertSubview:fadeView atIndex:0];
    fadeView.alpha = 0;
    
    if  (self.presentedViewController.transitionCoordinator != nil) {
        [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^ (id <UIViewControllerTransitionCoordinatorContext> context) {
            fadeView.alpha = 1.0;
        } completion:nil];
    }
}

-(void)dismissalTransitionWillBegin {
    if  (self.presentedViewController.transitionCoordinator != nil) {
        [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^ (id <UIViewControllerTransitionCoordinatorContext> context) {
            fadeView.alpha = 0;
        } completion:nil];
    }
}

@end

