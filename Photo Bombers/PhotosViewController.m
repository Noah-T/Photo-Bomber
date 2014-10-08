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
        [SimpleAuth authorize:@"instagram" options:@{@"scope": @[@"likes"]} completion:^(NSDictionary *responseObject, NSError *error) {
            
            
            //a way to access nested data
            self.accessToken = [responseObject objectForKey:@"credentials"][@"token"];
            [userDefaults setObject:self.accessToken forKey:@"accessToken"];
            
            //synchronize saves everything
            [userDefaults synchronize];
            
            [self refresh];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //photoDictionary refers to the dictionary at the indexpath of whatever was selected
    NSDictionary *photoDictionary = self.photos[indexPath.row];
    NATDetailViewController *viewController = [[NATDetailViewController alloc]init];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.transitioningDelegate = self;
    viewController.photoDictionary = photoDictionary;
    
    //this can be used to modally present view controllers
    [self presentViewController:viewController animated:YES completion:nil];
    
    
    
    }


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    //return an instance of the custom transition class
    return [[NATPresentDetailTransition alloc]init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    //return an instance of the custom transition class
    return [[NATDismissDetailTransition alloc]init];
}



@end
