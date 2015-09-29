//
//  ScheduleDetailTableViewController.h
//  Senate News
//
//  Created by Jung Taesung on 2015. 9. 23..
//  Copyright (c) 2015년 GITS. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGB(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
@interface ScheduleDetailTableViewController : UITableViewController

@property (nonatomic) NSString *scheduleId;
@property (strong, nonatomic) IBOutlet UITableView *detailSchedule;

@end
