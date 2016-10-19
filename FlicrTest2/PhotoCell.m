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
    self.photoImage.image = photo.image;
}

@end
