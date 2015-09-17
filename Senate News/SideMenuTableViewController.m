//
//  SideMenuTableViewController.m
//  Senate News
//
//  Created by vichhai on 9/2/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "SideMenuTableViewController.h"

@interface SideMenuTableViewController ()

@end

@implementation SideMenuTableViewController

-(BOOL)prefersStatusBarHidden{
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source and delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 5;
    } else{
        return 2;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [self setupViewForSectionHeader:@"ប្រតិទិនប្រជំុ"];
    } else if (section == 1){
        return [self setupViewForSectionHeader:@"ពត៏មានព្រឹទ្ធសភា"];
    } else{
        return [self setupViewForSectionHeader:@"ផ្សេងៗ"];
    }
    //return [self setupViewForSectionHeader:@"ពត៏មានព្រឹទ្ធសភា"];
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return @"Section 1";
//    } else if (section == 1){
//        return @"Section 2";
//    } else{
//        return @"Section 3";
//    }
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = @"Hello";
    return cell;
}

-(UIView *)setupViewForSectionHeader:(NSString *)text {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    headerView.backgroundColor = [UIColor yellowColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,7, 20, 20)];
    imageView.image = [UIImage imageNamed:@"Search-50.png"];
    [headerView addSubview:imageView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, headerView.frame.size.width - 85, 25)];
    textLabel.text = text;
    
    [headerView addSubview:textLabel];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"abc" sender:nil];
}

@end
