//
//  LargeImagePopUpVC.h
//  FlicrTest2
//
//  Created by Ivashin Dmitry on 10/21/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface LargeImagePopUpVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *largeImageView;
@property (nonatomic) Photo *photo;

@end
