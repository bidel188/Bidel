//
//  CustomTableViewCell.m
//  PROJECT
//
//  Created by Nguyễn Văn Hoàng on 8/10/21.
//

#import "DBManager.h"
#import "MovieFetch.h"
#import "CustomTableViewCell.h"

@interface CustomTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *lbMovieTitle;
@property (strong, nonatomic) IBOutlet UILabel *lbReleaseDate;
@property (strong, nonatomic) IBOutlet UILabel *lbRating;
@property (strong, nonatomic) IBOutlet UITextView *overView;
@property(assign,nonatomic) BOOL isAdult;
@property(assign,nonatomic) BOOL isFavorite;
@property (strong, nonatomic) IBOutlet UIButton *btnAdult;
@property(assign,nonatomic) NSString *movieID;
@property (strong, nonatomic) IBOutlet UIButton *btnFavorite;
@property (strong,nonatomic) Movie* movie;
@end
NSString *baseURL2 = @"https://image.tmdb.org/t/p/w780/";
@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithMovieID:(NSString *)movieID andMovieTitle:(NSString *)movieTitle andReleaseDate:(NSString *)releaseDate andRating:(NSNumber*)rate andLinkImagePoster:(NSString *)imgLink andOverView:(NSString *)overView andIsAdult:(NSNumber*)isAdult andIsFavorite:(NSNumber*)isFavorite andReminderTime:(NSString*) reminderTime andCache:(NSCache*) cache{
    self.movie = [[Movie alloc] initWithID:movieID andImgLink:imgLink andReleaseDate:releaseDate andRate:rate andRemiderTime:reminderTime andTitle:movieTitle  andOverView:overView andIsAdult:isAdult andIsFavorite:isFavorite];
    self = [super init];
    if(self){
        self.movieID = movieID;
        [self.lbMovieTitle setText:movieTitle];
        [self.overView setEditable:false];
        [self.lbReleaseDate setText:releaseDate];
        [self.overView setText:overView];
        [self.lbRating setText:[NSString stringWithFormat:@"%.01f/10",[rate doubleValue]]];
        self.isAdult =[isAdult boolValue];
        self.isFavorite = [isFavorite boolValue];
        if(self.isFavorite){
            [self.btnFavorite setImage:[UIImage systemImageNamed:@"star.fill"] forState:UIControlStateNormal];
        }else{
            [self.btnFavorite setImage:[UIImage systemImageNamed:@"star"] forState:UIControlStateNormal];
        }
        if(self.isAdult){
            [self.btnAdult setBackgroundColor:[UIColor systemRedColor]];
        }else{
            [self.btnAdult setBackgroundColor:[UIColor systemBlueColor]];
        }
        if([cache objectForKey:imgLink]!=NULL){
            [self.ImageViewPoster setImage:[UIImage imageWithData:[cache objectForKey:imgLink]]];
        }else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData* data= [NSData dataWithContentsOfURL:[NSURL URLWithString:[@"https://image.tmdb.org/t/p/w780/" stringByAppendingString:imgLink]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.ImageViewPoster setImage:[UIImage imageWithData:data]];
                    [cache setObject:data forKey:imgLink];
                });
                
            });
        }
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //    NSLog(@"%@",self.movieID);
}
- (IBAction)btnFavortieClick:(id)sender {
    if(self.isFavorite){
        //        NSArray *array = [[MovieFetch new] fetchingWithFilterByMovieID:self.movieID];
        //        Movie *movie = [array objectAtIndex:0];
        [self.btnFavorite setImage:[UIImage systemImageNamed:@"star"] forState:UIControlStateNormal];
        [[DBManager sharedInstance] updateMovie:self.movieID andIsFavortie:[NSNumber numberWithBool:NO]];
    }else{
        NSArray *array = [[MovieFetch new] fetchingWithFilterByMovieID:self.movieID];
        if([array count]==0){
            [[DBManager sharedInstance] addMovie:self.movie];
        }
        [self.btnFavorite setImage:[UIImage systemImageNamed:@"star.fill"] forState:UIControlStateNormal];
        [[DBManager sharedInstance] updateMovie:self.movieID andIsFavortie:[NSNumber numberWithBool:YES]];
    }
    self.isFavorite = !self.isFavorite;
}

@end
