//
//  Photo.h
//  FlickrTest
//
//  Created by Ivashin Dmitry on 10/17/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Photo : NSObject

@property (nonatomic) NSString *ID;
@property (nonatomic) NSString *owner;
@property (nonatomic) NSString *secret;
@property (nonatomic) NSString *server;
@property (nonatomic) NSNumber *farm;


@property (nonatomic) NSString *title, *authorName, *comment;
@property (nonatomic) UIImage *image;

-(id) init:(NSString *)title authorName:(NSString *)authorName comment:(NSString *)comment image:(UIImage *)image;

@end
