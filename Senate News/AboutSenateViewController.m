//
//  AboutSenateViewController.m
//  Senate News
//
//  Created by Eagles BR on 2/2/16.
//  Copyright © 2016 GITS. All rights reserved.
//

#import "AboutSenateViewController.h"
#import "SWRevealViewController.h"

@interface AboutSenateViewController ()

@end

@implementation AboutSenateViewController


-(BOOL)prefersStatusBarHidden{
    return true;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [_labelTitle setFont:[UIFont fontWithName:@"KhmerOSBattambang-Bold" size:20]];
    [_labelSubtitle setFont:[UIFont fontWithName:@"KhmerOSBattambang-Bold" size:17]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
