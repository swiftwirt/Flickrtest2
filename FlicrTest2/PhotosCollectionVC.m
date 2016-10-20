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

@interface PhotosCollectionVC () <UICollectionViewDelegate, UICollectionViewDataSource> {
    NSMutableArray *testArray;
}

@end

@implementation PhotosCollectionVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    PhotosLibraryAPI *library = [PhotosLibraryAPI sharedInstance];
    [library getPhotos: ^(BOOL success) {
        testArray = library.photos;
        [self.collectionView reloadData];
        NSLog(@"*****%lu", (unsigned long)[testArray count]);
    }];
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return testArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Photo *photo = testArray[indexPath.row];
    cell.photo = photo;
    NSLog(@"********%@", photo.title);
    return cell;
}

-(void) showNetworkError {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Whoops..." message:@"There was a reading error. Please check-up your internet connection and  try again." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.collectionView reloadData];
    }];
    
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
}

@end
