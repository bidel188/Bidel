//
//  TableViewController.m
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/18/21.
//

#import "TableViewController.h"

@interface TableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *mytableview;
@property (strong, nonatomic) IBOutlet UITextField *tfNumberPagePerLoading;
@property (strong, nonatomic) IBOutlet UILabel *lbRate;
@property (strong, nonatomic) IBOutlet UITextField *tfYear;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIButton *btn01;
@property (strong, nonatomic) IBOutlet UIButton *btn02;
@property (strong, nonatomic) IBOutlet UIButton *btn03;
@property (strong, nonatomic) IBOutlet UIButton *btn04;
@property (strong, nonatomic) IBOutlet UIButton *btn11;
@property (strong, nonatomic) IBOutlet UIButton *btn12;


@end

@implementation TableViewController
NSInteger url=0;
double rate=0;
NSInteger year = 0;
NSString *sortBy = @"rating";
NSInteger NumberOfPage = 1;
- (void)viewDidAppear:(BOOL)animated{
    url = [[NSUserDefaults standardUserDefaults] integerForKey:@"url"];
    rate = [[NSUserDefaults standardUserDefaults] doubleForKey:@"rateFrom"];
    year = [[NSUserDefaults standardUserDefaults] integerForKey:@"yearFrom"];
    NumberOfPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"noPage"];
    switch (url) {
        case 0:
            [self.btn01 setHidden:NO];
            break;
        case 1:
            [self.btn02 setHidden:NO];
            break;
        case 2:
            [self.btn03 setHidden:NO];
            break;
        case 3:
            [self.btn04 setHidden:NO];
            break;
        default:
            break;
    }
    if(NumberOfPage <=0 ) NumberOfPage = 1;
    [self.slider setValue:rate];
    [self.tfYear setText:[@(year) stringValue]];
    [self.lbRate setText:[@(rate) stringValue]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillDisappear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults] setInteger:url forKey:@"url"];
    [[NSUserDefaults standardUserDefaults] setDouble:[self.lbRate.text doubleValue] forKey:@"rateFrom"];
    [[NSUserDefaults standardUserDefaults] setInteger:[self.tfNumberPagePerLoading.text integerValue] forKey:@"noPage"];
    [[NSUserDefaults standardUserDefaults] setInteger:[self.tfYear.text integerValue] forKey:@"yearFrom"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!indexPath.section){
        switch (indexPath.row) {
            case 0:
                if([self.btn01 isHidden])
                {
                    [self.btn01 setHidden:NO];
                    url=0;
                }else{
                    [self.btn01 setHidden:YES];
                    url=0;
                }
                [self.btn02 setHidden:YES];
                [self.btn03 setHidden:YES];
                [self.btn04 setHidden:YES];
                
                break;
            case 1:
                [self.btn01 setHidden:YES];
                if([self.btn02 isHidden])
                {
                    [self.btn02 setHidden:NO];
                    url=1;
                }else{
                    [self.btn02 setHidden:YES];
                    url=0;
                }
                [self.btn03 setHidden:YES];
                [self.btn04 setHidden:YES];
                
                break;
            case 2:
                [self.btn01 setHidden:YES];
                [self.btn02 setHidden:YES];
                if([self.btn03 isHidden])
                {
                    [self.btn03 setHidden:NO];
                    url=2;
                }else{
                    [self.btn03 setHidden:YES];
                    url=0;
                }
                [self.btn04 setHidden:YES];
                
                break;
            case 3:
                [self.btn01 setHidden:YES];
                [self.btn02 setHidden:YES];
                [self.btn03 setHidden:YES];
                if([self.btn04 isHidden])
                {
                    [self.btn04 setHidden:NO];
                    url=3;
                }else{
                    [self.btn04 setHidden:YES];
                    url=0;
                }
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            if([self.btn11 isHidden]){
                [self.btn11 setHidden:NO];
                [self.btn12 setHidden:YES];
            }else{
                [self.btn11 setHidden:YES];
            }
        }else{
            if([self.btn12 isHidden]){
                [self.btn12 setHidden:NO];
                [self.btn11 setHidden:YES];
            }else{
                [self.btn12 setHidden:YES];
            }
        }
    }
}
- (IBAction)valueOfRateChanged:(id)sender {
    [self.lbRate setText:[@([self.slider value]) stringValue]];
}
@end
