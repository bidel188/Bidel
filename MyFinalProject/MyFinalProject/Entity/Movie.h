//
//  Movie.h
//  PROJECT
//
//  Created by Nguyễn Văn Hoàng on 8/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject
@property (strong,nonatomic) NSString* movieID;
@property (strong,nonatomic) NSString* releaseDate;
@property (strong,nonatomic) NSNumber* rate2;
@property (strong,nonatomic) NSNumber* isAdult;
@property (strong,nonatomic) NSString* imgLink;
@property (strong,nonatomic) NSString* reminderTime;
@property (strong,nonatomic) NSString* title;
@property (strong,nonatomic) NSString* castLink;
@property (strong,nonatomic) NSString* overView;
@property (strong,nonatomic) NSNumber* isFavorite;

-(instancetype) initWithID: (NSString*)movieID andImgLink:(NSString*) imgLink andReleaseDate:(NSString*)releaseDate andRate:(NSNumber*) rate andRemiderTime:(NSString*) reminderTime andTitle:(NSString*)title andOverView:(NSString*) overView andIsAdult:(NSNumber*) isAdult andIsFavorite:(NSNumber*) isFavorite;
@end

NS_ASSUME_NONNULL_END
