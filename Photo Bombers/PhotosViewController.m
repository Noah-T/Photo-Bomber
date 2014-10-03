//
//  PhotosViewController.m
//  Photo Bombers
//
//  Created by Noah Teshu on 10/3/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "PhotosViewController.h"
#import "NATPhotoCollectionCell.h"

@interface PhotosViewController ()

@end

@implementation PhotosViewController


- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(106.0, 106.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
   return (self = [super initWithCollectionViewLayout:layout]);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Photo Bombers";
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[NATPhotoCollectionCell class] forCellWithReuseIdentifier:@"photo"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NATPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
//    cell.imageView.image = [UIImage imageNamed:@"dalai-lama"];

    return cell;
}

@end
