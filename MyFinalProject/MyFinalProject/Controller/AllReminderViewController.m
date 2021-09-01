//
//  AllReminderViewController.m
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/12/21.
//
#import "Movie.h"
#import "DBManager.h"
#import "MovieFetch.h"
#import "SWRevealViewController.h"
#import "MovieDetailViewController.h"
#import "AllReminderViewController.h"
#import "CustomReminderTableViewCell.h"

@interface AllReminderViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnUser;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
- (void)getAllMovieRemider;
@end
@implementation AllReminderViewController
NSDateFormatter *formatter3;
NSMutableArray *listAllMovieHaveReminder;
- (void)viewWillAppear:(BOOL)animated{
    [listAllMovieHaveReminder removeAllObjects];
    [self getAllMovieRemider];
    [self.myTableView reloadData];
    [self.btnUser setTarget: self.revealViewController];
    [self.btnUser setAction: @selector( revealToggle: )];
    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width-70;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setDateFormat:@"yyyy/MM/dd HH:mm"];
    listAllMovieHaveReminder = [[NSMutableArray alloc] init];
    [self.myTableView setDelegate:self];
    [self.myTableView setDataSource:self];
}
- (void)getAllMovieRemider{
    NSArray *array = [[MovieFetch new] startFetching];
    if(array.count==0) return ;
    for(int i=0 ; i <array.count;i++){
        Movie *movie = [array objectAtIndex:i];
        if(!([[movie reminderTime] isEqualToString:@""]) && ![[movie reminderTime] isKindOfClass:[NSNull class]] && [movie reminderTime] != nil )
        {   NSLog(@"~~%@",[movie reminderTime]);
            NSDate *date = [formatter3 dateFromString:[movie reminderTime]];
            if([date compare:[NSDate date]]==NSOrderedAscending){
                [[DBManager sharedInstance] updateMovieReminder:movie.movieID andReminderTime:@""];
            }
            else {
                [listAllMovieHaveReminder addObject:movie];
            }
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listAllMovieHaveReminder.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomReminderTableViewCell"];
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"CustomReminderTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomReminderTableViewCell"];
        cell =[tableView dequeueReusableCellWithIdentifier:@"CustomReminderTableViewCell"];
    }
    cell = [cell initWithMovie:(Movie*)[listAllMovieHaveReminder objectAtIndex:indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieDetailViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieDetailViewController"];
    view.movie = [listAllMovieHaveReminder objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:view animated:YES];
}
- (IBAction)homeClick:(id)sender {
    UITabBarController *newFrontController = [self.storyboard instantiateInitialViewController];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    [self.revealViewController pushFrontViewController:newFrontController animated:YES];
}
@end
