//
//  AppUtils.h
//  Senate News
//
//  Created by vichhai on 9/4/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AppUtils : NSObject

+(CGFloat)getDeviceScreenHeight;
+(CGFloat)getDeviceScreenWidth;
+(void)showErrorMessage:(NSString *)message;
@end
