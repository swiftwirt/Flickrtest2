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
    
}

@end

@implementation FlickrClient

-(void)performGET:(void (^)(BOOL success, NSArray *results))completionBlock {
    
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = true;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask;
    NSURL *url = [self getUserPhotosURL];
    dataTask = [session dataTaskWithURL:url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error){
        if (error == nil) {
            NSLog(@"***Success: %@", [response description]);
            NSMutableArray *results = [NSMutableArray new];
            if (data != nil) {
                NSDictionary *resultsDict = [self parseJSON:data];
                [self parseDictionary:resultsDict completion:^(Photo *result) {
                    [results addObject:result];
                    NSLog(@"***DATA LOADED items to display: %lu", (unsigned long)[results count]);
                }];
            }
            if (completionBlock != nil) completionBlock(true, results);
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                application.networkActivityIndicatorVisible = false;
            });
        } else {
            NSLog(@"***dataTaskError occured: %@", [error description]);
            application.networkActivityIndicatorVisible = false;
            completionBlock(false, nil);
        }
    }];
    [dataTask resume];
}

-(void)parseDictionary:(NSDictionary *)dictionary completion:(void (^)(Photo *result))completion {
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
            
            photo.detailURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=5a5b042d794392bb4445084e86fdcd76&photo_id=%@&format=json&nojsoncallback=1", photo.ID];
            NSLog(@"***detailURL %@", photo.detailURL);
            
            [self performGETDetails:photo completion:^(BOOL success, Photo *result) {
                completion(result);
            }];     
        }
    }
}

-(void)performGETDetails:(Photo *)photo completion:(void (^)(BOOL success, Photo* result))completion {
        NSURL *url = [NSURL URLWithString:photo.detailURL];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask;
        dataTask = [session dataTaskWithURL:url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error){
            if (error == nil) {
                NSLog(@"***Success from details: %@", [response description]);
                if (data != nil) {
                    NSDictionary *resultsDict = [self parseJSON:data];
                    Photo *result = [self parseDeatailsDictionary:resultsDict];
                    completion(true, result);
                }
            } else {
                NSLog(@"***dataTaskError occured: %@", [error description]);
            }
        }];
        [dataTask resume];
}

-(Photo *)parseDeatailsDictionary:(NSDictionary *)dictionary {
    NSDictionary *photoDetailDict = [dictionary objectForKey:@"photo"];
    NSLog(@"&&&+Success: %@", [photoDetailDict description]);
    Photo *photo = [Photo new];
    if (photoDetailDict != nil) {
        photo.ID = photoDetailDict[@"id"];
        photo.secret = photoDetailDict[@"secret"];
        photo.server = photoDetailDict[@"server"];
        photo.farm = photoDetailDict[@"farm"];
        
        NSDictionary *ownerDict = [photoDetailDict objectForKey:@"owner"];
        photo.authorName = ownerDict[@"username"];
        photo.owner = ownerDict[@"realname"];
        NSLog(@"&&&Success: %@", photo.owner);

        NSDictionary *titleDict = [photoDetailDict objectForKey:@"title"];
        photo.title = titleDict[@"_content"];
        NSLog(@"&&&Success: %@", photo.title);
        
        NSDictionary *descriptionDict = [photoDetailDict objectForKey:@"description"];
        photo.comment = descriptionDict[@"_content"];
        NSLog(@"&&&Success: %@", photo.comment);
        
        photo.imageLink = [NSString stringWithFormat:@"https://farm%li.staticflickr.com/%@/%@_%@_m.jpg", (long)[[photo farm] integerValue], photo.server, photo.ID, photo.secret];
        NSLog(@"***imageLink %@", photo.imageLink);
        
        photo.bigImageLink = [NSString stringWithFormat:@"https://farm%li.staticflickr.com/%@/%@_%@_z.jpg", (long)[[photo farm] integerValue], photo.server, photo.ID, photo.secret];
        NSLog(@"***imageLink %@", photo.imageLink);
    }
    return photo;
}

-(NSDictionary *)parseJSON:(NSData *)data {
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

-(NSURL *)getUserPhotosURL {
        NSString *urlString = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=5a5b042d794392bb4445084e86fdcd76&user_id=148287295%40N07&format=json&nojsoncallback=1";
        NSURL *url = [NSURL URLWithString:urlString];
        return url;
}

@end
