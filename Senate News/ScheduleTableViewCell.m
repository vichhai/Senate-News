//
//  ScheduleTableViewCell.m
//  Senate News
//
//  Created by Jung Taesung on 2015. 9. 22..
//  Copyright (c) 2015년 GITS. All rights reserved.
//

#import "ScheduleTableViewCell.h"

@implementation ScheduleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)customCell{
    _subView.backgroundColor = [UIColor whiteColor];
    _subView.layer.shadowRadius  = 1.5f;
    _subView.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
    _subView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    _subView.layer.shadowOpacity = 0.9f;
    _subView.layer.masksToBounds = NO;
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(-2.0f, -2.0f, -2.0f, -1000);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(_subView.bounds, shadowInsets)];
    _subView.layer.shadowPath     = shadowPath.CGPath;
}

-(void)customFont{
    _title.font = [UIFont fontWithName:@"KhmerOSBattambang-Bold" size:15];
    _day.font = [UIFont fontWithName:@"KhmerOSBattambang-Bold" size:24];
    
}
@end
