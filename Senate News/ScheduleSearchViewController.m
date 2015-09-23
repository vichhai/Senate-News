//
//  ScheduleSearchViewController.m
//  Senate News
//
//  Created by vichhai on 9/23/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "ScheduleSearchViewController.h"
#import "AppUtils.h"

@interface ScheduleSearchViewController () <UISearchBarDelegate>

@property (strong,nonatomic) UISearchBar *search;

@end

@implementation ScheduleSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // =---> search
    _search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 44)];
    _search.delegate = self;
    self.navigationItem.titleView = _search;
    
    // =---> set left menu
    [AppUtils settingLeftButton:self action:@selector(backClicked) normalImageCode:@"Back-100.png" highlightImageCode:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backClicked{
    [self.search resignFirstResponder];
    [self.navigationController popViewControllerAnimated:true];
}

@end
