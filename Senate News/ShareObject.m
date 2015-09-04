//
//  ShareObject.m
//  Senate News
//
//  Created by vichhai on 9/4/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "ShareObject.h"

@implementation ShareObject


static ShareObject *shareManager = nil;


+ (ShareObject *)shareObjectManager {
    if (shareManager == nil)
        shareManager = [[ShareObject alloc] init];
    return shareManager;
}

@end
