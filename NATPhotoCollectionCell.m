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
    
    [NATPhotoController imageForPhoto:_photoDictionary size:@"thumbnail" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc]init];
        
        
        //a nice clean way to call a method on a double-tap
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like)];
        
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];

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

-(void)like


{
    NSLog(@"Link: %@", self.photoDictionary[@"link"]);
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accessToken"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc]initWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", self.photoDictionary[@"id"], accessToken ];
    NSURL *url = [[NSURL alloc]initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"POST";

    
    //better choice than sessionDownloadTask in this choice because dataTask doesn't save data to disk. We don't need to store anything locally (like a confirmation message from the server for the like).
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        //like will only show after like has been completed on the backend
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLikeCompletion];
        });
    }];
    
    [task resume];
    //this is necessary because the default http method is GET
}

-(void)showLikeCompletion
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Liked!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [alert show];
        
        //dispatch to main queue after 1 second
        //converted to nano seconds for the compiler to process...don't have to deal with that directly
        //code inside the block executes after 1 second
        double delayInSeconds = 2.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    }

    
@end
