//
//  SearchTableViewController.h
//  Senate News
//
//  Created by vichhai on 9/16/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *apiKey;
@end
