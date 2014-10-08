//
//  NATPresentDetailTransition.m
//  Photo Bombers
//
//  Created by Noah Teshu on 10/8/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "NATPresentDetailTransition.h"

@implementation NATPresentDetailTransition

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //value for destination view controller
    UIViewController *detail = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //superview for views involved in animation
    UIView *containerView = [transitionContext containerView];
    
    //set detail view to be completely transparent, so it can fade in
    detail.view.alpha = 0;
    

    //add 20 pts so that the view doesn't block time, wifi, etc
    CGRect frame = containerView.bounds;
    frame.origin.y += 20;
    //make it smaller so imagme will stil be centered
    frame.size.height -= 20;
    
    detail.view.frame = frame;
    
    //add it the the container view
    [containerView addSubview:detail.view];
    
    //animated with duration of 0.3 seconds
    [UIView animateWithDuration:0.3 animations:^{
        //change detail view to alpha (fading in from 0)
        detail.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        //mark end of transition
        [transitionContext completeTransition:YES];
    }];
    
}


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    //animation time of 0.3 seconds
    return 0.3;

}



@end
