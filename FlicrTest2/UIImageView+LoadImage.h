//
//  UIImageView+LoadImage.h
//  FlicrTest2
//
//  Created by Ivashin Dmitry on 10/21/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LoadImage)

-(NSURLSessionDownloadTask *)loadImageWithURL:(NSURL *)url;

@end
