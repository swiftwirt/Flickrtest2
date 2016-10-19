//
//  PhotosCollectionVC.m
//  FlicrTest2
//
//  Created by Ivashin Dmitry on 10/18/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import "PhotosCollectionVC.h"
#import "PhotoCell.h"

@interface PhotosCollectionVC () <UICollectionViewDelegate, UICollectionViewDataSource> {
    NSMutableArray *testArray;
}

@end

@implementation PhotosCollectionVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    Photo *testObject = [[Photo alloc] init:@"1" authorName:@"2" comment:@"3" image:[UIImage imageNamed:@"40 10.01.04 PM.png"]];
    Photo *testObject2 = [[Photo alloc] init:@"5" authorName:@"6" comment:@"7" image:[UIImage imageNamed:@"40 10.01.04 PM.png"]];
    testArray = [NSMutableArray arrayWithObjects:testObject, testObject2, nil];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return testArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    Photo *test = testArray[indexPath.row];
    cell.photo = test;
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
