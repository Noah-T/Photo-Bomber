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

@property (nonatomic)NSString *accessToken;
@property (nonatomic)NSArray *photos;

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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    
    if (self.accessToken == nil) {
        [SimpleAuth authorize:@"instagram" completion:^(NSDictionary *responseObject, NSError *error) {
            
            
            //a way to access nested data
            NSString *accessToken = [responseObject objectForKey:@"credentials"][@"token"];
            [userDefaults setObject:accessToken forKey:@"accessToken"];
            
            //synchronize saves everything
            [userDefaults synchronize];
        }];
        
    } else {
        [self refresh];
                   }
    
}

-(void)refresh {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc]initWithFormat:@"https://api.instagram.com/v1/tags/photobomb/media/recent?access_token=%@", self.accessToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task =[session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSData *data = [[NSData alloc]initWithContentsOfURL:location];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

        
        //valueForKeyPath is an incredibly useful way to get at heavily nested JSON data! Hurray for learning new things.
        self.photos = [responseDictionary valueForKeyPath:@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });

        
    }];
    
    [task resume];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NATPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    //    cell.imageView.image = [UIImage imageNamed:@"dalai-lama"];
    
    //sets cell photo to corresponding photo in self.photos array
    cell.photoDictionary = self.photos[indexPath.row];
    return cell;
}

@end
