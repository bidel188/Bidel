//
//  Movie.m
//  PROJECT
//
//  Created by Nguyễn Văn Hoàng on 8/10/21.
//

#import "Movie.h"
@interface Movie()

@end
@implementation Movie
@synthesize movieID,imgLink,releaseDate,rate2,reminderTime,overView,isAdult,isFavorite;
- (instancetype)initWithID:(NSString *)movieID andImgLink:(NSString *)imgLink andReleaseDate:(NSString *)releaseDate andRate:(NSNumber*)rate andRemiderTime:(NSString *)reminderTime andTitle:(NSString *)title andOverView:(nonnull NSString *)overView andIsAdult:(NSNumber*)isAdult andIsFavorite:(NSNumber*) isFavorite{
    self = [super init];
    if(self){
        self.movieID = movieID;
        self.imgLink = imgLink;
        self.rate2 = rate;
        self.releaseDate = releaseDate;
        self.reminderTime = reminderTime;
        self.title = title;
        self.overView = overView;
        self.isAdult = isAdult;
        self.isFavorite = isFavorite;
    }
    return self;
}
@end
