//
//  ScheduleTableViewCell.h
//  Senate News
//
//  Created by Jung Taesung on 2015. 9. 22..
//  Copyright (c) 2015년 GITS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *posterLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
