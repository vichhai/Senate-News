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
//    [NSThread sleepForTimeInterval:5.0];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    //Remote notification info
    // NSDictionary *remoteNotifiInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    
    //Accept push notification when app is not open
//    if (remoteNotifiInfo) {
////        [self application:application didReceiveRemoteNotification:remoteNotifiInfo];
//        [self handlerNotification:application didWithData:remoteNotifiInfo];
//        [ShareObject shareObjectManager].isNotification = TRUE;
//    }
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
    NSLog(@"%@", result);
    NSLog(@"%@", apiKey);
}

#pragma mark - AppDelegate

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [self handlerNotification:application didWithData:userInfo];
}

-(void)handlerNotification:(UIApplication *)application didWithData:(NSDictionary *)userInfo{
    // For swipe or tap the notification
    application.applicationIconBadgeNumber = 0;
    [ShareObject shareObjectManager].jsonNotification = userInfo[@"aps"];
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"notification" object:nil userInfo:nil];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString* token = [[[deviceToken.description
                                stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    [self registerDeviceTokens:@"DEVICE_C001" withDeviceToken:token];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Error register: %@",error);
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //[[NSNotificationCenter defaultCenter]  postNotificationName:@"notification" object:nil userInfo:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //[[NSNotificationCenter defaultCenter]  postNotificationName:@"notification" object:nil userInfo:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   // if ([ShareObject shareObjectManager].isNotification == TRUE) {
       // [[NSNotificationCenter defaultCenter]  postNotificationName:@"notification" object:nil userInfo:nil];
        NSLog(@"become active");
      //  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"rest" message:@"test" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
       // [alert show];
    //}
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
