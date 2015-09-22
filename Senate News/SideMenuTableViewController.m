//
//  SideMenuTableViewController.m
//  Senate News
//
//  Created by vichhai on 9/2/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "SideMenuTableViewController.h"
#import "HomeViewController.h"
#import "ShareObject.h"

@interface SideMenuTableViewController ()
{
    NSMutableArray *arrayCategory;
}
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
    
    arrayCategory = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"arrayCategory"]];
    
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
        return 2;
    } else if (section == 1){
        return [arrayCategory count] + 1;
    } else{
        return 2;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [self setupViewForSectionHeader:@"ប្រតិទិនប្រជំុ"];
    } else if (section == 1){
        return [self setupViewForSectionHeader:@"ព័ត៌មានព្រឹទ្ធសភា"];
    } else{
        return [self setupViewForSectionHeader:@"ផ្សេងៗ"];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // remove duplicate label when scrolling
    for (UIView *v in [cell.contentView subviews]) {
        if ([v isKindOfClass:[UILabel class]])
            if (v.tag == 100) {
                [v removeFromSuperview];
            }
    }
    
    // =---> setup label
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 150, 30)];
    myLabel.textColor = [UIColor blackColor];
    myLabel.font = [UIFont systemFontOfSize:17];
    [cell.contentView addSubview:myLabel];
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                myLabel.text = @"ព្រឹទ្ធសភា";
            } else if (indexPath.row == 1){
                myLabel.text = @"អគ្គលេខាធិការដ្ឋាន";
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                myLabel.text = @"ទំព័រដើម";
            }else{
                myLabel.text = [[arrayCategory objectAtIndex:indexPath.row - 1] objectForKey:@"CAT_NAME"];
            }
            break;
        case 2:
            if (indexPath.row == 0){
                myLabel.text = @"ទំនាក់ទំនងពួកយើង";
            } else {
                myLabel.text = @"របៀបនៃការប្រើ";
            }
            break;
        default:
            break;
    }
    
    return cell;
}

-(UIView *)setupViewForSectionHeader:(NSString *)text {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,7, 20, 20)];
    if ([text isEqualToString:@"ប្រតិទិនប្រជំុ"]) {
        imageView.image = [UIImage imageNamed:@"schedule"];
    }else if ([text isEqualToString:@"ព័ត៌មានព្រឹទ្ធសភា"]){
        imageView.image = [UIImage imageNamed:@"home"];
    }else{
        imageView.image = [UIImage imageNamed:@"setting"];
    }
    [headerView addSubview:imageView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, headerView.frame.size.width - 85, 25)];
    textLabel.text = text;
    textLabel.font = [UIFont systemFontOfSize:19];
    [headerView addSubview:textLabel];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"schedule" sender:nil];
            break;
        case 1:
            
            if (indexPath.row == 0) {
                [self performSegueWithIdentifier:@"main" sender:nil];            
            }else {
                [ShareObject shareObjectManager].shareCateId = [[arrayCategory objectAtIndex:indexPath.row - 1] objectForKey:@"CAT_ID"];
                [self performSegueWithIdentifier:@"category" sender:nil];
            }
            break;
        case 2:
            break;
        default:
            break;
    }
    
    
//    [self performSegueWithIdentifier:@"abc" sender:nil];
}

@end
