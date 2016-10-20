//
//  FlickrClient.m
//  FlicrTest2
//
//  Created by Ivashin Dmitry on 10/18/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import "FlickrClient.h"
#import "Photo.h"

@interface FlickrClient () {
    BOOL isLoading;
    NSURLSessionDataTask *dataTask;
}

@end

@implementation FlickrClient

-(void)performGET:(void (^)(BOOL success))completionBlock {
    isLoading = true;
    
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = true;
   
    
    NSURL *url = [self getUserPhotosURL];
    NSURLSession *session = [NSURLSession sharedSession];
    dataTask = [session dataTaskWithURL:url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error){
        BOOL success = false;
        if (error == nil) {
            success = true;
            NSLog(@"***Success: %@", [response description]);
            if (data != nil) {
                NSDictionary *resultsDict = [self parseJSON:data];
                self.results = [self parseDictionary:resultsDict];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                isLoading = false;
                application.networkActivityIndicatorVisible = false;
                NSLog(@"***DATA LOADED items to display: %lu", (unsigned long)[self.results count]);
                if (completionBlock != nil) completionBlock(success);
            });
        } else {
            isLoading = false;
            NSLog(@"***dataTaskError occured: %@", [error description]);
        }
    }];
    [dataTask resume];
    
}

-(void)performGETDetails:(NSMutableArray *)preResults completion:(void (^)(BOOL success))completion {
    isLoading = true;
    
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = true;
    for (Photo *photo in preResults) {
        NSURL *url = [NSURL URLWithString:[photo detailURL]];
        NSURLSession *session = [NSURLSession sharedSession];
        dataTask = [session dataTaskWithURL:url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error){
            BOOL success = false;
            if (error == nil) {
                success = true;
                NSLog(@"***Success: %@", [response description]);
                if (data != nil) {
                    NSDictionary *resultsDict = [self parseJSON:data];
                    self.details = [self parseDeatailsDictionary:resultsDict];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    isLoading = false;
                    application.networkActivityIndicatorVisible = false;
                    NSLog(@"***DATA LOADED items to display: %lu", (unsigned long)[self.results count]);
                    if (completion != nil) completion(success);
                });
            } else {
                isLoading = false;
                NSLog(@"***dataTaskError occured: %@", [error description]);
            }
        }];
        [dataTask resume];
    }
    
}

-(NSDictionary *) parseJSON:(NSData *)data {
    if (data != nil) {
        NSError *myError = nil;
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&myError];
        if (returnDict != nil) {
            NSLog(@"***JSON parsed, dict returned");
            return returnDict;
        } else {
            NSLog(@"***parseJSON hasn't returned a dictionary");
            return nil;
        }
    } else {
        NSLog(@"***parseJSONError occured");
        return nil;
    }
}

-(NSMutableArray *) parseDictionary:(NSDictionary *)dictionary {
    NSMutableArray *resultsArray = [NSMutableArray array];
    NSDictionary *photosDict = [dictionary objectForKey:@"photos"];
    NSArray *photosArray = [photosDict objectForKey:@"photo"];
    if (photosArray != nil) {
        for (NSDictionary *item in photosArray) {
                    Photo *photo = [Photo new];
                    photo.ID = item[@"id"];
                    photo.owner = item[@"owner"];
                    photo.secret = item[@"secret"];
                    photo.server = item[@"server"];
                    photo.farm = item[@"farm"];
                    photo.title = item[@"title"];
            
            photo.detailURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=161db40db683c9acd864c22d26a3454f&photo_id=%@&format=json&nojsoncallback=1&auth_token=72157675366971456-6b3f2998b3bfb1bb&api_sig=680da0b55719685125fbdbc64431afe3", photo.ID];
            NSLog(@"***detailURL %@", photo.detailURL);
            
            photo.imageLink = [NSString stringWithFormat:@"https://farm%li.staticflickr.com/%@/%@_%@_m.jpg", [[photo farm] integerValue], photo.server, photo.ID, photo.secret];
            NSLog(@"***imageLink %@", photo.imageLink);
            
            [resultsArray addObject:photo];
            NSLog(@"***objectAdded %@ %@", [photo title], [photo owner]);
        }
    }
    NSLog(@"!!!%@%@%@", resultsArray[0], resultsArray[1], resultsArray[2]);
    return resultsArray;
    
}

-(NSMutableArray *) parseDeatailsDictionary:(NSDictionary *)dictionary {
    NSMutableArray *resultsArray = [NSMutableArray array];
    NSDictionary *photoDetailDict = [dictionary objectForKey:@"photo"];
    if (photoDetailDict != nil) {
        Photo *photo = [Photo new];
            for (NSDictionary *item in photoDetailDict) {
                    photo.ID = item[@"id"];
                    photo.secret = item[@"secret"];
                    photo.server = item[@"server"];
                    photo.farm = item[@"farm"];
                
                    for (NSDictionary *ownerItem in item[@"owner"]) {
                        photo.owner = ownerItem[@"realname"];
                    }
                
                    for (NSDictionary *titleItem in item[@"title"]) {
                        photo.title = titleItem[@"_content"];
                    }
                
                    for (NSDictionary *descriptionItem in item[@"description"]) {
                        photo.comment = descriptionItem[@"_content"];
                    }
                
                    [resultsArray addObject:photo];
        }
    }
    NSLog(@"%li", resultsArray.count);
    return resultsArray;
}

-(NSURL *) getUserPhotosURL {
        NSString *urlString = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=161db40db683c9acd864c22d26a3454f&user_id=148287295%40N07&format=json&nojsoncallback=1&auth_token=72157675366971456-6b3f2998b3bfb1bb&api_sig=3a0c1b8625c1a0f3eef2e89c38456d51";
        NSURL *url = [NSURL URLWithString:urlString];
        return url;
}

@end
