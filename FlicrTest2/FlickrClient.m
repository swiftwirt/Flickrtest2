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
    NSURLSession *session;
}

@end

@implementation FlickrClient

-(void)performGET:(void (^)(BOOL success))completionBlock {
    isLoading = true;
    
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = true;
    
    session = [NSURLSession sharedSession];
    NSURL *url = [self getUserPhotosURL];
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
    if (photosArray != nil) {
        for (NSDictionary *item in photosArray) {
                    Photo *photo = [Photo new];
                    photo.ID = item[@"id"];
                    photo.owner = item[@"owner"];
                    photo.secret = item[@"secret"];
                    photo.server = item[@"server"];
                    photo.farm = item[@"farm"];
                    photo.title = item[@"title"];
            
            photo.detailURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=27a2d25d0d6a65c0300918b8b17890b5&photo_id=%@&format=json&nojsoncallback=1&auth_token=72157675487113895-5cd473a0137d90db&api_sig=0b1239622b6dea9337d3cd611c8c6318", photo.ID];
            NSLog(@"***detailURL %@", photo.detailURL);
            
            photo.imageLink = [NSString stringWithFormat:@"https://farm%li.staticflickr.com/%@/%@_%@_m.jpg", [[photo farm] integerValue], photo.server, photo.ID, photo.secret];
            NSLog(@"***imageLink %@", photo.imageLink);
            
//            [self performGETDetails:photo completion:^(BOOL success) {
//                if (success) {
//                    NSLog(@"***objectDetails %@ %@", [photo comment], [photo authorName]);
//                }
//            }];
            [resultsArray addObject:photo];
            NSLog(@"***objectAdded %@ %@", [photo title], [photo owner]);
        }
    }
//    NSLog(@"!!!%@%@%@", resultsArray[0], resultsArray[1], resultsArray[2]);
    return resultsArray;
}

-(void)performGETDetails:(Photo *)photo completion:(void (^)(BOOL success))completion {
        NSURL *url = [NSURL URLWithString:photo.detailURL];
        NSURLSessionDataTask *dataTak = [session dataTaskWithURL:url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error){
            if (error == nil) {
                NSLog(@"***Success: %@", [response description]);
                if (data != nil) {
                    NSDictionary *resultsDict = [self parseJSON:data];
                    [self parseDeatailsDictionary:resultsDict photo:photo];
                    completion(true);
                }
            } else {
                NSLog(@"***dataTaskError occured: %@", [error description]);
            }
        }];
        [dataTak resume];
}

-(void) parseDeatailsDictionary:(NSDictionary *)dictionary photo:(Photo *)photo {
    NSDictionary *photoDetailDict = [dictionary objectForKey:@"photo"];
    NSLog(@"&&&+Success: %@", [photoDetailDict description]);
    if (photoDetailDict != nil) {
        NSDictionary *ownerDict = [photoDetailDict objectForKey:@"owner"];
        photo.owner = ownerDict[@"realname"];
        NSLog(@"&&&Success: %@", photo.owner);

        NSDictionary *titleDict = [photoDetailDict objectForKey:@"title"];
        photo.title = titleDict[@"_content"];
        NSLog(@"&&&Success: %@", photo.title);
        
        NSDictionary *descriptionDict = [photoDetailDict objectForKey:@"description"];
        photo.comment = descriptionDict[@"_content"];
        NSLog(@"&&&Success: %@", photo.comment);
    }
}

-(NSURL *) getUserPhotosURL {
        NSString *urlString = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=a9eeb7837a1b91bf45f063d5f37f7f3a&user_id=148287295%40N07&format=json&nojsoncallback=1&auth_token=72157674106489562-447bc47387b27835&api_sig=5ce642fb0b7b0d573c71665e33234d56";
        NSURL *url = [NSURL URLWithString:urlString];
        return url;
}

@end
