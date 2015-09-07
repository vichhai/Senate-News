//
//  ViewController.m
//  SenateProject
//
//  Created by vichhai on 8/28/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "CustomTableViewCell.h"
#import "Reachability.h"
@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@end

@implementation HomeViewController


-(BOOL)prefersStatusBarHidden{
    return true;
}

#pragma mark - check connection with Reachability

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NetworkStatus internetStatus = [reachability  currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"no internet connection" message:@"Hello" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
    return;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *remoteHostName = @"www.apple.com";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    //[self updateInterfaceWithReachability:self.hostReachability];
    

    // =---> set navigationbar color
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    
    // =---> Creating a custom right navi bar button1
    UIButton *searchButton  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 18.0f, 18.0f)];
    [searchButton setImage:[UIImage imageNamed:@"Search-50.png"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"Search Filled-50.png"] forState:UIControlStateHighlighted];

    // =---> Creating a custom right navi bar button2
    UIButton *moreButton  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 18.0f, 18.0f)];
    [moreButton setImage:[UIImage imageNamed:@"Menu-50.png"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"Menu Filled-25.png"] forState:UIControlStateHighlighted];
    
    
    // =---> Make space between bar button 20 point
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 20;
    
    // =---> side menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [moreButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
    
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:moreButton];

    NSArray *barButtonItemArray = [[NSArray alloc] initWithObjects:barButtonItem1,negativeSpacer,barButtonItem2, nil];
    self.navigationItem.rightBarButtonItems = barButtonItemArray;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview datasoruce

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [[cell.shareLabel objectAtIndex:0]setText:@"The race that produced the builders of Angkor developed slowly through the fusion of the Mon-Khmer racial groups of Southern Indochina during the first six centuries of the Christian era. Under Indian influence, two principal centers of civilization developed. The older, in the extreme south of the peninsula was called “Funan” (the name is a Chinese transliteration of the ancient Khmer form of the word “Phnom”, which means “hill”). Funan was a powerful maritime empire that ruled over all the shores of the Gulf of Siam. In the mid-sixth century,"];
    [[cell.shareLabel objectAtIndex:1] setText:@"The race that produced"];
    [[cell.shareLabel objectAtIndex:2] setText:@"Funan was a powerful"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detail" sender:nil];
}
@end
