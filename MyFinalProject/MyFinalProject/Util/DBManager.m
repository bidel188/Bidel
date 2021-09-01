//
//  DBManager.m
//  HoangNV44_Assignment_13
//
//  Created by Nguyễn Văn Hoàng on 7/20/21.
//

#import "DBManager.h"
#import "User.h"
#import "MovieFetch.h"
#import "UserFetcher.h"
@implementation DBManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
static DBManager *shared = nil;
+ (DBManager *)sharedInstance{
    if(!shared){
        shared = [DBManager new];
    }
    return shared;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self managedObjectContext];
    }
    return self;
}
- (NSURL *)applicationDocumentDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (NSManagedObjectContext *)managedObjectContext{
    if(_managedObjectContext != nil){
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator  = [self persistentStoreCoordinator];
    if(coordinator != nil){
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel{
    if(_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyFinalProject" withExtension:@"momd"]; //Link to Model ( abcxyz.xcdatamodeld
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(_persistentStoreCoordinator != nil){
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentDirectory] URLByAppendingPathComponent:@"MyFinalProject.sqlite"];
    NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption, nil];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:option error:&error]){
        NSLog(@"Unsolved error %@, %@",error,[error userInfo]);
        return nil;
    }
    return _persistentStoreCoordinator;
}
- (BOOL)addUser:(User *)user{
    
    NSManagedObject *manageObject = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    [manageObject setValue:user.name forKey:@"name"];
    [manageObject setValue:user.gender forKey:@"gender"];
    [manageObject setValue:user.email forKey:@"email"];
    [manageObject setValue:user.dateOfBirth forKey:@"dateOfBirth"];
    [manageObject setValue:user.image forKey:@"image"];
    NSError *error = nil;
    if(![self.managedObjectContext save:&error]){
        NSLog(@"Unsolved error %@, %@",error,[error userInfo]);
        return NO;
    }
    return YES;
}

- (BOOL)deleteMovie:(Movie *)movie{
    NSArray *listCertificateToDelete = [[MovieFetch new] fetchingWithFilterByMovieID:movie.movieID];
    [self.managedObjectContext deleteObject:[listCertificateToDelete objectAtIndex:0]];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return NO;
    }
    return YES;
   
}
- (void)updateUser:(User*) user {
    NSArray *listUser = [[UserFetcher new] startFetching];
    NSManagedObject *manageContext = [listUser objectAtIndex:0];
    [manageContext setValue:user.name forKey:@"name"];
    [manageContext setValue:user.gender forKey:@"gender"];
    [manageContext setValue:user.email forKey:@"email"];
    [manageContext setValue:user.dateOfBirth forKey:@"dateOfBirth"];
    [manageContext setValue:user.image forKey:@"image"];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) { // [self.managedObjectContext save:&error] mush have to save change of manage context :p
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (void)updateMovie:(NSString *)movieID andIsFavortie:(NSNumber*) isFavorite{
    NSArray *listMovieToUpdate = [[MovieFetch new] fetchingWithFilterByMovieID:movieID];
    NSManagedObject *manageContext = [listMovieToUpdate objectAtIndex:0];
    [manageContext setValue:isFavorite forKey:@"isFavorite"];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) { // [self.managedObjectContext save:&error] mush have to save change of manage context :p
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}
- (void)updateMovieReminder:(NSString *)movieID andReminderTime:(NSString *)reminderTime {
    NSArray *listMovieToUpdate = [[MovieFetch new] fetchingWithFilterByMovieID:movieID];
    NSManagedObject *manageContext = [listMovieToUpdate objectAtIndex:0];
    [manageContext setValue:reminderTime forKey:@"reminderTime"];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) { // [self.managedObjectContext save:&error] mush have to save change of manage context :p
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}
- (BOOL)addMovie:(Movie *)movie{
    
    NSManagedObject *manageObject = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:self.managedObjectContext];
    [manageObject setValue:movie.movieID forKey:@"movieID"];
    [manageObject setValue:movie.castLink forKey:@"castLink"];
    [manageObject setValue:movie.isAdult forKey:@"isAdult"];
    [manageObject setValue:movie.overView forKey:@"overView"];
    [manageObject setValue:movie.rate2 forKey:@"rate2"];
    [manageObject setValue:movie.releaseDate forKey:@"releaseDate"];
    [manageObject setValue:movie.reminderTime forKey:@"reminderTime"];
    [manageObject setValue:movie.title forKey:@"title"];
    [manageObject setValue:movie.imgLink forKey:@"imgLink"];
    [manageObject setValue:movie.isFavorite forKey:@"isFavorite"];
    
    NSError *error = nil;
    if(![self.managedObjectContext save:&error]){
        NSLog(@"Unsolved error %@, %@",error,[error userInfo]);
        return NO;
    }
    return YES;
}

@end
