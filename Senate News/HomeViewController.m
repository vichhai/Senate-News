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
#import "ConnectionManager.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "DXPopover.h"

@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate,ConnectionManagerDelegate,UISearchBarDelegate>
{
    NSMutableArray *arrayResult;
    GITSRefreshAndLoadMore *refresh_loadmore;
    DXPopover *popover;
    NSString *sortBy;

    int remainPage;
}

@property (nonatomic) Reachability *hostReachability;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No internet or Wifi connection!" message:@"Please turn on the cellular or connection to Wifi" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [AppUtils hideLoading:self.view];
        [alert show];
    } else {
        [AppUtils showLoading:self.view];
        [ShareObject shareObjectManager].page = 1;
        [self requestToserver:@"ARTICLES_L001"];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [ShareObject shareObjectManager].viewObserver = @"MainView";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    popover = [DXPopover popover];
    NSString *remoteHostName = @"www.apple.com";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    //[self updateInterfaceWithReachability:self.hostReachability];
    
    _mainTableView.hidden = true;
    arrayResult = [[NSMutableArray alloc] init];
    refresh_loadmore = [[GITSRefreshAndLoadMore alloc] init];
    [ShareObject shareObjectManager].page = 1;
    
    // =---> add refresh and load mor to view

    [self setupView];
    [self addRefreshToView];
    
    // =---> show loading
//    _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [AppUtils showLoading:self.view];
    
    // =---> set tap gesture for uinavigation bar
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doDoubleTap)] ;
    doubleTap.numberOfTapsRequired = 2;
    [self.navigationController.navigationBar addGestureRecognizer:doubleTap];
    
    // =---> set navigationbar color
    // self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];
    
    // =---> Creating a custom right navi bar button1
    UIButton *subButton  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [subButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    //[searchButton setImage:[UIImage imageNamed:@"Search Filled-50.png"] forState:UIControlStateHighlighted];
    [subButton addTarget:self action:@selector(subButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // =---> Creating a custom right navi bar button2
    UIButton *moreButton  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 30.0f)];
    [moreButton setImage:[UIImage imageNamed:@"munu_b.png"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"menu_b_p.png"] forState:UIControlStateHighlighted];
    
    // =---> Creating a custom right navi bar button2
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [searchButton setImage:[UIImage imageNamed:@"Search-50.png"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"Search Filled-50.png"] forState:UIControlStateHighlighted];
    [searchButton addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // =---> Make space between bar button 20 point
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 15;
    
    // =---> side menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [moreButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
    
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:subButton];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    UIBarButtonItem *barButtonItem3 = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    NSArray *barButtonItemArray = [[NSArray alloc] initWithObjects:barButtonItem3,barButtonItem1,negativeSpacer,barButtonItem2, nil];
    self.navigationItem.rightBarButtonItems = barButtonItemArray;

    // =---> request to server
    sortBy = @"id";
    [self requestToserver:@"CATEGORIES_L001"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action BarButton
-(void)searchClicked{
    
    NSLog(@"working");
    [self performSegueWithIdentifier:@"search" sender:nil];
}

-(void)subButtonAction:(id)sender{
    //create view popup view with DXPopView
    UIView *TestView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 181, 221)];
    //add label to popup
    UILabel *sortLabel = [[UILabel alloc]initWithFrame:CGRectMake(58, 15, 70, 25)];
    sortLabel.text = @"Sort by:";
    [sortLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [TestView addSubview:sortLabel];
    //add button to popup
    UIButton *sortByDate = [[UIButton alloc]initWithFrame:CGRectMake(10, 50, 75, 75)];
    [TestView addSubview:sortByDate];
    UIButton *sortByName = [[UIButton alloc]initWithFrame:CGRectMake(95, 50, 75, 75)];
    [TestView addSubview:sortByName];
    UIButton *sortByAuthor = [[UIButton alloc]initWithFrame:CGRectMake(10, 135, 75, 75)];
    [TestView addSubview:sortByAuthor];
    UIButton *sortById = [[UIButton alloc]initWithFrame:CGRectMake(95, 135, 75, 75)];
    [TestView addSubview:sortById];
    //set image to button
    [sortByDate setImage:[UIImage imageNamed:@"date_icon.png"] forState:UIControlStateNormal];
    [sortByAuthor setImage:[UIImage imageNamed:@"author_icon.png"] forState:UIControlStateNormal];
    [sortById setImage:[UIImage imageNamed:@"id_icon.png"] forState:UIControlStateNormal];
    [sortByName setImage:[UIImage imageNamed:@"character_icon.png"] forState:UIControlStateNormal];
    //add event to button
    [sortByDate addTarget:self action:@selector(sortByDate) forControlEvents:UIControlEventTouchUpInside];
    [sortByName addTarget:self action:@selector(sortByName) forControlEvents:UIControlEventTouchUpInside];
    [sortByAuthor addTarget:self action:@selector(sortByAuthor) forControlEvents:UIControlEventTouchUpInside];
    [sortById addTarget:self action:@selector(sortById) forControlEvents:UIControlEventTouchUpInside];
    //show the popup
    [popover showAtView:sender withContentView:TestView];
}
//function event of button
-(void) sortByDate{
    NSLog(@"Sort by date");
    sortBy = @"date";
    [AppUtils showLoading:self.view];
    [self sortHelping];
    [popover dismiss];
}

-(void) sortByName{
    NSLog(@"Sort by title");
    sortBy = @"title";
    [AppUtils showLoading:self.view];
    [self sortHelping];
    [popover dismiss];
}

-(void) sortByAuthor{
    NSLog(@"sort by author");
    sortBy = @"author";
    [AppUtils showLoading:self.view];
    [self sortHelping];
    [popover dismiss];
}

-(void) sortById{
    NSLog(@"Sort by ID");
    sortBy = @"id";
    [AppUtils showLoading:self.view];
    [self sortHelping];
    [popover dismiss];
}


#pragma mark - Tableview datasoruce

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayResult count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [[cell.shareLabel objectAtIndex:0] setText:[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"ART_TITLE"]]; // set title
    
    [[cell.shareLabel objectAtIndex:1] setText:[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"ART_PUBLISHED_DATE"]]; // set publish date
    
    [[cell.shareLabel objectAtIndex:2] setText:[NSString stringWithFormat:@"By: %@",[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"ART_AUTHOR"]]]; // set author
    
//    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.senate.gov.kh/home/%@",[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"ART_IMAGE"]]] placeholderImage:[UIImage imageNamed:@"none_photo.png"]]; // set image
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detail" sender:[arrayResult objectAtIndex:indexPath.row]];
}

#pragma mark - prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"detail"]) {
        DetailViewController *vc = [segue destinationViewController];
        vc.receiveData = sender;
    }
}

#pragma mark - request to server

-(void)requestToserver:(NSString *)withAPIKey{

    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    if ([withAPIKey isEqualToString:@"ARTICLES_L001"]) { // list article
        
        [dataDic setObject:@"20" forKey:@"PER_PAGE_CNT"];
        [dataDic setObject:[NSString stringWithFormat:@"%d",[ShareObject shareObjectManager].page] forKey:@"PAGE_NO"];
        [dataDic setObject:sortBy forKey:@"SORT_BY"];
        
    } else if ([withAPIKey isEqualToString:@"CATEGORIES_L001"]){
        
    }
    
    [reqDic setObject:withAPIKey forKey:@"KEY"];
    [reqDic setObject:dataDic forKey:@"REQ_DATA"];
    
    ConnectionManager *cont = [[ConnectionManager alloc] init];
    cont.delegate = self;
    [cont sendTranData:reqDic];
}

#pragma mark - return result

-(void)returnResult:(NSDictionary *)result withApiKey:(NSString *)apiKey{
    
    remainPage = [[result objectForKey:@"TOTAL_PAGE_COUNT"] intValue];
    
    if ([apiKey isEqualToString:@"ARTICLES_L001"]) {
        if ([ShareObject shareObjectManager].isLoadMore){
            [arrayResult addObjectsFromArray:[[result objectForKey:@"RESP_DATA"] objectForKey:@"ART_REC"]];
            [refresh_loadmore temp:_mainTableView];
            [ShareObject shareObjectManager].isLoadMore = false;
        } else {
            if (_refreshControl) {
                [_refreshControl endRefreshing];
            }
            
            [self.view setUserInteractionEnabled:true];
            [arrayResult removeAllObjects];
            [arrayResult addObjectsFromArray:[[result objectForKey:@"RESP_DATA"] objectForKey:@"ART_REC"]];
            [refresh_loadmore temp:_mainTableView];
            _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        [_mainTableView reloadData];
        
        // =---> Hide loading
        [AppUtils hideLoading:self.view];
        _mainTableView.hidden = false;
    
    } else if([apiKey isEqualToString:@"CATEGORIES_L001"]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:[[result objectForKey:@"RESP_DATA"]objectForKey:@"CAT_REC"] forKey:@"arrayCategory"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self requestToserver:@"ARTICLES_L001"];
    }
}

#pragma mark - other method

-(void)doDoubleTap{
    // =---> scroll tableView to the top
    [_mainTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

-(void)sortHelping{
    [arrayResult removeAllObjects];
    [ShareObject shareObjectManager].page = 1;
    [self requestToserver:@"ARTICLES_L001"];
}

#pragma mark - Refresh And Load More

-(void)addRefreshToView{
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(refreshing) forControlEvents:UIControlEventValueChanged];
    [_mainTableView addSubview:_refreshControl];
}

-(void)refreshing{
     _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
    [ShareObject shareObjectManager].isLoadMore = false;
    [self.view setUserInteractionEnabled:false];
    [ShareObject shareObjectManager].page = 1;
    [self requestToserver:@"ARTICLES_L001"];
}

-(void)setupView {
    
    // adding load more
    [refresh_loadmore addLoadMoreForTableView:_mainTableView imageName:@"load_01.png"];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([ShareObject shareObjectManager].page < remainPage) {
        [refresh_loadmore doLoadMore:self.view tableView:_mainTableView scrollView:scrollView];
        if ([ShareObject shareObjectManager].isLoadMore == true) {
             [self requestToserver:@"ARTICLES_L001"];
        }
        NSLog(@"M working............");
    }
}

@end
