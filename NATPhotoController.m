//
//  NATPhotoController.m
//  Photo Bombers
//
//  Created by Noah Teshu on 10/7/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "NATPhotoController.h"
#import <SAMCache/SAMCache.h>
@implementation NATPhotoController

+ (void)imageForPhoto:(NSDictionary *)photoDictionary size:(NSString *)size completion:(void (^)(UIImage *))completion
{
    if (photoDictionary == nil || size == nil || completion == nil) {
        //blocks will crash if any parameters are nil, that's why this kind of check and return exit is necessary
        return;
    }
    //use a cache to prevent having to download every photo every time
    //if photo is already in cache, use it
    //if photo isn't in cache, download it and add to cache for use next time
    
    NSString *key = [[NSString alloc]initWithFormat:@"%@-%@", photoDictionary[@"id"], size];
    UIImage *image = [[SAMCache sharedCache]imageForKey:key];
    
    if (image) {
        
        //calling the completion block on the image 
        completion(image);
        return;
    }
    
    NSURL *url = [[NSURL alloc]initWithString:photoDictionary[@"images"][size][@"url"]];

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
            completion(image);
        });
    }];
    [task resume];
    

}
@end
