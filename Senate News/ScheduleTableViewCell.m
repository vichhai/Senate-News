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

- (instancetype)init
{
    self = [super init];
    //if (self) {
        _subView.layer.cornerRadius = 15.0; // set as you want.
        _subView.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
        _subView.layer.borderWidth = 1.0; // set as you want.
    //}
    return self;
}
@end
