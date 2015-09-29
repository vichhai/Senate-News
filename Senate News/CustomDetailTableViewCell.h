//
//  CustomDetailTableViewCell.h
//  Senate News
//
//  Created by vichhai on 9/3/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelAuthor;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@end
