//
//  CategoryViewController.m
//  Senate News
//
//  Created by vichhai on 9/21/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "CategoryViewController.h"
#import "CustomSearchTableViewCell.h"
#import "AppUtils.h"
#import "SWRevealViewController.h"
#import "ShareObject.h"
#import "ConnectionManager.h"
#import "GITSRefreshAndLoadMore.h"
#import "DetailViewController.h"
#import "ScheduleDetailTableViewController.h"
#import "UIImageView+WebCache.h"

@interface CategoryViewController () <UITableViewDataSource,UITableViewDelegate,ConnectionManagerDelegate>
{
    NSMutableArray *arrayResult;
    GITSRefreshAndLoadMore *refresh_loadmore;
    int remainPage;
    
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@end

@implementation CategoryViewController

#pragma mark - view life cycle

-(BOOL)prefersStatusBarHidden{
    return true;
}

-(void)viewWillAppear:(BOOL)animated{
    [ShareObject shareObjectManager].viewObserver = @"category";
    [ShareObject shareObjectManager].isLoadMore = false;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkToDetail:) name:@"notification" object:nil];
}

-(void)linkToDetail: (NSNotification *) notification{
    if ([([ShareObject shareObjectManager].jsonNotification)[@"type"] isEqualToString:@"2"]) {
        [self performSegueWithIdentifier:@"sDetail" sender:([ShareObject shareObjectManager].jsonNotification)[@"id"]];
    }else if ([([ShareObject shareObjectManager].jsonNotification)[@"type"] isEqualToString:@"1"]){
        [self performSegueWithIdentifier:@"detail" sender:([ShareObject shareObjectManager].jsonNotification)[@"id"]];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIButton *moreButton  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 30.0f)];
    [moreButton setImage:[UIImage imageNamed:@"munu_b.png"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"menu_b_p.png"] forState:UIControlStateHighlighted];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [moreButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    arrayResult = [[NSMutableArray alloc] init];
    [self addRefreshToView];
    
    refresh_loadmore = [[GITSRefreshAndLoadMore alloc] init];
    [refresh_loadmore addLoadMoreForTableView:_mainTableView imageName:@"load_01.png"];
    
    _mainTableView.hidden = true;
    [AppUtils showLoading:self.view];
    [self requestToserver:@"ARTICLES_L001"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request to server 
-(void)requestToserver:(NSString *)withAPIKey{
    
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    if ([withAPIKey isEqualToString:@"ARTICLES_L001"]) { // list article
        
        dataDic[@"PER_PAGE_CNT"] = @"20";
        dataDic[@"PAGE_NO"] = [NSString stringWithFormat:@"%d",[ShareObject shareObjectManager].pageCate];
        if (![AppUtils isNull:[ShareObject shareObjectManager].shareCateId]) {
            dataDic[@"CAT_ID"] = [ShareObject shareObjectManager].shareCateId;
        }
    }
    
    [ShareObject shareObjectManager].pageCate = 1;
    reqDic[@"KEY"] = withAPIKey;
    reqDic[@"REQ_DATA"] = dataDic;
    
    ConnectionManager *cont = [[ConnectionManager alloc] init];
    cont.delegate = self;
    [cont sendTranData:reqDic];
}

#pragma mark - return result
-(void)returnResult:(NSDictionary *)result withApiKey:(NSString *)apiKey{
    
    remainPage = [result[@"TOTAL_PAGE_COUNT"] intValue];
    
    if ([apiKey isEqualToString:@"ARTICLES_L001"]) {
        if ([ShareObject shareObjectManager].isLoadMore){
            [arrayResult addObjectsFromArray:result[@"RESP_DATA"][@"ART_REC"]];
            [refresh_loadmore temp:_mainTableView];
            [ShareObject shareObjectManager].isLoadMore = false;
        } else {
            if (_refreshControl) {
                [_refreshControl endRefreshing];
            }
            
            [self.view setUserInteractionEnabled:true];
            [arrayResult removeAllObjects];
            [arrayResult addObjectsFromArray:result[@"RESP_DATA"][@"ART_REC"]];
            [refresh_loadmore temp:_mainTableView];
            _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        [_mainTableView reloadData];
        
        // =---> Hide loading
        [AppUtils hideLoading:self.view];
        _mainTableView.hidden = false;
    }
}

#pragma mark - tableview datasource and delegate method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return arrayResult.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [(cell.shareLabels)[0] setFont:[UIFont fontWithName:@"KhmerOSBattambang-Bold" size:17]];
    
    [(cell.shareLabels)[0] setText:arrayResult[indexPath.row][@"ART_TITLE"]]; // set title
    
    [(cell.shareLabels)[1] setText:arrayResult[indexPath.row][@"ART_PUBLISHED_DATE"]]; // set publish date
    
    [(cell.shareLabels)[2] setText:[NSString stringWithFormat:@"By: %@",arrayResult[indexPath.row][@"ART_AUTHOR"]]]; // set author
    
    [cell.myImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.senate.gov.kh/home/%@",[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"ART_IMAGE"]]] placeholderImage:[UIImage imageNamed:@"none_photo.png"]];
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([ShareObject shareObjectManager].pageCate < remainPage) {
        [refresh_loadmore doLoadMore:self.view tableView:self.mainTableView scrollView:scrollView];
        if ([ShareObject shareObjectManager].isLoadMore == true) {
            [self requestToserver:@"ARTICLES_L001"];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detail" sender:arrayResult[indexPath.row][@"ART_ID"]];
}

#pragma mark - other methods
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
    [ShareObject shareObjectManager].pageCate = 1;
    [self requestToserver:@"ARTICLES_L001"];
}

#pragma mark - prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"detail"]) {
        DetailViewController *vc = segue.destinationViewController;
        vc.receiveData = sender;
    }else if([segue.identifier isEqualToString:@"sDetail"]){
        ScheduleDetailTableViewController *sv = segue.destinationViewController;
        sv.scheduleId = sender;
    }
}

@end
