//
//  Photo.m
//  FlickrTest
//
//  Created by Ivashin Dmitry on 10/17/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import "Photo.h"

@implementation Photo

-(id) init:(NSString *)title authorName:(NSString *)authorName comment:(NSString *)comment image:(UIImage *)image {
    if ((self = [super init])) {
        self.title = title;
        self.authorName = authorName;
        self.comment = comment;
        self.image = image;
    }
    return self;
}

@end
