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

@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *publish;
@property (strong, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UILabel *status;


-(void)customCell;
-(void)customFont;
@end
