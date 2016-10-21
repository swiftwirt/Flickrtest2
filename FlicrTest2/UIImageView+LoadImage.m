//
//  UIImageView+LoadImage.m
//  FlicrTest2
//
//  Created by Ivashin Dmitry on 10/21/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import "UIImageView+LoadImage.h"

@implementation UIImageView (LoadImage)

-(NSURLSessionDownloadTask *)loadImageWithURL:(NSURL *)url {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downLoadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error = nil, url != nil) {
            NSData *data = [NSData dataWithContentsOfURL:url];
            if (data != nil) {
                UIImage *image = [UIImage imageWithData:data];
                if (image != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self != nil) {
                             self.image = image;
                        }
                    });
                }
            }
        }
    }];
    [downLoadTask resume];
    return downLoadTask;
}

@end

