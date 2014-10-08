//
//  NATDismissDetailTransition.m
//  Photo Bombers
//
//  Created by Noah Teshu on 10/8/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "NATDismissDetailTransition.h"

@implementation NATDismissDetailTransition

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //value for origin view controller
    UIViewController *detail = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    


    

    
    //animated with duration of 0.3 seconds
    [UIView animateWithDuration:0.3 animations:^{
        //change detail view alpha to 0 (fading out)
        detail.view.alpha = 0;
    } completion:^(BOOL finished) {
        
        //remove detail view from superview when animation is done
        [detail.view removeFromSuperview];
        //mark end of transition
        [transitionContext completeTransition:YES];
    }];
    
}


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    //animation time of 0.3 seconds
    return 0.3;
    
}

@end
