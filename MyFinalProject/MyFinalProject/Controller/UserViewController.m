//
//  UserViewController.m
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/14/21.
//
#import "User.h"
#import "Movie.h"
#import "DBManager.h"
#import "MovieFetch.h"
#import "UserFetcher.h"
#import "UserViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "EditUserViewController.h"
#import "SWRevealViewController.h"
#import "CustomReminderTableViewCell.h"
@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lbEmail;
@property (strong, nonatomic) IBOutlet UIImageView *imgaeviewAvatar;
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UILabel *lbDateOfBirt;
@property (strong, nonatomic) IBOutlet UILabel *lbGender;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) User *user;
- (void)getAllMovieRemider;
- (void)getUser;
@end

@implementation UserViewController
NSMutableArray *listReminder;
NSDateFormatter *formatter4;

- (void)viewWillAppear:(BOOL)animated{
    [listReminder removeAllObjects];
    [self getAllMovieRemider];
    [self.myTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.myTableView setDataSource:self];
    [self.myTableView setDelegate:self];
    self.imgaeviewAvatar .layer.cornerRadius = self.imgaeviewAvatar.frame.size.width / 2;
    self.imgaeviewAvatar.layer.masksToBounds = YES;
    formatter4 = [[NSDateFormatter alloc] init];
    [formatter4 setDateFormat:@"yyyy/MM/dd HH:mm"];
    listReminder = [[NSMutableArray alloc] init];
    [self getUser];
    [self.lbDateOfBirt setText:self.user.dateOfBirth];
    [self.lbGender setText:self.user.gender];
    [self.lbName setText:self.user.name];
    [self.lbEmail setText:self.user.email];
    [self.imgaeviewAvatar setImage:[UIImage imageWithData:self.user.image]];
    
}
- (IBAction)btnEditUserClick:(id)sender {
    SWRevealViewController *revealController = self.revealViewController;
    
    [revealController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
    UIViewController *newFrontController = nil;
    newFrontController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditUserViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
    [revealController pushFrontViewController:navigationController animated:YES];
}
- (IBAction)btnShowAllSetiing:(id)sender {
    SWRevealViewController *revealController = self.revealViewController;
    [revealController setFrontViewPosition:FrontViewPositionRightMost animated:YES];
    UIViewController *newFrontController = nil;
    newFrontController = [self.storyboard instantiateViewControllerWithIdentifier:@"AllReminderViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newFrontController];
    [revealController pushFrontViewController:navigationController animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listReminder.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomReminderTableViewCell"];
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"CustomReminderTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomReminderTableViewCell"];
        cell =[tableView dequeueReusableCellWithIdentifier:@"CustomReminderTableViewCell"];
    }
    cell = [cell initWithMovie:(Movie*)[listReminder objectAtIndex:indexPath.row]];
    return cell;
}
- (void)getAllMovieRemider{
    NSArray *array = [[MovieFetch new] startFetching];
    if(array.count==0) return ;
    NSUInteger n=0;
    for(int i=0 ; i <array.count ;i++){
        Movie *movie = [array objectAtIndex:i];
        if(!([[movie reminderTime] isEqualToString:@""]) && ![[movie reminderTime] isKindOfClass:[NSNull class]] && [movie reminderTime] != nil )
        {   NSLog(@"~~%@",[movie reminderTime]);
            NSDate *date = [formatter4 dateFromString:[movie reminderTime]];
            if([date compare:[NSDate date]]==NSOrderedAscending){
                [[DBManager sharedInstance] updateMovieReminder:movie.movieID andReminderTime:@""];
            }
            else {
                [listReminder addObject:movie];
                n++;
                if(n==2) return;
            }
        }
    }
}
- (void)getUser{
    NSArray *array = [[UserFetcher new] startFetching];
    if(array == nil || array.count<1){
        User *newUser =[[User alloc] initWithName:@"Bi Dep Trai" andEmail:@"bideptrail.188@gmail.com" andGender:@"Male" andDateOfBirth:@"2000/08/18" andImage:UIImagePNGRepresentation([UIImage imageNamed:@"non"])];
        [[DBManager sharedInstance] addUser:newUser];
        self.user = newUser;
        return;
    }else{
        self.user = [array objectAtIndex:0];
        return;
    }
}
@end
