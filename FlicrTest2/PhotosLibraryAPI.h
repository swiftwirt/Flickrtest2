//
//  PhotosLibraryAPI.h
//  FlicrTest2
//
//  Created by Ivashin Dmitry on 10/18/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface PhotosLibraryAPI : NSObject

+(PhotosLibraryAPI *) sharedInstance;

-(id) getPhotos;

@end
