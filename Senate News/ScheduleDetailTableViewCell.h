//
//  ScheduleDetailTableViewCell.h
//  Senate News
//
//  Created by Jung Taesung on 2015. 9. 23..
//  Copyright (c) 2015년 GITS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *posterLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *startLabel;
@property (strong, nonatomic) IBOutlet UILabel *endLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
