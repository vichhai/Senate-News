//
//  CustomTableViewCell.h
//  Senate News
//
//  Created by vichhai on 9/2/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

/*
 =---> Share label
 index: 0 =---> Title
 index: 1 =---> detail 1
 index: 2 =---> detail 2
 */
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *shareLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@end
