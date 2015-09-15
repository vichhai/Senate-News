//
//  ConnectionManager.h
//  Senate News
//
//  Created by vichhai on 9/7/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConnectionManagerDelegate;

@interface ConnectionManager : NSObject

-(void)sendTranData:(NSDictionary *)reqDictionary;
@property (nonatomic,weak) id<ConnectionManagerDelegate>delegate;

@end

@protocol ConnectionManagerDelegate <NSObject>
@optional

- (void)returnResult:(NSDictionary *) result withApiKey:(NSString *)apiKey;

@end