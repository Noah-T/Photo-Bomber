//
//  NATPhotoController.h
//  Photo Bombers
//
//  Created by Noah Teshu on 10/7/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NATPhotoController : NSObject

+ (void)imageForPhoto:(NSDictionary *)photoDictionary size:(NSString *)size completion:(void(^)(UIImage *image))completion;


@end
