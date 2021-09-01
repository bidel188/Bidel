//
//  FavoriteViewController.m
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/10/21.
//

#import "Movie.h"
#import "DBManager.h"
#import "MovieFetch.h"
#import "CustomTableViewCell.h"
#import "SWRevealViewController.h"
#import "FavoriteViewController.h"
@interface FavoriteViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnUser;
@property (strong, nonatomic) NSCache *cache;
@end
@implementation FavoriteViewController
NSMutableArray *listFavoriteMovie;
- (void)viewWillAppear:(BOOL)animated{
    [listFavoriteMovie removeAllObjects];
    
    NSArray *allInDB= [[MovieFetch new] startFetching];
    for(int i = 0 ; i <allInDB.count;i++){
        Movie *movie = (Movie*)[allInDB objectAtIndex:i];
        if( [[movie isFavorite] boolValue] ){
            [listFavoriteMovie addObject:movie];
        }
    }
    [self.myTableView reloadData];
    [self.btnUser setTarget: self.revealViewController];
    [self.btnUser setAction: @selector( revealToggle: )];
    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width-70;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    listFavoriteMovie = [[NSMutableArray alloc] init];
    [self.myTableView setDelegate:self];
    [self.myTableView setDataSource:self];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listFavoriteMovie.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell"];
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomTableViewCell"];
        cell =[tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell"];
    }
    Movie *movie = [listFavoriteMovie objectAtIndex:indexPath.row];
    NSArray *array = [[MovieFetch new] fetchingWithFilterByMovieID:movie.movieID];
    NSString *reminderTime =@"";
    BOOL isFavortire=false;
    Movie *movieFromDB = [[Movie alloc] init];
    if([array count]>0){
        movieFromDB = [array objectAtIndex:0];
        reminderTime = movieFromDB.reminderTime;
        isFavortire = movieFromDB.isFavorite;
    }
    cell = [cell initWithMovieID:movie.movieID andMovieTitle:movie.title andReleaseDate:movie.releaseDate andRating:movie.rate2 andLinkImagePoster:movie.imgLink andOverView:movie.overView andIsAdult:movie.isAdult andIsFavorite:[NSNumber numberWithBool:isFavortire]  andReminderTime:movieFromDB.reminderTime andCache:self.cache];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Removing Alert" message:@"Do you really want to remove this item ?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaulAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[DBManager sharedInstance] deleteMovie:[listFavoriteMovie objectAtIndex:indexPath.row]];
        [listFavoriteMovie removeObjectAtIndex:indexPath.row];
        [self.myTableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:defaulAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
