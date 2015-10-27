//
//  ScheduleDetailTableViewController.m
//  Senate News
//
//  Created by Jung Taesung on 2015. 9. 23..
//  Copyright (c) 2015년 GITS. All rights reserved.
//

#import "ScheduleDetailTableViewController.h"
#import "AppUtils.h"
#import "ConnectionManager.h"
#import "ShareObject.h"
#import "GITSRefreshAndLoadMore.h"
#import "AppUtils.h"

@interface ScheduleDetailTableViewController () <ConnectionManagerDelegate>
{
    CGFloat rowHeight;
    NSMutableDictionary *resultDic;
}
@end

@implementation ScheduleDetailTableViewController

#pragma mark - UIViewController Delegate method

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    _detailSchedule.allowsSelection = NO;
    [self.view setUserInteractionEnabled:false];
    UIButton *back  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [back setImage:[UIImage imageNamed:@"Back-100"] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:back];
    NSArray *barButtonItemArray = @[barButtonItem2];
    self.navigationItem.leftBarButtonItems = barButtonItemArray;
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [AppUtils showLoading:self.view];
    [self requestToserver:@"SCHEDULE_R001"];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:true];
    [ShareObject shareObjectManager].jsonNotification = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doDoubleTap{
    // =---> scroll tableView to the top
    [_detailSchedule scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

-(BOOL)prefersStatusBarHidden{
    return true;
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    for (UIView *v in (cell.contentView).subviews) {
        if ([v isKindOfClass:[UILabel class]] || [v isKindOfClass:[UIView class]])
            [v removeFromSuperview];
    }
    
    if (![AppUtils isNull:resultDic]) {
        [self addLabelsToCell:cell];
    }
    
    return cell;
}

#pragma mark - Request to server

-(void)requestToserver:(NSString *)withAPIKey{
    
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    if ([withAPIKey isEqualToString:@"SCHEDULE_R001"]) {
        dataDic[@"SCH_ID"] = _scheduleId;
    }
    reqDic[@"KEY"] = withAPIKey;
    reqDic[@"REQ_DATA"] = dataDic;
    ConnectionManager *cont = [[ConnectionManager alloc] init];
    cont.delegate = self;
    [cont sendTranData:reqDic];
}

-(void)returnResult:(NSDictionary *)result withApiKey:(NSString *)apiKey{
    // set data to array for looping to TableViewCell
    resultDic = [[NSMutableDictionary alloc] initWithDictionary:result[@"RESP_DATA"][@"SCH_REC"]];
    [_detailSchedule reloadData];
    [AppUtils hideLoading:self.view];
    _detailSchedule.hidden = false;
    [self.view setUserInteractionEnabled:true];
}

#pragma mark - Helper Method

-(void) addLabelsToCell:(UITableViewCell *)cell{
    CGFloat height = 0.0;
    
    // =---> topic
    UIView *containerTopic = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 140, 35)];
    
    UIImageView *imageTopic = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 25, 25)];
    imageTopic.image = [UIImage imageNamed:@"topic.png"];
    
    UILabel *labelTopic = [[UILabel alloc] initWithFrame:CGRectMake(41, 5, 90, 25)];
    labelTopic.textColor = RGB(218, 162, 53);
    labelTopic.text = @"ប្រធានបទ:";
    labelTopic.font = [UIFont systemFontOfSize:17.0];
    
    [containerTopic addSubview:imageTopic];
    [containerTopic addSubview:labelTopic];
    [cell.contentView addSubview:containerTopic];
    
    height = [self measureTextHeight:resultDic[@"SCH_TITLE"] constrainedToSize:CGSizeMake((cell.contentView.frame.size.width - 180), 2000.0f) fontSize:17.0f] * 1.9; // change
    UILabel *topic = [[UILabel alloc]initWithFrame:CGRectMake(160, containerTopic.frame.origin.y + 5, (cell.contentView.frame.size.width - 180), height)];
    topic.font = [UIFont fontWithName:@"KhmerOSBattambang-Bold" size:17];
    if (resultDic[@"SCH_TITLE"] != NULL) {
        topic.text = resultDic[@"SCH_TITLE"]; // change
        [AppUtils setLineHeight:resultDic[@"SCH_TITLE"] anyLabel:topic]; // change
    }
    topic.numberOfLines = 0;
    
    [cell.contentView addSubview:topic];
    
    // =---> Description
    UIView *containerDes = [[UIView alloc] initWithFrame:CGRectMake(10, (topic.frame.origin.y + topic.frame.size.height) + 10 , 140, 35)];
    
    UIImageView *imageDes = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 25, 25)];
    imageDes.image = [UIImage imageNamed:@"description.png"];
    
    UILabel *labelDes = [[UILabel alloc] initWithFrame:CGRectMake(41, 5, 90, 25)];
    labelDes.textColor = RGB(218, 162, 53);
    labelDes.text =  @"ព៌ណនា:";
    labelDes.font = [UIFont systemFontOfSize:17.0];
    
    [containerDes addSubview:imageDes];
    [containerDes addSubview:labelDes];
    [cell.contentView addSubview:containerDes];
    
    height = [self measureTextHeight:resultDic[@"SCH_DESCRIPTION"] constrainedToSize:CGSizeMake((cell.contentView.frame.size.width - 180), 2000.0f) fontSize:17.0f] * 1.4; // change
    UILabel *description = [[UILabel alloc]initWithFrame:CGRectMake(160,containerDes.frame.origin.y + 5, (cell.contentView.frame.size.width - 180), height)];
    if (resultDic[@"SCH_DESCRIPTION"] != NULL) {
        description.text = resultDic[@"SCH_DESCRIPTION"]; // change
        [AppUtils setLineHeight:resultDic[@"SCH_DESCRIPTION"] anyLabel:description]; // change
    }
    description.numberOfLines = 0;
    
    [cell.contentView addSubview:description];
    
    
    // =---> Location
    UIView *containerLoc = [[UIView alloc] initWithFrame:CGRectMake(10, (description.frame.origin.y + description.frame.size.height) + 10 , 140, 35)];
    
    UIImageView *imageLoc = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 25, 25)];
    imageLoc.image = [UIImage imageNamed:@"location.png"];
    
    UILabel *labelLoc = [[UILabel alloc] initWithFrame:CGRectMake(41, 5, 90, 25)];
    labelLoc.textColor = RGB(218, 162, 53);
    labelLoc.text =  @"ទីតាំង:";
    labelLoc.font = [UIFont systemFontOfSize:17.0];
    
    [containerLoc addSubview:imageLoc];
    [containerLoc addSubview:labelLoc];
    [cell.contentView addSubview:containerLoc];
    
    UILabel *location = [[UILabel alloc]initWithFrame:CGRectMake(160, (description.frame.origin.y + description.frame.size.height) + 10, (cell.contentView.frame.size.width - 180), 35)];
    if (resultDic[@"SCH_PLACE"] != NULL) {
        location.text = resultDic[@"SCH_PLACE"]; // change
    }
    
    [cell.contentView addSubview:location];
    
    // =---> start Date
    UIView *containerDate = [[UIView alloc] initWithFrame:CGRectMake(10, (location.frame.origin.y + location.frame.size.height) + 10 , 140, 35)];
    
    UIImageView *imageDate = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 25, 25)];
    imageDate.image = [UIImage imageNamed:@"calendar"];
    
    UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(41, 5, 90, 25)];
    labelDate.textColor = RGB(218, 162, 53);
    labelDate.text =  @"កាលបរិច្ឆេទ:";
    labelDate.font = [UIFont systemFontOfSize:17.0];
    
    [containerDate addSubview:imageDate];
    [containerDate addSubview:labelDate];
    [cell.contentView addSubview:containerDate];
    height = [self measureTextHeight:resultDic[@"SCH_EVENT_START"] constrainedToSize:CGSizeMake((cell.contentView.frame.size.width - 180), 2000.0f) fontSize:17.0f];
    UILabel *date = [[UILabel alloc]initWithFrame:CGRectMake(160, containerDate.frame.origin.y, (cell.contentView.frame.size.width - 170), height)];
    date.numberOfLines = 0;
    if (resultDic[@"SCH_EVENT_START"] != NULL) {
        date.text = [NSString stringWithFormat:@"ថ្ងៃទី %@ ខែ %@ ឆ្នាំ %@",[resultDic[@"SCH_EVENT_START"] componentsSeparatedByString:@" "][1],[resultDic[@"SCH_EVENT_START"] componentsSeparatedByString:@" "][3],[resultDic[@"SCH_EVENT_START"] componentsSeparatedByString:@" "][5]]; // change
    }
    
    [cell.contentView addSubview:date];
    
    // =---> Start Hour
    UIView *containerStart = [[UIView alloc] initWithFrame:CGRectMake(10, (date.frame.origin.y + date.frame.size.height) + 5 , 140, 35)];
    
    UIImageView *imageStart = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 25, 25)];
    imageStart.image = [UIImage imageNamed:@"clock.png"];
    
    UILabel *labelStart = [[UILabel alloc] initWithFrame:CGRectMake(41, 5, 90, 25)];
    labelStart.textColor = RGB(218, 162, 53);
    labelStart.text =  @"ម៉ោងចាប់ផ្ដើម";
    labelStart.font = [UIFont systemFontOfSize:17.0];
    
    [containerStart addSubview:imageStart];
    [containerStart addSubview:labelStart];
    [cell.contentView addSubview:containerStart];
    UILabel *startHour = [[UILabel alloc]initWithFrame:CGRectMake(160, containerStart.frame.origin.y , (cell.contentView.frame.size.width - 180), 35)];
    if (resultDic[@"SCH_EVENT_START"] != NULL) {
        startHour.text = [resultDic[@"SCH_EVENT_START"] substringFromIndex:41]; // change
    }
 
    [cell.contentView addSubview:startHour];
    
    // =---> Stop Hour
    UIView *containerStop = [[UIView alloc] initWithFrame:CGRectMake(10, (startHour.frame.origin.y + startHour.frame.size.height) + 10 , 140, 35)];
    
    UIImageView *imageStop = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 25, 25)];
    imageStop.image = [UIImage imageNamed:@"clock.png"];
    
    UILabel *labelStop = [[UILabel alloc] initWithFrame:CGRectMake(41, 5, 90, 25)];
    labelStop.textColor = RGB(218, 162, 53);
    labelStop.text =  @"ម៉ោងបញ្ចប់";
    labelStop.font = [UIFont systemFontOfSize:17.0];
    
    [containerStop addSubview:imageStop];
    [containerStop addSubview:labelStop];
    [cell.contentView addSubview:containerStop];
    
    UILabel *stopHour = [[UILabel alloc]initWithFrame:CGRectMake(160, containerStop.frame.origin.y ,(cell.contentView.frame.size.width - 180), 35)];
    stopHour.text = [resultDic[@"SCH_EVENT_END"] substringFromIndex:41]; // change
    
    [cell.contentView addSubview:stopHour];
    
    
    // =---> Type
    UIView *containerType = [[UIView alloc] initWithFrame:CGRectMake(10, (stopHour.frame.origin.y + stopHour.frame.size.height) + 10 , 140, 35)];
    
    UIImageView *imageType = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 25, 25)];
    imageType.image = [UIImage imageNamed:@"type.png"];
    
    UILabel *labelType = [[UILabel alloc] initWithFrame:CGRectMake(41, 5, 90, 25)];
    labelType.textColor = RGB(218, 162, 53);
    labelType.text =  @"ប្រភេទ";
    labelType.font = [UIFont systemFontOfSize:17.0];
    
    [containerType addSubview:imageType];
    [containerType addSubview:labelType];
    [cell.contentView addSubview:containerType];
    
    UILabel *type = [[UILabel alloc]initWithFrame:CGRectMake(160, containerType.frame.origin.y , (cell.contentView.frame.size.width - 180), 35)];
    if (resultDic[@"SCH_TYPE"] != NULL) {
        type.text = resultDic[@"SCH_TYPE"]; // change
    }
    
    [cell.contentView addSubview:type];
    
    rowHeight = type.frame.origin.y + 35 + 15;
}

-(void) customLabel: (UITableViewCell *) cell{
    
    // estimate geight
    CGFloat height = [self measureTextHeight:resultDic[@"SCH_TITLE"] constrainedToSize:CGSizeMake(cell.contentView.frame.size.width, 2000.0f) fontSize:17.0f] * 1.6;
    
    // =---> Title label
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, (cell.contentView.frame.size.width - 20), height)];
    titleLable.textColor = [UIColor blackColor];
    titleLable.font = [UIFont systemFontOfSize:20.0f];
    titleLable.numberOfLines = 0; // set multiline
    titleLable.text = resultDic[@"SCH_TITLE"];
    [AppUtils setLineHeight:resultDic[@"SCH_TITLE"] anyLabel:titleLable];
    titleLable.text = resultDic[@"SCH_TITLE"];
    
    // =---> Date label
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (titleLable.frame.origin.y + height) + 10, (cell.contentView.frame.size.width - 20), 21)];
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textColor = [UIColor lightGrayColor];
    if (resultDic[@"SCH_PUBLISHED_DATE"] != NULL) {
        dateLabel.text = [NSString stringWithFormat:@"កាលបរិច្ឆេតចេញផ្សាយ: %@",resultDic[@"SCH_PUBLISHED_DATE"]];
    }
    // =---> Author label
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (dateLabel.frame.origin.y + 21) + 10, (cell.contentView.frame.size.width - 20), 21)];
    authorLabel.font = [UIFont systemFontOfSize:15];
    authorLabel.textColor = [UIColor lightGrayColor];
    if (resultDic[@"SCH_AUTHOR"] != NULL) {
        authorLabel.text = [NSString stringWithFormat:@"ចេញផ្សាយដោយ: %@",resultDic[@"SCH_AUTHOR"]];
    }
    // =---> Place label
    UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (authorLabel.frame.origin.y + 21) + 10, (cell.contentView.frame.size.width - 20), 21)];
    placeLabel.font = [UIFont systemFontOfSize:15];
    placeLabel.textColor = [UIColor blackColor];
    if (resultDic[@"SCH_PLACE"] != NULL) {
        placeLabel.text = [NSString stringWithFormat:@"ទីកន្លែង: %@", resultDic[@"SCH_PLACE"]];
    }
    // =---> start hour label
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (placeLabel.frame.origin.y + 21) + 10, (cell.contentView.frame.size.width - 20), 21)];
    startLabel.font = [UIFont systemFontOfSize:15];
    startLabel.textColor = [UIColor blackColor];
    if (resultDic[@"SCH_EVENT_START"] != NULL) {
        startLabel.text = [NSString stringWithFormat:@"ចាប់ពី: %@", resultDic[@"SCH_EVENT_START"]];
    }
    // =---> stop hour label
    UILabel *stopLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (startLabel.frame.origin.y + 21) + 10, (cell.contentView.frame.size.width - 20), 21)];
    stopLabel.font = [UIFont systemFontOfSize:15];
    stopLabel.textColor = [UIColor blackColor];
    if (resultDic[@"SCH_EVENT_END"] != NULL) {
        stopLabel.text = [NSString stringWithFormat:@"ដល់: %@", resultDic[@"SCH_EVENT_END"]];
    }
    // =---> Type label
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (stopLabel.frame.origin.y + 21) + 10, (cell.contentView.frame.size.width - 20), 21)];
    typeLabel.font = [UIFont systemFontOfSize:15];
    typeLabel.textColor = [UIColor blackColor];
    if (resultDic[@"SCH_TYPE"] != NULL) {
        typeLabel.text = [NSString stringWithFormat:@"ប្រភេទរបស់: %@", resultDic[@"SCH_TYPE"]];
    }
    // =---> detail label
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (typeLabel.frame.origin.y + 21) + 10, (cell.contentView.frame.size.width - 20), 21)];
    detailLabel.font = [UIFont systemFontOfSize:16];
    detailLabel.textColor = [UIColor blackColor];
    if (resultDic[@"SCH_DESCRIPTION"] != NULL) {
        detailLabel.text = @"ពត៏មានលំអិត:";
    }
    // =---> article label
    
    height = [self measureTextHeight:resultDic[@"SCH_DESCRIPTION"] constrainedToSize:CGSizeMake(cell.contentView.frame.size.width, 2000.0f) fontSize:15.0f] * 1.7;
    
    UILabel *articleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (detailLabel.frame.origin.y + 21) + 10, (cell.contentView.frame.size.width - 20), height)];
    articleLabel.font = [UIFont systemFontOfSize:15];
    articleLabel.textColor = [UIColor blackColor];
    articleLabel.numberOfLines = 0;
    articleLabel.text = resultDic[@"SCH_DESCRIPTION"];
    
    [AppUtils setLineHeight:resultDic[@"SCH_DESCRIPTION"] anyLabel:articleLabel];

    // =---> add all labels to tableview cell
    
    [cell.contentView addSubview:titleLable];
    [cell.contentView addSubview:dateLabel];
    [cell.contentView addSubview:authorLabel];
    [cell.contentView addSubview:placeLabel];
    [cell.contentView addSubview:startLabel];
    [cell.contentView addSubview:stopLabel];
    [cell.contentView addSubview:typeLabel];
    [cell.contentView addSubview:detailLabel];
    [cell.contentView addSubview:articleLabel];
    
    rowHeight = articleLabel.frame.origin.y + height + 10;
}

#pragma mark - other method 

- (CGFloat)measureTextHeight:(NSString*)text constrainedToSize:(CGSize)constrainedToSize fontSize:(CGFloat)fontSize {
    
    CGRect rect = [text boundingRectWithSize:constrainedToSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.height;
    
}


@end
