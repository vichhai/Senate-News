//
//  ScheduleDetailTableViewController.h
//  Senate News
//
//  Created by Jung Taesung on 2015. 9. 23..
//  Copyright (c) 2015년 GITS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleDetailTableViewController : UITableViewController

@property (nonatomic) NSString *scheduleId;
@property (strong, nonatomic) IBOutlet UITableView *detailSchedule;

@end
