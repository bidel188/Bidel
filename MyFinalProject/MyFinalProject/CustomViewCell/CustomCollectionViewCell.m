//
//  CustomCollectionViewCell.m
//  PROJECT
//
//  Created by Nguyễn Văn Hoàng on 8/10/21.
//

#import "CustomCollectionViewCell.h"
@interface CustomCollectionViewCell()
@property (strong,nonatomic) NSString* movieID;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet UILabel *lbAdult;
@property (strong, nonatomic) IBOutlet UILabel *lbReleaseDate;
@property (strong, nonatomic) IBOutlet UILabel *lbRating;
@property (strong, nonatomic) IBOutlet UITextView *overView;
@end
@implementation CustomCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (instancetype)initWithMovie:(Movie *)movie andCache:(NSCache *)cache{
    self = [super init];
    if(self)
    {
        self.movieID = movie.movieID;
        [self.lbRating setText:[NSString stringWithFormat:@"%.01f/10",[movie.rate2 doubleValue]]];
        [self.overView setText:movie.overView];
        [self.lbReleaseDate setText:movie.releaseDate];
        [self.overView setEditable:FALSE];
        if(![movie.isAdult doubleValue]){
            [self.lbAdult setHidden:YES];
        }
        [self.lbReleaseDate setText:movie.releaseDate];
        [self.lbTitle setText:movie.title];
        if([cache objectForKey:movie.imgLink]!=NULL){
            NSData *data = [cache objectForKey:movie.imgLink];
            [self.imageViewPoster setImage:[UIImage imageWithData:data]];
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData* data= [NSData dataWithContentsOfURL:[NSURL URLWithString:[@"https://image.tmdb.org/t/p/w780/" stringByAppendingString:movie.imgLink]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.imageViewPoster setImage:[UIImage imageWithData:data]];
                    [cache setObject:data forKey:movie.imgLink];
                });
            });}
    }
    return self;
}

@end
