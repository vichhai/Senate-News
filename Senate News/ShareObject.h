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

@property (nonatomic) BOOL isLoadMore;
@property (nonatomic) CGFloat shareWidth;
@property (nonatomic) int page; // for pagination
@property (nonatomic) int pages;
@property (nonatomic) int pageCate;
@property (nonatomic) NSString *viewObserver;
@property (strong,nonatomic) NSString *shareURL;
@property (strong,nonatomic) NSString *shareCateId;

@property (nonatomic) BOOL isNotification;
@property (nonatomic) int schedulePage;
@property (nonatomic) BOOL scheduleFlag;
@property (strong, nonatomic) NSMutableDictionary *jsonNotification;
@property (nonatomic) NSString *scheduleType;

@property (nonatomic) BOOL isCloseME;

+ (ShareObject *)shareObjectManager;

@end
