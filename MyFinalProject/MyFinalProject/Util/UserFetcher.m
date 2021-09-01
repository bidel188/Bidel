//
//  UserFetcher.m
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/17/21.
//

#import "UserFetcher.h"
#import "DBManager.h"
#import "User.h"
static NSString *const entityName = @"User";
static NSString *const keyForSort = @"name";
@implementation UserFetcher

- (NSArray *)startFetching{ //Fetching user information from DB
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[DBManager sharedInstance].managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:keyForSort ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[DBManager sharedInstance].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    return [fetchedResultsController fetchedObjects];
}
@end
