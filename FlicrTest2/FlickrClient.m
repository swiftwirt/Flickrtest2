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
    Photo *photo = [Photo new];
    if (photosArray != nil) {

        for (NSDictionary *item in photosArray) {
                    photo.ID = item[@"id"];
                    photo.owner = item[@"owner"];
                    photo.secret = item[@"secret"];
                    photo.server = item[@"server"];
                    photo.farm = item[@"farm"];
                    photo.title = item[@"title"];
                    [resultsArray addObject:photo];
                    NSLog(@"***objectAdded %@", [photo title]);
                }
    } else {
        NSDictionary *photoDetailDict = [dictionary objectForKey:@"photo"];
        if (photoDetailDict != nil) {
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
    }
    return resultsArray;
}

-(NSURL *) getUserPhotosURL {
        NSString *urlString = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=4e2c1ad0096be0942ed11b1e7da5348b&user_id=148287295%40N07&format=json&nojsoncallback=1&auth_token=72157674261722130-ff2241f048b2e3e6&api_sig=be1a9ce93c696bf0f5d37b65b699157d";
        NSURL *url = [NSURL URLWithString:urlString];
        return url;
}

@end
