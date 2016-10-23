//
//  PhotoCell.m
//  FlicrTest2
//
//  Created by Ivashin Dmitry on 10/18/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import "PhotoCell.h"
#import "UIImageView+LoadImage.h"

@interface PhotoCell () {
    NSURLSessionDownloadTask *downloadPhotoTask;
}

@end

@implementation PhotoCell

-(void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6;
}

-(void)setPhoto:(Photo *)photo {
    self.titleLbl.text = photo.title;
    self.descriptionLbl.text = photo.comment;
    self.authorNameLbl.text = [photo.owner uppercaseString];
    [self downloadImage:photo.imageLink];

}

-(void)downloadImage:(NSString *)URL {
    if (URL != nil) {
        NSURL *url = [NSURL URLWithString:URL];
        downloadPhotoTask = [self.photoImage loadImageWithURL:url];
    }
}

-(void)prepareForReuse {
    [super prepareForReuse];
    if (downloadPhotoTask != nil) {
        [downloadPhotoTask cancel];
        downloadPhotoTask = nil;
    }
    self.titleLbl.text = nil;
    self.descriptionLbl.text = nil;
    self.authorNameLbl.text = nil;
    self.photoImage.image = nil;
}

@end
