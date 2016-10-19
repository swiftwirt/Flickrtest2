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
    BOOL hasSearched;
}

@property NSMutableArray *results;

@end

@implementation FlickrClient

- (Photo *)getPhotos:(NSString *)url
{
    return nil;
}

- (UIImage *)downloadImage:(NSString *)url
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    return [UIImage imageWithData:data];
}

-(void)performGET:(void (^)(BOOL success))completionBlock {
    isLoading = true;
    hasSearched = true;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[self getUserPhotosURL] completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error){
        if (error == nil) {
            NSLog(@"***Success: %@", [response description]);
            if (data != nil) {
                completionBlock(true);
                NSDictionary *resultsDict = [self parseJSON:data];
                self.results = [self parseDictionary:resultsDict];
                //sort
                dispatch_async(dispatch_get_main_queue(), ^{
                   isLoading = false;
                    NSLog(@"***tableView updated");
                });
                return;
            }
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
        NSDictionary *returnDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&myError];
        if ([returnDict isKindOfClass:[NSDictionary class]]) {
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
    NSDictionary *photoDict = [dictionary objectForKey:@"photos"];
    if (photoDict != nil) {
        for (NSString *item in photoDict) {
            if ([item isEqualToString:@"photo"]) {
                    NSArray *photoItems = photoDict[photoDict];
                        for (NSDictionary *item in photoItems) {
                            Photo *photo = [Photo new];
                            photo.ID = item[@"id"];
                            photo.owner = item[@"owner"];
                            photo.secret = item[@"secret"];
                            photo.server = item[@"server"];
                            photo.farm = item[@"farm"];
                            photo.title = item[@"title"];
                            [resultsArray addObject:photo];
                            }
                    }
            }
    } else {
        NSDictionary *photoDetailDict = [dictionary objectForKey:@"photo"];
        if (photoDetailDict != nil) {
                
        }
    }
    return resultsArray;
}

-(NSURL *) getUserPhotosURL {
        NSString *urlString = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=c814b1149b2b2b254c1d89948ffc404f&user_id=148287295%40N07&format=json";
        NSURL *url = [NSURL URLWithString:urlString];
        return url;
}

@end

//MARK: - Networking
//func parseDictionary(dictionary: [String:AnyObject]) -> [SearchResult] {
//    guard let array = dictionary["aTracks"] as? [AnyObject] else {
//        //SPOTIFY
//        guard let tracksDict = dictionary["tracks"] as? [String:AnyObject] else {
//            print("***Unexpected ERROR\(dictionary)")
//            return []
//        }
//        var searchResults = [SearchResult]()
//        if let itemsDict = tracksDict["items"] as? [AnyObject] {
//            for item in itemsDict  {
//                let searchResult = SearchResult()
//                if let album = item["album"] as? [String:AnyObject] {
//                    if let album = album["name"] as? String {
//                        searchResult.album = album
//                    }
//                    if let image = album["images"] as? [AnyObject] {
//                        if let image = image[1] as? [String:AnyObject] {
//                            searchResult.albumImageLink = image["url"] as! String
//                        }
//                    }
//                }
//
//                if let artist = item["artists"] as? [AnyObject] {
//                    for artistName in artist {
//                        if let artist = artistName["name"] as? String {
//                            searchResult.artist = artist
//                        }
//                    }
//                }
//
//                if let trackName = item["name"] as? String {
//                    searchResult.track = trackName
//                }
//
//                if let trackPreviewURL = item["preview_url"] as? String {
//                    searchResult.trackDownloadLink = trackPreviewURL
//                }
//                searchResult.isFromSearchSegment = true
//                searchResults.append(searchResult)
//            }
//    }
//        return searchResults
//    }

//    var searchResults = [SearchResult]()
//    for resultDict in array {
//        let searchResult = SearchResult()
//        if let searchResultNonOpt = resultDict["album_title"] as? String {
//            searchResult.album = searchResultNonOpt
//        } else {
//            searchResult.album = "Unknown"
//            print("***No album")
//        }
//        if let searchResultNonOpt = resultDict["artist_name"] as? String {
//            searchResult.artist = searchResultNonOpt
//        } else {
//            searchResult.artist = "No info"
//            print("***No artist")
//        }
//        if let searchResultNonOpt = resultDict["track_title"] as? String {
//            searchResult.track = searchResultNonOpt
//        } else {
//    //    let url = URL(string: urlString)
//    return url!
//}

