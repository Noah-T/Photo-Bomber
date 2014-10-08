//
//  NATPhotoCollectionCell.h
//  Photo Bombers
//
//  Created by Noah Teshu on 10/3/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SAMCache/SAMCache.h>
#import "NATPhotoController.h"

@interface NATPhotoCollectionCell : UICollectionViewCell

@property (strong, nonatomic)UIImageView *imageView;
@property (nonatomic)NSDictionary *photoDictionary;

@end
