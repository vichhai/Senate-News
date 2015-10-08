//
//  AppUtils.m
//  Senate News
//
//  Created by vichhai on 9/4/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "AppUtils.h"

@interface AppUtils ()

{
    NSMutableData *responseData;
}
@end

@implementation AppUtils

/////////////////////////////////////////////////////////////////////////////////////////////

+(void)setTextViewHeight:(NSString *)string anyTextView:(UITextView *)anyTextView{
    NSString *labelText = string;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.firstLineHeadIndent = 0;
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle};
    [attributedString addAttributes:attributes range:NSMakeRange(0, labelText.length)];
    anyTextView.attributedText = attributedString ;
}

/////////////////////////////////////////////////////////////////////////////////////////////

+(void)setLineHeight:(NSString *)string anyLabel:(UILabel *)anylabel {
    
    NSString *labelText = string;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.firstLineHeadIndent = 0;

    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle};
    [attributedString addAttributes:attributes range:NSMakeRange(0, labelText.length)];
    anylabel.attributedText = attributedString ;
    
}

/////////////////////////////////////////////////////////////////////////////////////////////
+(void)hideLoading:(UIView *)anyView{
    
    [MBProgressHUD hideAllHUDsForView:anyView animated:true];
}

/////////////////////////////////////////////////////////////////////////////////////////////
+(void)showLoading:(UIView *)anyView{
    // =---> show loading
    MBProgressHUD *loading = [MBProgressHUD showHUDAddedTo:anyView animated:true];
    loading.mode = MBProgressHUDModeIndeterminate;
    loading.labelText = @"Loading";
}

/////////////////////////////////////////////////////////////////////////////////////////////
+(CGFloat)getDeviceScreenHeight{
    return [UIScreen mainScreen].bounds.size.height;
}

/////////////////////////////////////////////////////////////////////////////////////////////
+(CGFloat)getDeviceScreenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

/////////////////////////////////////////////////////////////////////////////////////////////
+(void)showErrorMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ការណែនាំ" message:message delegate:nil cancelButtonTitle:@"យល់ព្រម" otherButtonTitles:nil];
    [alert show];
}

/////////////////////////////////////////////////////////////////////////////////////////////
+ (void)settingNavigationBarTitle:(id)aTarget title:(NSString *)title {
    
    if ([aTarget isKindOfClass:[UIViewController class]] == NO)
        return;
    
    UIViewController *viewController = aTarget;
    viewController.navigationItem.title = title;
}

/////////////////////////////////////////////////////////////////////////////////////////////
+ (void)settingLeftButton:(id)aTarget action:(SEL)aAction normalImageCode:(NSString *)aNormalImageCode highlightImageCode:(NSString *)aHighlightImageCode{
    
    if ([aTarget isKindOfClass:[UIViewController class]] == NO)
        return;
    
    UIViewController* calleeViewCtrl	= aTarget;
    UIImage* imgNormal					= [UIImage imageNamed:aNormalImageCode];
    
    UIButton* btnNewLeft				= [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20, 20)];
    
    btnNewLeft.tag = 10000;
    [btnNewLeft setBackgroundImage:imgNormal forState:UIControlStateNormal];
    
    if ([AppUtils isNull:aHighlightImageCode] == NO)
        [btnNewLeft setBackgroundImage:[UIImage imageNamed:aHighlightImageCode] forState:UIControlStateHighlighted];
    
    [btnNewLeft addTarget:calleeViewCtrl action:aAction forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* btnNewBarLeft					= [[UIBarButtonItem alloc] initWithCustomView:btnNewLeft];
    calleeViewCtrl.navigationItem.leftBarButtonItem	= btnNewBarLeft;
}

/////////////////////////////////////////////////////////////////////////////////////////////
+ (void)settingRightButton:(id)aTarget action:(SEL)aAction normalImageCode:(NSString *)aNormalImageCode highlightImageCode:(NSString *)aHighlightImageCode {
    if ([aTarget isKindOfClass:[UIViewController class]] == NO)
        return;
    
    if ([AppUtils isNull:aNormalImageCode] == YES)
        return;
    
    UIViewController* calleeViewCtrl	= aTarget;
    UIImage* imgNormal					= [UIImage imageNamed:aNormalImageCode];
    UIButton* btnNewRight				= [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imgNormal.size.width/2, imgNormal.size.height/2)];
    
    btnNewRight.tag = 10001;
    [btnNewRight setBackgroundImage:imgNormal forState:UIControlStateNormal];
    
    if ([AppUtils isNull:aHighlightImageCode] == NO)
        [btnNewRight setBackgroundImage:[UIImage imageNamed:aHighlightImageCode] forState:UIControlStateHighlighted];
    
    [btnNewRight addTarget:calleeViewCtrl action:aAction forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* btnNewBarRight						= [[UIBarButtonItem alloc] initWithCustomView:btnNewRight];
    calleeViewCtrl.navigationItem.rightBarButtonItem	= btnNewBarRight;
}

/////////////////////////////////////////////////////////////////////////////////////////////
+ (BOOL)isNull:(id) obj{
    if (obj == nil || obj == [NSNull null])
        return YES;
    
    if ([obj isKindOfClass:[NSString class]] == YES) {
        if ([(NSString *)obj isEqualToString:@""] == YES)
            return YES;
        
        if ([(NSString *)obj isEqualToString:@"<null>"] == YES)
            return YES;
        
        if ([(NSString *)obj isEqualToString:@"null"] == YES)
            return YES;
    }
    
    return NO;
}

/////////////////////////////////////////////////////////////////////////////////////////////
+ (NSInteger)getOSVersion {
    return [UIDevice currentDevice].systemVersion.integerValue;
}

@end
