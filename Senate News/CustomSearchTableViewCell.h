//
//  CustomSearchTableViewCell.h
//  Senate News
//
//  Created by vichhai on 9/16/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myImage;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *shareLabels;

@end
