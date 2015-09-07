//
//  AppUtils.h
//  Senate News
//
//  Created by vichhai on 9/4/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AppUtilsDelegate;


@interface AppUtils : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic,weak) id<AppUtilsDelegate>delegate;

+(CGFloat)getDeviceScreenHeight;
+(CGFloat)getDeviceScreenWidth;
+(void)showErrorMessage:(NSString *)message;
-(void)sendTranData:(NSDictionary *)reqDictionary;
@end

@protocol AppUtilsDelegate <NSObject>
@optional

- (void)returnResult:(NSDictionary *) result;

@end
