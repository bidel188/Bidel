//
//  PopularMoviesViewController.m
//  PROJECT
//
//  Created by Nguyễn Văn Hoàng on 8/10/21.
//
#import <UIKit/UIKit.h>
#import "Movie.h"
#import "DBManager.h"
#import "MovieFetch.h"
#import "CustomTableViewCell.h"
#import "SWRevealViewController.h"
#import "CustomCollectionViewCell.h"
#import "MovieDetailViewController.h"
#import "PopularMoviesViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "SettingViewController.h"
#import "TableViewController.h"
@interface PopularMoviesViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MyDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnUser;
@property (strong, nonatomic) IBOutlet UIButton *btnTableView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
- (void)fetchMovieDataInPage:(NSUInteger) i;
- (void) goToMovieDetail:(Movie*) movie;
- (void)loadMore;
@property (strong, nonatomic) IBOutlet UICollectionView *myColectionView;
@end
@implementation PopularMoviesViewController
NSCache *cache;
int i = 1;
NSString *const baseURL = @"https://api.themoviedb.org/3/configuration?api_key=e7631ffcb8e766993e5ec0c1f4245f93";
NSString  *apiToGetMovie;
NSMutableArray *listAPI ;
NSMutableArray<Movie*> *listOfPopularMovie;
NSInteger urlSetting=0;
double rateSetting=0;
NSInteger yearFromSetting=0;
NSString *keyForSort = @"";
NSInteger noPageSetting = 1;
NSInteger numberOfPageOfAPI = 2;
BOOL isTableView = true;
- (void)viewDidAppear:(BOOL)animated{
    BOOL isChangeSetting = NO;
    if(urlSetting != [[NSUserDefaults standardUserDefaults] integerForKey:@"url"]){
        urlSetting = [[NSUserDefaults standardUserDefaults] integerForKey:@"url"];
        isChangeSetting = YES;
    }
    if(rateSetting != [[NSUserDefaults standardUserDefaults] doubleForKey:@"rateFrom"]){
        rateSetting = [[NSUserDefaults standardUserDefaults] doubleForKey:@"rateFrom"];
        isChangeSetting = YES;
    }
    if(yearFromSetting != [[NSUserDefaults standardUserDefaults] integerForKey:@"yearFrom"]){
        yearFromSetting = [[NSUserDefaults standardUserDefaults] integerForKey:@"yearFrom"];
        isChangeSetting = YES;
    }
    if(noPageSetting != [[NSUserDefaults standardUserDefaults] integerForKey:@"noPage"]){
        noPageSetting = [[NSUserDefaults standardUserDefaults] integerForKey:@"noPage"];
        isChangeSetting = YES;
    }
    apiToGetMovie = [listAPI objectAtIndex:urlSetting];
    if(isChangeSetting){
        i = 1 ;
        [listOfPopularMovie removeAllObjects];
        [self loadMore];
    }else{
        [self.myTableView reloadData];
    }
    [self.btnUser setTarget: self.revealViewController];
    [self.btnUser setAction: @selector( revealToggle: )];
    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width-70;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.myTableView setDelegate:self];
    [self.myTableView setDataSource:self];
    [self.myColectionView setDelegate:self];
    [self.myColectionView setDataSource:self];
    listAPI = [NSMutableArray arrayWithObjects:@"https://api.themoviedb.org/3/movie/popular?api_key=e7631ffcb8e766993e5ec0c1f4245f93&page=",@"https://api.themoviedb.org/3/movie/top_rated?api_key=e7631ffcb8e766993e5ec0c1f4245f93&page=",@"https://api.themoviedb.org/3/movie/upcoming?api_key=e7631ffcb8e766993e5ec0c1f4245f93&page=",@"https://api.themoviedb.org/3/movie/now_playing?api_key=e7631ffcb8e766993e5ec0c1f4245f93&page=", nil];
    apiToGetMovie = [listAPI objectAtIndex:0];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(!granted){
            NSLog(@"Something went Wrong");
        }
    }];
    listOfPopularMovie = [[NSMutableArray alloc] init];
    cache = [[NSCache alloc] init];
    [self.myColectionView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.myTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self loadMore];
    if(!isTableView){
        [self.btnTableView setImage:[UIImage systemImageNamed:@"list.dash"] forState:UIControlStateNormal ];
        [self.myTableView setHidden:YES];
    }else{
        [self.myColectionView setHidden:YES];
        [self.btnTableView setImage:[UIImage systemImageNamed:@"square.grid.3x2"] forState:UIControlStateNormal];
    }
}
//Fetching movie in page i-th
- (void)fetchMovieDataInPage:(NSUInteger) i{
    NSString *url = [apiToGetMovie stringByAppendingFormat:@"%@",[@(i) stringValue]];
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
        NSDictionary* dict = [jsonData objectForKey:@"results"];
        for(NSDictionary* dict2 in dict){
            NSString* movieID = [[dict2 valueForKey:@"id"] stringValue] ;
            NSString* releaseDate= [dict2 valueForKey:@"release_date"];
            NSNumber* rate = [dict2 valueForKey:@"vote_average"] ;
            NSString* imgLink= [dict2 valueForKey:@"poster_path"];
            if(imgLink!=(id)[NSNull null]  && imgLink!=nil){
                imgLink = [imgLink substringFromIndex:1];
            }
            NSString *title = [dict2 valueForKey:@"original_title"];
            NSString *overView = [dict2 valueForKey:@"overview"];
            NSNumber* isAdult = [dict2 valueForKey:@"adult"];
            Movie *m = [[Movie alloc] initWithID:movieID andImgLink:imgLink andReleaseDate:releaseDate andRate:rate andRemiderTime:@"" andTitle:title andOverView:overView andIsAdult:isAdult andIsFavorite:[NSNumber numberWithBool:NO]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                numberOfPageOfAPI = [[jsonData objectForKey:@"total_pages"] integerValue];
                if([m.rate2 doubleValue]  >= rateSetting && [[m.releaseDate substringToIndex:4] integerValue] > yearFromSetting)
                {
                    [listOfPopularMovie addObject:m];
                }
                
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(isTableView){
                [self.myTableView reloadData];
            }else{
                [self.myColectionView reloadData];
            }
        });
    }];
    [sessionTask resume];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listOfPopularMovie count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell"];
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomTableViewCell"];
        cell =[tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell"];
        
    }
    Movie *movie = [listOfPopularMovie objectAtIndex:indexPath.row];
    NSArray *array = [[MovieFetch new] fetchingWithFilterByMovieID:movie.movieID];
    NSString *reminderTime =@"";
    BOOL isFavortire=false;
    Movie *movieFromDB = [[Movie alloc] init];
    if([array count]>0){
        movieFromDB = [array objectAtIndex:0];
        reminderTime = movieFromDB.reminderTime;
        isFavortire = [movieFromDB.isFavorite boolValue];
    }
    cell = [cell initWithMovieID:movie.movieID andMovieTitle:movie.title andReleaseDate:movie.releaseDate andRating:movie.rate2 andLinkImagePoster:movie.imgLink andOverView:movie.overView andIsAdult:movie.isAdult andIsFavorite:[NSNumber numberWithBool:isFavortire]  andReminderTime:movieFromDB.reminderTime andCache:cache];
    if( indexPath.row == [listOfPopularMovie count]-1){
        [self loadMore];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}
- (void)loadMore{
    if(i>numberOfPageOfAPI) return;
    [self fetchMovieDataInPage:i];
    i+= noPageSetting;
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CustomCollectionViewCell"];
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionViewCell" forIndexPath:indexPath];
    cell = [cell initWithMovie:[listOfPopularMovie objectAtIndex:indexPath.row]  andCache:cache];
    if(indexPath.row == [listOfPopularMovie count]-1){
        [self loadMore];
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(!isTableView){
        return listOfPopularMovie.count;
    }
    return 0;
}
//Change type of view ( TableView <> ColletionView )
- (IBAction)btnChangeTypeViewClick:(id)sender {
    if(isTableView){
        [self.myColectionView setHidden:NO];
        [self.myTableView setHidden:YES];
        [self.btnTableView setImage:[UIImage systemImageNamed:@"list.dash"] forState:UIControlStateNormal];
        [self.myColectionView reloadData];
    }else{
        [self.myTableView setHidden:NO];
        [self.myColectionView setHidden:YES];
        [self.btnTableView setImage:[UIImage systemImageNamed:@"square.grid.3x2"] forState:UIControlStateNormal];
        [self.myTableView reloadData];
    }
    isTableView = !isTableView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Movie *movie = [listOfPopularMovie objectAtIndex:indexPath.row];
    [self goToMovieDetail:movie];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.view.frame.size.width-20)/3, (self.view.frame.size.width)/3);
}
- (void) goToMovieDetail:(Movie*) movie{
    MovieDetailViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"MovieDetailViewController"];
    NSArray *array = [[MovieFetch new] fetchingWithFilterByMovieID:movie.movieID];
    if([array count]>0){
    }
    view.movie = movie;
    [self.navigationController pushViewController:view animated:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Movie *movie = [listOfPopularMovie objectAtIndex:indexPath.item];
    [self goToMovieDetail:movie];
}
- (void)SetValueForParam:(NSInteger)url andRateFrom:(double)rate andYearFrom:(NSUInteger)year andSortBy:(NSString *)keyForSort andNumberOfPage:(NSUInteger)noPage{
    NSLog(@"%@",keyForSort);
}
@end

