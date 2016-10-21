//
//  PhotosLibraryAPI.m
//  FlicrTest2
//
//  Created by Ivashin Dmitry on 10/18/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import "PhotosLibraryAPI.h"
#import "FlickrClient.h"
#import "Photo.h"

@interface PhotosLibraryAPI() {
    FlickrClient *flickrClient;
}

@end

@implementation PhotosLibraryAPI

+(PhotosLibraryAPI *)sharedInstance {
    static PhotosLibraryAPI *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [PhotosLibraryAPI new];
    });
    return _sharedInstance;
}

-(id)init {
    if (self = [super init]) {
        flickrClient = [FlickrClient new];
        }
    return self;
}

- (void)getPhotos:(void (^)(BOOL success))completionBlock {
    [flickrClient performGET:^(BOOL success) {
        if (success) {
            self.photos = flickrClient.results;
            NSLog(@"***items to display: %lu", (unsigned long)[self.photos count]);
            completionBlock(success);
        } else {
            completionBlock(false);
            NSLog(@"!!!***items to display: %lu", (unsigned long)[self.photos count]);
        }
    }];
}

@end
