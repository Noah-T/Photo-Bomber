//
//  NATPhotoCollectionCell.m
//  Photo Bombers
//
//  Created by Noah Teshu on 10/3/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "NATPhotoCollectionCell.h"

@implementation NATPhotoCollectionCell

-(void)setPhotoDictionary:(NSDictionary *)photoDictionary
{
    _photoDictionary = photoDictionary;
    
    NSURL *url = [[NSURL alloc]initWithString:_photoDictionary[@"images"][@"thumbnail"][@"url"]];
    [self downloadPhotoWithURL:url];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]init];

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

-(void)downloadPhotoWithURL:(NSURL *)url {
    //use a cache to prevent having to download every photo every time
    //if photo is already in cache, use it
    //if photo isn't in cache, download it and add to cache for use next time
    
    NSString *key = [[NSString alloc]initWithFormat:@"%@-thumbnail", self.photoDictionary[@"id"]];
    UIImage *photo = [[SAMCache sharedCache]imageForKey:key];
    
    if (photo) {
        self.imageView.image = photo;
        return;
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        //path returns a string value
        NSData *imageData = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:imageData];
        [[SAMCache sharedCache]setImage:image forKey:key];
        
        
        //accesses the main queue asynchrnously
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            //because of async implementation, this will be updated as soon as the info is available
            self.imageView.image = image;
        });
    }];
    [task resume];
    

}

@end
