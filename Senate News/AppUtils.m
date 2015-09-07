//
//  AppUtils.m
//  Senate News
//
//  Created by vichhai on 9/4/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "AppUtils.h"


@implementation AppUtils

+(CGFloat)getDeviceScreenHeight{
    return [[UIScreen mainScreen] bounds].size.height;
}

+(CGFloat)getDeviceScreenWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+(void)showErrorMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ការណែនាំ" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

@end
