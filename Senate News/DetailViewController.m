//
//  DetailViewController.m
//  Senate News
//
//  Created by vichhai on 9/3/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "DetailViewController.h"
#import "CustomDetailTableViewCell.h"
@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate>
{
    CGFloat rowHeigh;
    NSArray *arrContent;
}

@end

@implementation DetailViewController

-(BOOL)prefersStatusBarHidden{
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrContent = [[NSArray alloc] initWithObjects:@"​​សម្រាប់​ការ​ប្រកួត​រវាង​​​ក្រុម​ម្ចាស់​ផ្ទះ​ជប៉ុន​ និង​កម្ពុជា​​​​ល្ងាច​​ថ្ងៃ​ទី៣ ខែ​កញ្ញា ឆ្នាំ២០១៥​នេះ​​ អ្នក​ស្នេហា​វិស័យ​បាល់ទាត់​​នៅ​កម្ពុជា​អាច​​ចូល​រួម​ទស្សនា​បាន​​ដោយ​សេរី​ នៅ​​​​​កោះ​ពេជ្រ​ ​ចាប់​ពី​​វេលា​ម៉ោង៤:០០​តទៅ​ ដែល​មាន​​​​បំពាក់​ដោយ​ LED ខ្នាត​ធំ​ និង​ការ​ប្រគំតន្ត្រី​ដ៏​​អស្ចារ្យ​​ដែល​មាន​លោក ខេមរៈ សិរីមន្ត ចួល​រួម​សម្ដែង​ ​ដើម្បី​ចូលរួម​គាំទ្រ​​ក្រុម​បាល់ទាត់​ជម្រើស​ជាតិ​​កម្ពុជា សម្រាប់​​ការ​ប្រកួត​​បាល់ទាត់​​ពិភព​លោក​​​​​វគ្គ​ជម្រុះ​ប្រចាំ​តំបន់​អាស៊ី​ជុំ​ទី២​ ជើង​ទី១ ក្នុង​ពូល E ។ ការ​រៀប​ចំ​បញ្ចាំង ​​LED ​ខ្នាត​ធំ​ និង​ការ​​ប្រគំតន្ត្រី​​នេះ​រៀប​ចំ​ឡើង​ដោយ​ស្ថានីយ​ទូរទស្សន៍​បាយ័ន​ និង​ក្រុម​ហ៊ុន​ស្រាបៀរ​កម្ពុជា​ដែល​នាំ​​​តារា​ល្បីៗ ​មួយ​ចំនួន​ចូល​រួម​​សម្ដែង​ដូច​ជា​តារា​ចម្រៀង​​លោក​ ខេមរៈ សិរីមន្ត​​ និង​​តារា​ល្បី​ៗ ​ជា​ច្រើន​ដួង​ទៀត។ លើស​ពី​នេះ​ក៏​មាន​ការ​ចូល​រួម​​ពី​​កីឡាករ​បាល់ទាត់​លេចធ្លោ​ក្នុង​ក្រុម​​​​ជម្រើស​​ជាតិ​កម្ពុជា​អាយុ​ក្រោម​១៩​ឆ្នាំ​ចំនួន​៤​​រូប​​គឺ​​អ្នក​ចាំ​ទី អ៊ុំ​ សេរីរ័ត្ន​ ច្រឹង​ ពលរដ្ឋ​​ អ៊ុំ វិចិត្រ និង​ ទូច រ៉ូម៉ា។ ​កីឡាករ​ទាំង​៣​នាក់​មក​ពី​ក្លិប​ក្រសួង​ការពារ​ជាតិ ហើយ​​អ្នក​គាំទ្រ​​អាច​ចូល​រួម​ថត​រូប​ជា​អនុស្សាវរីយ៍​​ជា​មួយ​ពួក​គេ​បាន។",@"ភ្នំពេញ: ពេលព្រឹក ថ្ងៃត្រង់ និង​ ពេលល្ងាច ហាង សិក្រឹត រេស៊ីពី​ (Secret Recipe)  ដែលដំណើរការ​ អស់រយៈពេលជាច្រើនឆ្នាំតែងតែមានភាព មមាញឹកជាមួយវត្តមាន​ ភ្ញៀវក្នុង​ស្រុក និង អ្នក​ទេសចរ ដែលមកស្វែងរករសជាតិដ៏ពិសេសពី ភោជនីយដ្ឋាននេះ​​​​​។​",@"រស់ជាតិ សោភ័ណ្ឌ​ភាព គុណភាព តំលៃ និង សេវាកម្មរបស់ សិក្រឹត រេស៊ីពី​ (Secret Recipe)   កំពុង ទទួលបាន​​​​​​​ ការគាំ​ទ្រពី​យុវវ័យ និង អតិថិជនគ្រប់វ័យមិន ថាបរទេស រឺ ខ្មែរ។រៅពីទទួល យករសជាតិដែលច្នៃដោយចុងភៅដ៏ចំណាន អតិថិជន ក៏អាចជួប​ជុំ​ ជជែកគ្នាលេងជា លក្ខណៈ ឯកជន គ្រួ​​​​សារ​​ និង មិត្តភ័ក្ត ក្នុងហាង​ដែលមាន បរិយាកាស​ស្ងប់ស្ងាត់ រ៉ូម៉ែនទិច និង ការតុបតែង បែបពេញនិយម។សំរាប់ខែកញ្ញា​នេះ អតិថិជនទាំងអស់ អាចមកភ្លក់រសជាតិ ប្រហុកខ្ទិះសាច់មាន់​​ និងបង្គា  នៅហាង សិក្រឹត រេស៊ីពី (Secret Recipe)  ដែលមានរសជាតិឆ្ងាញ់​​ ហើយ​ អតិថិជន​ ​ក៏អាចជ្រើសរើស អាហារឈុតនេះជាមួយភេសជ្ជៈ​ កាហេ្វដោះគោទឹកកក​​ រឺ តែក្រូចឆ្មារទឹកកក​ ក្នុងតំលៃមួយឈុត ​$​៤,៥០។" ,nil];
    
    // =---> Creating a custom right navi bar button1
    UIButton *menu  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 28.0f)];
    [menu setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    
    // =---> Creating a custom right navi bar button2
    UIButton *facebook  = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    [facebook setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:menu];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:facebook];
    
    NSArray *barButtonItemArray = [[NSArray alloc] initWithObjects:barButtonItem1,barButtonItem2, nil];
    self.navigationItem.rightBarButtonItems = barButtonItemArray;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Tableview datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // remove duplicate label when scrolling
    for (UIView *v in [cell.contentView subviews]) {
        if ([v isKindOfClass:[UILabel class]])
            if (v.tag == 100) {
                [v removeFromSuperview];
            }
    }
    
    cell.labelTitle.text = @"​​សម្រាប់​ការ​ប្រកួត​រវាង​​​ក្រុម​ម្ចាស់​ផ្ទះ​ជប៉ុន​ និង​កម្ពុជា​​​​ល្ងាច​​ថ្ងៃ​ទី៣ ខែ​កញ្ញា ឆ្នាំ២០១៥​នេះ​​ អ្នក​ស្នេហា​វិស័យ​បាល់ទាត់​​នៅ​កម្ពុជា​អាច​​ចូល​រួម​ទស្សនា​បាន​​ដោយ​សេរី​ នៅ​​​​​កោះ​ពេជ្រ​ ​ចាប់​ពី​​វេលា​ម៉ោង៤:០០​តទៅ​ ដែល​មាន​​​​បំពាក់​ដោយ​ LED ខ្នាត​ធំ​ និង​ការ​ប្រគំតន្ត្រី​ដ៏​​អស្ចារ្យ​​ដែល​មាន​លោក ខេមរៈ សិរីមន្ត ចួល​រួម​សម្ដែង​ ​ដើម្បី​ចូលរួម​គាំទ្រ​​ក្រុម​បាល់ទាត់​ជម្រើស​ជាតិ​​កម្ពុជា សម្រាប់​​ការ​ប្រកួត​​បាល់ទាត់​​ពិភព​លោក​​​​​វគ្គ​ជម្រុះ​ប្រចាំ​តំបន់​អាស៊ី​ជុំ​ទី២​ ជើង​ទី១ ក្នុង​ពូល E ។";
    CGFloat height = [self measureTextHeight:[arrContent objectAtIndex:indexPath.row] constrainedToSize:CGSizeMake(cell.myScrollView.frame.size.width, 2000.0f) fontSize:14.0f];
    
    // =--> Create Content Label
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.frame.origin.x, (cell.myScrollView.frame.origin.y + cell.myScrollView.frame.size.height) + 5 , cell.myScrollView.frame.size.width, height)];
    [contentLabel setFont:[UIFont systemFontOfSize:14]];
    contentLabel.text = [arrContent objectAtIndex:indexPath.row];
    contentLabel.numberOfLines = 0;
    contentLabel.tag = 100;
    [cell.contentView addSubview:contentLabel];
    
    rowHeigh = (contentLabel.frame.origin.y + contentLabel.frame.size.height) + 10 ;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrContent.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeigh;
}

- (CGFloat)measureTextHeight:(NSString*)text constrainedToSize:(CGSize)constrainedToSize fontSize:(CGFloat)fontSize {
    
    CGRect rect = [text boundingRectWithSize:constrainedToSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.height;
    
}
@end
