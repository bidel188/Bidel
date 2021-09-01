//
//  DBManager.h
//  HoangNV44_Assignment_13
//
//  Created by Nguyễn Văn Hoàng on 7/20/21.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Movie.h"
#import "User.h"
NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(DBManager *)sharedInstance;
- (BOOL)addMovie:(Movie*) movie;
- (BOOL)deleteMovie:(Movie*) movie;
- (void)updateMovie:(NSString *)movieID andIsFavortie:(NSNumber*) isFavorite;
- (void)updateMovieReminder:(NSString *)movieID andReminderTime:(NSString *)reminderTime;
- (BOOL)addUser:(User*) user;
- (void)updateUser:(User*) user;
@end

NS_ASSUME_NONNULL_END
