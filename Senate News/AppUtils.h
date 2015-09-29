//
//  AppUtils.h
//  Senate News
//
//  Created by vichhai on 9/4/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "MBProgressHUD.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppUtils : NSObject <NSURLConnectionDataDelegate>

+(CGFloat)getDeviceScreenHeight;
+(CGFloat)getDeviceScreenWidth;
+(void)showErrorMessage:(NSString *)message;


/////////////////////////////////////////////////////////////////////////////////////////////
/** set line spacing for text in label
 
 set line spacing
 
 @param string      String
 
 @param anyLabel    UILabel
 
 */
+(void)setTextViewHeight:(NSString *)string anyTextView:(UITextView *)anyTextView;

/////////////////////////////////////////////////////////////////////////////////////////////
/** set line spacing for text in label
 
 set line spacing
 
 @param string      String
 
 @param anyLabel    UILabel
 
 */
+(void)setLineHeight:(NSString *)string anyLabel:(UILabel *)anylabel;

/////////////////////////////////////////////////////////////////////////////////////////////
/** Hide loading view when finish working with server function
 
 hide loading
 
 @param anyView	UiView
 */
+(void)hideLoading:(UIView *)anyView;

/////////////////////////////////////////////////////////////////////////////////////////////
/** Show loading view when working with server function
 
 Show loading
 
 @param anyView	UiView
 */
+(void)showLoading:(UIView *)anyView;

/////////////////////////////////////////////////////////////////////////////////////////////
/** Navigation Bar Title setting function
 
 Navigation Bar Title setting
 
 @param target	UIViewController
 @param title	NSString
 */
+ (void)settingNavigationBarTitle:(id)target title:(NSString *)title;

/////////////////////////////////////////////////////////////////////////////////////////////
/** Left navigation button setting function
 
 Navigation Bar left Button setting
 
 @param target				UIViewController
 @param action				Selector receive Action
 @param normalImageCode		Normal Image Code
 @param highlightImageCode	highlight Image Code
 
 @see settingRightButton:action:normalImageCode:highlightImageCode:
 
 */
+ (void)settingLeftButton:(id)aTarget action:(SEL)aAction normalImageCode:(NSString *)aNormalImageCode highlightImageCode:(NSString *)aHighlightImageCode;

/////////////////////////////////////////////////////////////////////////////////////////////
/** Right navigation button setting function
 
 Navigation Bar Right Button setting
 
 @param target				UIViewController
 @param action				Selector receive Action
 @param normalImageCode		Normal Image Code
 @param highlightImageCode	highlight Image Code
 
 @see settingRightButton:action:normalImageCode:highlightImageCode:
 
 */
+ (void)settingRightButton:(id)aTarget action:(SEL)aAction normalImageCode:(NSString *)aNormalImageCode highlightImageCode:(NSString *)aHighlightImageCode;

/////////////////////////////////////////////////////////////////////////////////////////////
/** Checking nil object value function
 
 @param obj					Check object to nil
 @return Returns			@c YES nil @c NO assign
 */
+ (BOOL)isNull:(id) obj;

/////////////////////////////////////////////////////////////////////////////////////////////
/** get OS version on current device
 
 @return Returns			@c NSInteger OS version.
 */
+(NSInteger)getOSVersion;
@end
