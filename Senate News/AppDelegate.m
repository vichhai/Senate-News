//
//  AppDelegate.m
//  Senate News
//
//  Created by vichhai on 9/2/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "AppDelegate.h"
#import "AppUtils.h"
#import "ShareObject.h"
#import "ConnectionManager.h"
#import "DetailViewController.h"

@interface AppDelegate ()<ConnectionManagerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:3.0];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    NSDictionary *remoteNotif = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    // Accept push notification when app is not open
    if (remoteNotif) {
        [ShareObject shareObjectManager].jsonNotification = remoteNotif[@"aps"];
        [ShareObject shareObjectManager].isCloseME = true;
        [self handlerNotification:application didWithData:remoteNotif];
        
    }

    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        [ShareObject shareObjectManager].shareWidth = 450;
        return YES;
    }
    // =---> Check screen height
    if ([AppUtils getDeviceScreenHeight] == 736) {
        [ShareObject shareObjectManager].shareWidth = 277;
    } else if ([AppUtils getDeviceScreenHeight] == 667) {
        [ShareObject shareObjectManager].shareWidth = 257;
    } else {
        [ShareObject shareObjectManager].shareWidth = 237;
    }
    return YES;
}

// register token for push notification
-(void)registerDeviceTokens:(NSString *)apiKey withDeviceToken:(NSString *)device_token{
    
    if([apiKey isEqualToString:@"DEVICE_C001"]){
        NSMutableDictionary *requestData = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
        data[@"TOKEN"] = device_token;
        requestData[@"KEY"] = apiKey;
        requestData[@"REQ_DATA"] = data;
        ConnectionManager *cnn = [[ConnectionManager alloc]init];
        cnn.delegate = self;
        [cnn sendTranData:requestData];
    }else{
        NSLog(@"api key is invalid");
    }
}

#pragma mark - ConnectionMangerDelegate

-(void)returnResult:(NSDictionary *)result withApiKey:(NSString *)apiKey{
    
}

#pragma mark - AppDelegate

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [ShareObject shareObjectManager].jsonNotification = userInfo[@"aps"];
    [self handlerNotification:application didWithData:userInfo];
}

-(void)handlerNotification:(UIApplication *)application didWithData:(NSDictionary *)userInfo{
    // For swipe or tap the notification
    application.applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notification" object:nil];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString* token = [[[deviceToken.description
                                stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    [self registerDeviceTokens:@"DEVICE_C001" withDeviceToken:token];
    NSLog(@"Token %@",token);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Error register: %@",error);
    
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
