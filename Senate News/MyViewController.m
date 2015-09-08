//
//  MyViewController.m
//  Senate News
//
//  Created by vichhai on 9/8/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "MyViewController.h"
#import "AppUtils.h"
@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%ld",(long)[AppUtils getOSVersion]);
    
    [AppUtils settingNavigationBarTitle:self title:@"MyViewController"];
    [AppUtils settingLeftButton:self action:@selector(back) normalImageCode:@"back_arrow_icon.png" highlightImageCode:@"back_arrow_icon.png"];
    [AppUtils settingRightButton:self action:@selector(right) normalImageCode:@"Menu-50.png" highlightImageCode:nil];
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

-(void)back{
    NSLog(@"Left Working");
}

-(void)right{
    NSLog(@"Right Working");
}

@end
