//
//  AboutUsViewController.m
//  Senate News
//
//  Created by Jung Taesung on 2015. 9. 25..
//  Copyright (c) 2015년 GITS. All rights reserved.
//

#import "AboutUsViewController.h"
#import "SWRevealViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

-(BOOL)prefersStatusBarHidden{
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customView:_subView];
    [self customView:_titleView];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [_menu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customView:(UIView *)view{
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowRadius  = 1.5f;
    view.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
    view.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    view.layer.shadowOpacity = 0.9f;
    view.layer.masksToBounds = NO;
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(-2.0f, -2.0f, -2.0f, -2.0f);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(view.bounds, shadowInsets)];
    view.layer.shadowPath     = shadowPath.CGPath;
}


@end
