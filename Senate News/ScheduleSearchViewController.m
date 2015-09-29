//
//  ScheduleSearchViewController.m
//  Senate News
//
//  Created by vichhai on 9/23/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "ScheduleSearchViewController.h"
#import "AppUtils.h"
#import "GITSRefreshAndLoadMore.h"
#import "ShareObject.h"
#import "ConnectionManager.h"
#import "ScheduleTableViewCell.h"
#import "ScheduleDetailTableViewController.h"

@interface ScheduleSearchViewController () <UISearchBarDelegate,ConnectionManagerDelegate>
{
    NSMutableArray *arrayResult;
    GITSRefreshAndLoadMore *refresh_loadmore;
    int remainPage;
    NSString *keywords;
}

@property (strong,nonatomic) UISearchBar *search;

@end

@implementation ScheduleSearchViewController

#pragma mark - view life cycle

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [ShareObject shareObjectManager].isLoadMore = false;
}

-(BOOL)prefersStatusBarHidden{
    return true;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_search becomeFirstResponder];
    [ShareObject shareObjectManager].viewObserver = @"searchView";

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // =---> search
    _search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 44)];
    _search.delegate = self;
    self.navigationItem.titleView = _search;
    
    // =---> set left menu
    [AppUtils settingLeftButton:self action:@selector(backClicked) normalImageCode:@"Back-100.png" highlightImageCode:nil];
    
    // =---> array result
    
    arrayResult = [[NSMutableArray alloc] init];
    
    [self addRefreshAndLoadMore];
    
    [ShareObject shareObjectManager].isLoadMore = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request to server
-(void)requestToserverWithKeyWord:(NSString *)keyword{
    
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    
    [dataDic setObject:@"20" forKey:@"PER_PAGE_CNT"];
    [dataDic setObject:[NSString stringWithFormat:@"%d",[ShareObject shareObjectManager].pages] forKey:@"PAGE_NO"];
    [dataDic setObject:keyword forKey:@"SEARCH_KEY_WORD"];
    
    [reqDic setObject:@"SCHEDULE_L002" forKey:@"KEY"];
    [reqDic setObject:dataDic forKey:@"REQ_DATA"];
    
    ConnectionManager *cont = [[ConnectionManager alloc] init];
    cont.delegate = self;
    [cont sendTranData:reqDic];
    
}

#pragma mark - return result
-(void)returnResult:(NSDictionary *)result withApiKey:(NSString *)apiKey{
    
    remainPage = [[result objectForKey:@"TOTAL_PAGE_COUNT"] intValue];
    
    if ([apiKey isEqual:@"SCHEDULE_L002"]) {
        
        if ([[result objectForKey:@"STATUS"] intValue] == 0) {
            [AppUtils showErrorMessage:@"គ្មានទិន្នន័យ"];
            [AppUtils hideLoading:self.view];
            
            return;
        } else {
            
            if ([ShareObject shareObjectManager].isLoadMore){
                [arrayResult addObjectsFromArray:[[result objectForKey:@"RESP_DATA"] objectForKey:@"ART_REC"]];
                [refresh_loadmore temp:self.tableView];
                [ShareObject shareObjectManager].isLoadMore = false;
            } else {
                if (self.refreshControl) {
                    [self.refreshControl endRefreshing];
                }
                
                [self.view setUserInteractionEnabled:true];
                [arrayResult removeAllObjects];
                [arrayResult addObjectsFromArray:[[result objectForKey:@"RESP_DATA"] objectForKey:@"SCH_REC"]];
                [refresh_loadmore temp:self.tableView];
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
        }
    }
    [AppUtils hideLoading:self.view];
    [self.tableView reloadData];
    self.tableView.hidden = false;
}

#pragma mark - search bar delegate method
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.search resignFirstResponder];
    searchBar.text = nil;
    searchBar.showsCancelButton = false;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = false;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [AppUtils showLoading:self.view];
    [ShareObject shareObjectManager].pages = 1;
    keywords = searchBar.text;
    [searchBar resignFirstResponder];
    [self requestToserverWithKeyWord:keywords];
    
}

#pragma mark - Table view data source and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arrayResult count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scheduleCell" forIndexPath:indexPath];
    
//    cell.titleLabel.text = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"SCH_TITLE"];
//    cell.descriptionLabel.text = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"SCH_DESCRIPTION"];
//    cell.dateLabel.text = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"SCH_PUBLISHED_DATE"];
//    cell.posterLabel.text = [NSString stringWithFormat:@"Post by: %@",[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"SCH_AUTHOR"]];
//
    [cell customCell];
    [cell customFont];
    NSString *day = [[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"SCH_EVENT_START"] componentsSeparatedByString:@" "][1];
    cell.day.text = [NSString stringWithFormat:@"ថ្ងៃទី: %@",day];
    NSString *month = [[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"SCH_EVENT_START"] componentsSeparatedByString:@" "][3];
    NSString *year = [[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"SCH_EVENT_START"] componentsSeparatedByString:@" "][5];
    cell.date.text = [NSString stringWithFormat:@"ខែ %@ ឆ្នាំ %@",month,year];
    cell.title.text = [NSString stringWithFormat:@"ប្រធានបទ: %@",[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"SCH_TITLE"]];
    cell.publish.text = [NSString stringWithFormat:@"ថ្ងៃចេញផ្សាយ: %@ / ដោយ: %@",[[arrayResult objectAtIndex:indexPath.row] objectForKey:@"SCH_PUBLISHED_DATE"], [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"SCH_AUTHOR"]];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([ShareObject shareObjectManager].pages < remainPage) {
        [refresh_loadmore doLoadMore:self.view tableView:self.tableView scrollView:scrollView];
        if ([ShareObject shareObjectManager].isLoadMore == true) {
            [self requestToserverWithKeyWord:keywords];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *scheduleId = [[arrayResult objectAtIndex:indexPath.row] objectForKey:@"SCH_ID"];
    [self performSegueWithIdentifier:@"scheduleDetail" sender:scheduleId];
}

#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"scheduleDetail"]) {
        ScheduleDetailTableViewController *sv = [segue destinationViewController];
        sv.scheduleId = sender;
    }
}

#pragma mark - refresh and load more methods

-(void)addRefreshAndLoadMore{
    
    // =---> adding refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(refreshing) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    // =---> adding load more
    // =---> load more
    refresh_loadmore = [[GITSRefreshAndLoadMore alloc] init];
    [refresh_loadmore addLoadMoreForTableView:self.tableView imageName:@"load_01.png"];
    
}

-(void)refreshing{
    
    [ShareObject shareObjectManager].pages = 1;
    [ShareObject shareObjectManager].isLoadMore = false;
    [self.view setUserInteractionEnabled:false];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
    [self requestToserverWithKeyWord:keywords];
}

#pragma mark - bar buttons action
-(void)backClicked{
    [self.search resignFirstResponder];
    [self.navigationController popViewControllerAnimated:true];
}

@end
