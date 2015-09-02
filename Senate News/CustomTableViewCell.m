//
//  CustomTableViewCell.m
//  Senate News
//
//  Created by vichhai on 9/2/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell



- (void)awakeFromNib {
    // Initialization code
    _myImageView.layer.cornerRadius = 10;
    _myImageView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
