//
//  PhotoCell.m
//  FlicrTest2
//
//  Created by Ivashin Dmitry on 10/18/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

-(void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6;
}

-(void)setPhoto:(Photo *)photo {
    self.titleLbl.text = photo.title;
    self.descriptionLbl.text = photo.comment;
    self.authorNameLbl.text = photo.authorName;
    [self downloadImage:photo.imageLink];

}

-(void) downloadImage:(NSString *)URL {
    NSURL *url = [NSURL URLWithString: URL];
    NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
    downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoImage.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:location]];
        });    
    }];    
    [downloadPhotoTask resume];
}


@end
