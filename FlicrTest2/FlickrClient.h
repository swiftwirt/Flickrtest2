//
//  FlickrClient.h
//  FlicrTest2
//
//  Created by Ivashin Dmitry on 10/18/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface FlickrClient : NSObject

@property NSMutableArray *results;
@property NSMutableArray *details;
-(void)performGET:(void (^)(BOOL success))completionBlock;

@end
