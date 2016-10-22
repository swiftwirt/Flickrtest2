//
//  PhotosCollectionVC.m
//  FlicrTest2
//
//  Created by Ivashin Dmitry on 10/18/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import "PhotosCollectionVC.h"
#import "PhotoCell.h"
#import "PhotosLibraryAPI.h"
#import "LargeImagePopUpVC.h"

@interface PhotosCollectionVC () <UICollectionViewDelegate, UICollectionViewDataSource> {
    NSArray *testArray;
}

@end

@implementation PhotosCollectionVC

static NSString * const reuseIdentifier = @"Cell";

-(void)viewDidLoad {
    [super viewDidLoad];
    
    PhotosLibraryAPI *library = [PhotosLibraryAPI sharedInstance];
    [library getPhotos: ^(BOOL success) {
        if (success) {
            testArray = library.photos;
            [self.collectionView reloadData];
            NSLog(@"*****%lu", (unsigned long)[testArray count]);
        } else {
            [self showNetworkError];
        }
    }];
    [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return testArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];    
    Photo *photo = testArray[indexPath.row];
    cell.photo = photo;
    NSLog(@"********%@", photo.authorName);
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"ShowLarge"]) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        Photo *photo = testArray[indexPath.row];
        LargeImagePopUpVC *largeImageController = (LargeImagePopUpVC *)segue.destinationViewController;
        largeImageController.photo = photo;
    }
}

-(void)showNetworkError {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Whoops..." message:@"There was a reading error. Please check-up your internet connection and  try again." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.collectionView reloadData];
    }];
    
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
}

@end
