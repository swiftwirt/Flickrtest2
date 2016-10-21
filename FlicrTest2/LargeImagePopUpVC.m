//
//  LargeImagePopUpVC.m
//  FlicrTest2
//
//  Created by Ivashin Dmitry on 10/21/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import "LargeImagePopUpVC.h"
#import "UIImageView+LoadImage.h"
#import "DimmingPresentationVC.h"
#import "FadeOutAnimationController.h"

@interface LargeImagePopUpVC () <UIViewControllerTransitioningDelegate> {
    NSURLSessionDownloadTask *downloadTask;    
}

@end

@implementation LargeImagePopUpVC

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadImage: self.photo.bigImageLink];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 15;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    gestureRecognizer.cancelsTouchesInView = false;
    [self.view addGestureRecognizer:gestureRecognizer];
}

-(void) downloadImage:(NSString *)URL {
    if (URL != nil) {
        NSURL *url = [NSURL URLWithString:URL];
        downloadTask = [self.largeImageView loadImageWithURL:url];
    }
}

-(void) close {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [FadeOutAnimationController new];
}

-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[DimmingPresentationVC alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

@end

