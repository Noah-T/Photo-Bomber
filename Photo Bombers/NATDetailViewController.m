//
//  NATDetailViewController.m
//  Photo Bombers
//
//  Created by Noah Teshu on 10/7/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "NATDetailViewController.h"

@interface NATDetailViewController ()

@property (nonatomic) UIImageView *imageView;

@end

@implementation NATDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //makes the detail controller slightly transparent, so gallery is still visible behind it 
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.view addSubview:self.imageView];
    
    [NATPhotoController imageForPhoto:self.photoDictionary size:@"standard_resolution" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipe];
    [self.view addGestureRecognizer:gesture];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGSize size = self.view.bounds.size;
    CGSize imageSize = CGSizeMake(size.width, size.width);
    
    
    //nifty bit of code that centers the image vertically
    self.imageView.frame = CGRectMake(0.0, (size.height - imageSize.height) /2.0 , imageSize.width, imageSize.height);
}


- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
