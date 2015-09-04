//
//  ShareObject.h
//  Senate News
//
//  Created by vichhai on 9/4/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ShareObject : NSObject


@property (nonatomic) CGFloat shareWidth;

+ (ShareObject *)shareObjectManager;
@end
