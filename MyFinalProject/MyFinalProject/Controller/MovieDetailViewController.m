//
//  MovieDetailViewController.m
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/11/21.
//
#import "DBManager.h"
#import "MovieFetch.h"
#import "MovieDetailViewController.h"
#import "CustomCastCollectionViewCell.h"
#import <UserNotifications/UserNotifications.h>
@interface MovieDetailViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UILabel *lbReleaseDate;
@property (strong, nonatomic) IBOutlet UILabel *lbRating;
@property (strong, nonatomic) IBOutlet UIButton *btnAdult;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPoster;
@property (strong, nonatomic) IBOutlet UITextView *overView;
@property (strong, nonatomic) IBOutlet UIView *viewPickerTime;
@property (strong, nonatomic) IBOutlet UILabel *lbReminderTime;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSDate* dateInPicker;
- (void) pushNotification:(NSDate*) date;
- (void)fetchData;
@end

@implementation MovieDetailViewController
NSDateFormatter *formatter;
NSString *baseURLImage = @"https://image.tmdb.org/t/p/w780/";
NSString *castAndCrewURL = @"https://api.themoviedb.org/3/movie/movieID/credits?api_key=e7631ffcb8e766993e5ec0c1f4245f93";
NSMutableArray *listCastAndCrewName;
NSMutableArray *listCastAndCrewImgURL;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    listCastAndCrewName = [[NSMutableArray alloc] init];
    listCastAndCrewImgURL = [[NSMutableArray alloc] init];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    [self.myCollectionView setDelegate:self];
    [self.myCollectionView setDataSource:self];
    [self.lbRating setText:[self.movie.rate2 stringValue]];
    [self.overView setText:self.movie.overView];
    [self.lbReminderTime setText:self.movie.reminderTime];
    [self.lbReleaseDate setText:self.movie.releaseDate];
    [self.datePicker setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+7"]];
    [self.datePicker setMinimumDate:[NSDate date]];
//    [self.navigationController.navigationBar.topItem setTitle:self.movie.title];
    [self.navigationItem setTitle:self.movie.title];
    NSArray *array = [[MovieFetch new] fetchingWithFilterByMovieID:self.movie.movieID];
    if(array.count>0){
        [self.lbReminderTime setText:[[array firstObject] reminderTime]];
    }
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[baseURLImage stringByAppendingFormat:@"%@",self.movie.imgLink]]];
    [self.imageViewPoster setImage:[UIImage imageWithData:data]];
        if([[self.movie isAdult] boolValue]){
        [self.btnAdult setBackgroundColor:[UIColor systemRedColor]];
    }else{
        [self.btnAdult setBackgroundColor:[UIColor systemBlueColor]];
    }
    [self.viewPickerTime setHidden:YES];
    [self fetchData];
}
- (void)fetchData{
    NSString *url = [castAndCrewURL stringByReplacingOccurrencesOfString:@"movieID" withString:self.movie.movieID];
    NSLog(@"%@ url",url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *requestData =[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSData *responseData = [requestData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonData  = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        NSDictionary* cast = [jsonData objectForKey:@"cast"];
        NSDictionary* crew = [jsonData objectForKey:@"crew"];
        NSLog(@"%@",jsonData);
        for(NSDictionary *dict2 in cast){
            NSString* name = [dict2 valueForKey:@"name"];
            NSString* url = [dict2 valueForKey:@"profile_path"] ;
            if(url!=(id)[NSNull null]  && url!=nil){
                url = [url substringFromIndex:1];
            }else{
                url = @"";
            }
            [listCastAndCrewName addObject:name];
            [listCastAndCrewImgURL addObject:url];
        }
        for(NSDictionary *dict2 in crew){
            NSString* name = [dict2 valueForKey:@"name"];
            NSString* url = [dict2 valueForKey:@"profile_path"];
            if(url!=(id)[NSNull null]  && url!=nil){
                url = [url substringFromIndex:1];
//                NSLog(@"%@",url);
            }else {
                url =@"";
            }
            [listCastAndCrewName addObject:name];
            [listCastAndCrewImgURL addObject:url];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.myCollectionView reloadData];
        });
    }];
    [sessionTask resume];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return listCastAndCrewName.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView registerNib:[UINib nibWithNibName:@"CustomCastCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CustomCastCollectionViewCell"];
    CustomCastCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCastCollectionViewCell" forIndexPath:indexPath];
    cell = [cell initWithata:[listCastAndCrewName objectAtIndex:indexPath.row] andURL:[listCastAndCrewImgURL objectAtIndex:indexPath.row]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.myCollectionView.frame.size.height-5, self.myCollectionView.frame.size.height-5);
}
- (IBAction)btnReminderClick:(id)sender {
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar sizeToFit];
    [self.viewPickerTime setHidden:NO];
    
}
- (IBAction)cancelPickTimelick:(id)sender {
    [self.viewPickerTime setHidden:YES];
}
- (IBAction)okeSelectTimePicker:(id)sender {
//    NSDate *date = [self.datePicker date];
    NSLog(@"%@",self.dateInPicker);
    [self pushNotification:self.dateInPicker];
    [self.viewPickerTime setHidden:YES];
    NSString *dateInString = [formatter stringFromDate:self.dateInPicker];
    self.lbReminderTime.text = dateInString;
    NSArray *array = [[MovieFetch new] fetchingWithFilterByMovieID:self.movie.movieID];
    if(array.count==0){
        [[DBManager sharedInstance] addMovie:self.movie];
    }
    [[DBManager sharedInstance] updateMovieReminder:self.movie.movieID andReminderTime:dateInString];
    
}
- (void) pushNotification:(NSDate*) date{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:5];
    content.title = self.movie.title;
    content.body = [self.movie.rate2 stringValue];
    content.subtitle =   [formatter stringFromDate:date];
    content.sound = [UNNotificationSound defaultSound];
    NSLog(@"%@",date);
    NSDateComponents *triggerDate = [[NSCalendar currentCalendar] components:NSCalendarUnitYear+NSCalendarUnitMonth+NSCalendarUnitDay+NSCalendarUnitHour+NSCalendarUnitMinute+NSCalendarUnitSecond fromDate:date];
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];

    NSString *identifier = self.movie.movieID;
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    [center removePendingNotificationRequestsWithIdentifiers:[NSArray arrayWithObjects:identifier, nil]];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error");
        }
    }];
}
- (IBAction)dateChange:(id)sender {
    self.dateInPicker = [self.datePicker date];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
