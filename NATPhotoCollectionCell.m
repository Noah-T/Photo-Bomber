//
//  NATPhotoCollectionCell.m
//  Photo Bombers
//
//  Created by Noah Teshu on 10/3/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "NATPhotoCollectionCell.h"

@implementation NATPhotoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]init];
        self.imageView.image = [UIImage imageNamed:@"Treehouse"];
        [self.contentView addSubview:self.imageView];
    }

    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //the size of the frame for the imageview will be the size of the contentview (it will take up the whole cell)
    self.imageView.frame = self.contentView.bounds;
}

@end
