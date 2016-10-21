//
//  FadeOutAnimationController.m
//  FlicrTest2
//
//  Created by Ivashin Dmitry on 10/21/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import "FadeOutAnimationController.h"

@interface FadeOutAnimationController () <UIViewControllerAnimatedTransitioning> {
    
}

@end

@implementation FadeOutAnimationController

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *view = [transitionContext viewForKey:(UITransitionContextFromViewKey)];
    if (view != nil) {
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration animations:^(void) {
            view.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
    }
}

@end

