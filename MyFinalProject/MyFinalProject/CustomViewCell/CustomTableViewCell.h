//
//  CustomTableViewCell.h
//  PROJECT
//
//  Created by Nguyễn Văn Hoàng on 8/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ImageViewPoster;
-(instancetype) initWithMovieID: (NSString*)movieID andMovieTitle:(NSString*) movieTitle andReleaseDate:(NSString*) releaseDate andRating:(NSNumber*) rate andLinkImagePoster:(NSString*) imgLink andOverView:(NSString*) overView andIsAdult:(NSNumber*) isAdult andIsFavorite:(NSNumber*) isFavorite andReminderTime:(NSString*)reminderTime andCache:(NSCache*) cache;
@end

NS_ASSUME_NONNULL_END
