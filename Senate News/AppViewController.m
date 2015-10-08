//
//  AppViewController.m
//  Senate News
//
//  Created by Jung Taesung on 2015. 9. 25..
//  Copyright (c) 2015년 GITS. All rights reserved.
//

#import "AppViewController.h"
#import "SWRevealViewController.h"

@interface AppViewController ()

@end

@implementation AppViewController

-(BOOL)prefersStatusBarHidden{
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

@end
