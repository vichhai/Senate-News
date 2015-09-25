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
    [AppUtils showLoading:self.view];
    [AppUtils showLoading:self.view];
    [self requestToserver:@"SCHEDULE_R001"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self customLabel:cell];
    
    
    return cell;
}

#pragma mark - Request to server

-(void)requestToserver:(NSString *)withAPIKey{
    
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    if ([withAPIKey isEqualToString:@"SCHEDULE_R001"]) {
        [dataDic setObject:_scheduleId forKey:@"SCH_ID"];
    }
    NSLog(@"%@",_scheduleId);
    [reqDic setObject:withAPIKey forKey:@"KEY"];
    [reqDic setObject:dataDic forKey:@"REQ_DATA"];
    ConnectionManager *cont = [[ConnectionManager alloc] init];
    cont.delegate = self;
    [cont sendTranData:reqDic];
}

-(void)returnResult:(NSDictionary *)result withApiKey:(NSString *)apiKey{
    // set data to array for looping to TableViewCell
        resultDic = [[NSMutableDictionary alloc] initWithDictionary:[[result objectForKey:@"RESP_DATA"] objectForKey:@"SCH_REC"]];
    NSLog(@"%@",resultDic);
    [_detailSchedule reloadData];
    [AppUtils hideLoading:self.view];
    _detailSchedule.hidden = false;
}

#pragma mark - Helper Method

-(void) customLabel: (UITableViewCell *) cell{
    
    // estimate geight
    CGFloat height = [self measureTextHeight:@"មាជិកាគណៈកម្មការទី២ព្រឹទ្ធសភា និងជាសមាជិកាក្រុមសមាជិកព្រឹទ្ធសភាប្រ ចាំភូមិភាគទី៨ ព្រមទាំងបុត្រាបុត្រី និងចៅ ឯកឧត្តមឧត្តមសេណីយ៍ឯក សៀក សុជាតិ និងឯកឧត្តម ជាសមាជិកព្រឹទ្ធសភា មាជិកាគណៈកម្មការទី២ព្រឹទ្ធសភា" constrainedToSize:CGSizeMake(cell.contentView.frame.size.width, 2000.0f) fontSize:17.0f] * 1.6;
    
    // =---> Title label
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, (cell.contentView.frame.size.width - 20), height)];
    titleLable.textColor = [UIColor blackColor];
    titleLable.font = [UIFont systemFontOfSize:20.0f];
    titleLable.numberOfLines = 0; // set multiline
    titleLable.text = @"មាជិកាគណៈកម្មការទី២ព្រឹទ្ធសភា និងជាសមាជិកាក្រុមសមាជិកព្រឹទ្ធសភាប្រ ចាំភូមិភាគទី៨ ព្រមទាំងបុត្រាបុត្រី និងចៅ ឯកឧត្តមឧត្តមសេណីយ៍ឯក សៀ សុជាតិ និងឯកឧត្តម ជាសមាជិកព្រឹទ្ធសភា មាជិកាគណៈកម្មការទី២ព្រឹទ្ធសភា";
    [AppUtils setLineHeight:@"មាជិកាគណៈកម្មការទី២ព្រឹទ្ធសភា និងជាសមាជិកាក្រុមសមាជិកព្រឹទ្ធសភាប្រ ចាំភូមិភាគទី៨ ព្រមទាំងបុត្រាបុត្រី និងចៅ ឯកឧត្តមឧត្តមសេណីយ៍ឯក សៀក សុជាតិ និងឯកឧត្តម ជាសមាជិកព្រឹទ្ធសភា" anyLabel:titleLable];
    //if ([resultDic objectForKey:@"SCH_TITLE"] != NULL) {
        titleLable.text = [resultDic objectForKey:@"SCH_TITLE"];
    //}
    // =---> Date label
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (titleLable.frame.origin.y + height) + 10, (cell.contentView.frame.size.width - 20), 21)];
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textColor = [UIColor lightGrayColor];
    if ([resultDic objectForKey:@"SCH_PUBLISHED_DATE"] != NULL) {
        dateLabel.text = [NSString stringWithFormat:@"កាលបរិច្ឆេតចេញផ្សាយ: %@",[resultDic objectForKey:@"SCH_PUBLISHED_DATE"]];
    }
    // =---> Author label
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (dateLabel.frame.origin.y + 21) + 10, (cell.contentView.frame.size.width - 20), 21)];
    authorLabel.font = [UIFont systemFontOfSize:15];
    authorLabel.textColor = [UIColor lightGrayColor];
    if ([resultDic objectForKey:@"SCH_AUTHOR"] != NULL) {
        authorLabel.text = [NSString stringWithFormat:@"ចេញផ្សាយដោយ: %@",[resultDic objectForKey:@"SCH_AUTHOR"]];
    }
    // =---> Place label
    UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (authorLabel.frame.origin.y + 21) + 10, (cell.contentView.frame.size.width - 20), 21)];
    placeLabel.font = [UIFont systemFontOfSize:15];
    placeLabel.textColor = [UIColor blackColor];
    if ([resultDic objectForKey:@"SCH_PLACE"] != NULL) {
        placeLabel.text = [NSString stringWithFormat:@"ទីកន្លែង: %@", [resultDic objectForKey:@"SCH_PLACE"]];
    }
    // =---> start hour label
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (placeLabel.frame.origin.y + 21) + 10, (cell.contentView.frame.size.width - 20), 21)];
    startLabel.font = [UIFont systemFontOfSize:15];
    startLabel.textColor = [UIColor blackColor];
    if ([resultDic objectForKey:@"SCH_EVENT_START"] != NULL) {
        startLabel.text = [NSString stringWithFormat:@"ចាប់ពី: %@", [resultDic objectForKey:@"SCH_EVENT_START"]];
    }
    // =---> stop hour label
    UILabel *stopLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (startLabel.frame.origin.y + 21) + 10, (cell.contentView.frame.size.width - 20), 21)];
    stopLabel.font = [UIFont systemFontOfSize:15];
    stopLabel.textColor = [UIColor blackColor];
    if ([resultDic objectForKey:@"SCH_EVENT_END"] != NULL) {
        stopLabel.text = [NSString stringWithFormat:@"ដល់: %@", [resultDic objectForKey:@"SCH_EVENT_END"]];
    }
    // =---> Type label
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (stopLabel.frame.origin.y + 21) + 10, (cell.contentView.frame.size.width - 20), 21)];
    typeLabel.font = [UIFont systemFontOfSize:15];
    typeLabel.textColor = [UIColor blackColor];
    if ([resultDic objectForKey:@"SCH_TYPE"] != NULL) {
        typeLabel.text = [NSString stringWithFormat:@"ប្រភេទរបស់: %@", [resultDic objectForKey:@"SCH_TYPE"]];
    }
    // =---> detail label
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (typeLabel.frame.origin.y + 21) + 10, (cell.contentView.frame.size.width - 20), 21)];
    detailLabel.font = [UIFont systemFontOfSize:16];
    detailLabel.textColor = [UIColor blackColor];
    if ([resultDic objectForKey:@"SCH_DESCRIPTION"] != NULL) {
        detailLabel.text = @"ពត៏មានលំអិត:";
    }
    // =---> article label
    
    height = [self measureTextHeight:@"មាជិកាគណៈកម្មការទី២ព្រឹទ្ធសភា និងជាសមាជិកាក្រុមសមាជិកព្រឹទ្ធសភាប្រ ចាំភូមិភាគទី៨ ព្រមទាំងបុត្រាបុត្រី និងចៅ ឯកឧត្តមឧត្តមសេណីយ៍ឯក សៀក សុជាតិ និងឯកឧត្តម ជាសមាជិកព្រឹទ្ធសភា បានវេរប្រគេនទេយ្យទានដល់ព្រះសង្ឃដែលនិមន្តមកពីវត្តទាំង៤៣វត្ត ដោយក្នុងមួយវត្តៗរួមមាន៖ ទៀនវស្សា០១គូ អង្ករ៥០គីឡូក្រាម ឆៃប៉ូវ៥គីឡូក្រាម សៀងផ្អែម ៥គីឡូក្រាម ពងទាប្រៃ៥០គ្រាប កាហ្វេ២ប្រអប់ ខ្ទឹមស១គីឡូក្រាម ប៊ីចេង១គីឡូក្រាម ធូប២ដុំ មី២កេស ត្រីខ២យួរ ទឹកបរិសុទ្ធ២កេស ទឹកក្រូច១កេស ទឹកផ្លែឈើ១កេស ទឹកត្រី២យួរ ទឹកស៊ីអ៊ីវ២យួរ ស្លាដក១ បច្ច័យ១០០.០០០រៀល ដោយឡែកវត្តចំនួន១០ ក្នុងខេត្តកំពង់ធំ ក្នុងមួយវត្តៗទៀនវស្សា០១គូ អង្ករ៥០គីឡូក្រាម មី០២កេស ទឹកបរិសុទ្ធ០២កេស ធូប០២ដុំ និងបច្ច័យ១០០.០០០រៀល៕អត្ថបទ និងរូបភាព៖នាយកដ្ឋានព័ត៌មាន" constrainedToSize:CGSizeMake(cell.contentView.frame.size.width, 2000.0f) fontSize:15.0f] * 1.7;
    
    UILabel *articleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (detailLabel.frame.origin.y + 21) + 10, (cell.contentView.frame.size.width - 20), height)];
    articleLabel.font = [UIFont systemFontOfSize:15];
    articleLabel.textColor = [UIColor blackColor];
    articleLabel.numberOfLines = 0;
    articleLabel.text = @"មាជិកាគណៈកម្មការទី២ព្រឹទ្ធសភា និងជាសមាជិកាក្រុមសមាជិកព្រឹទ្ធសភាប្រ ចាំភូមិភាគទី៨ ព្រមទាំងបុត្រាបុត្រី និងចៅ ឯកឧត្តមឧត្តមសេណីយ៍ឯក សៀក សុជាតិ និងឯកឧត្តម ជាសមាជិកព្រឹទ្ធសភា បានវេរប្រគេនទេយ្យទានដល់ព្រះសង្ឃដែលនិមន្តមកពីវត្តទាំង៤៣វត្ត ដោយក្នុងមួយវត្តៗរួមមាន៖ ទៀនវស្សា០១គូ អង្ករ៥០គីឡូក្រាម ឆៃប៉ូវ៥គីឡូក្រាម សៀងផ្អែម ៥គីឡូក្រាម ពងទាប្រៃ៥០គ្រាប កាហ្វេ២ប្រអប់ ខ្ទឹមស១គីឡូក្រាម ប៊ីចេង១គីឡូក្រាម ធូប២ដុំ មី២កេស ត្រីខ២យួរ ទឹកបរិសុទ្ធ២កេស ទឹកក្រូច១កេស ទឹកផ្លែឈើ១កេស ទឹកត្រី២យួរ ទឹកស៊ីអ៊ីវ២យួរ ស្លាដក១ បច្ច័យ១០០.០០០រៀល ដោយឡែកវត្តចំនួន១០ ក្នុងខេត្តកំពង់ធំ ក្នុងមួយវត្តៗទៀនវស្សា០១គូ អង្ករ៥០គីឡូក្រាម មី០២កេស ទឹកបរិសុទ្ធ០២កេស ធូប០២ដុំ និងបច្ច័យ១០០.០០០រៀល៕អត្ថបទ និងរូបភាព៖នាយកដ្ឋានព័ត៌មាន";
    
    [AppUtils setLineHeight:@"មាជិកាគណៈកម្មការទី២ព្រឹទ្ធសភា និងជាសមាជិកាក្រុមសមាជិកព្រឹទ្ធសភាប្រ ចាំភូមិភាគទី៨ ព្រមទាំងបុត្រាបុត្រី និងចៅ ឯកឧត្តមឧត្តមសេណីយ៍ឯក សៀក សុជាតិ និងឯកឧត្តម ជាសមាជិកព្រឹទ្ធសភា បានវេរប្រគេនទេយ្យទានដល់ព្រះសង្ឃដែលនិមន្តមកពីវត្តទាំង៤៣វត្ត ដោយក្នុងមួយវត្តៗរួមមាន៖ ទៀនវស្សា០១គូ អង្ករ៥០គីឡូក្រាម ឆៃប៉ូវ៥គីឡូក្រាម សៀងផ្អែម ៥គីឡូក្រាម ពងទាប្រៃ៥០គ្រាប កាហ្វេ២ប្រអប់ ខ្ទឹមស១គីឡូក្រាម ប៊ីចេង១គីឡូក្រាម ធូប២ដុំ មី២កេស ត្រីខ២យួរ ទឹកបរិសុទ្ធ២កេស ទឹកក្រូច១កេស ទឹកផ្លែឈើ១កេស ទឹកត្រី២យួរ ទឹកស៊ីអ៊ីវ២យួរ ស្លាដក១ បច្ច័យ១០០.០០០រៀល ដោយឡែកវត្តចំនួន១០ ក្នុងខេត្តកំពង់ធំ ក្នុងមួយវត្តៗទៀនវស្សា០១គូ អង្ករ៥០គីឡូក្រាម មី០២កេស ទឹកបរិសុទ្ធ០២កេស ធូប០២ដុំ និងបច្ច័យ១០០.០០០រៀល៕អត្ថបទ និងរូបភាព៖នាយកដ្ឋានព័ត៌មាន" anyLabel:articleLabel];
   // if ([resultDic objectForKey:@"SCH_DESCRIPTION"] != NULL) {
        articleLabel.text = [resultDic objectForKey:@"SCH_DESCRIPTION"];
    //}
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
