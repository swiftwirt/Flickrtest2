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

//class DimmingPresentationController: UIPresentationController {
//    override func shouldRemovePresentersView() -> Bool {
//        return false
//    }
//    
//    lazy var dimmingView = GradientView(frame: CGRect.zero)
//    
//    override func presentationTransitionWillBegin() {
//        dimmingView.frame = containerView!.bounds
//        containerView!.insertSubview(dimmingView, atIndex: 0)
//        
//        dimmingView.alpha = 0
//        if let transitionCoordinator = presentedViewController.transitionCoordinator() {
//            transitionCoordinator.animateAlongsideTransition({ _ in
//                self.dimmingView.alpha = 1
//            }, completion: nil)
//        }
//    }
//    
//    override func dismissalTransitionWillBegin()  {
//        if let transitionCoordinator = presentedViewController.transitionCoordinator() {
//            transitionCoordinator.animateAlongsideTransition({ _ in
//                self.dimmingView.alpha = 0
//            }, completion: nil)
//        }
//    }
//}
