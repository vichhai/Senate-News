//
//  ShowImageViewController.m
//  Senate News
//
//  Created by vichhai on 9/11/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "ShowImageViewController.h"

@interface ShowImageViewController ()



@end

@implementation ShowImageViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeButtonAction:(id)sender {

    [self dismissViewControllerAnimated:true completion:nil];
    
}

@end
