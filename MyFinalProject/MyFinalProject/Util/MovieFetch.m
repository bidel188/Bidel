//
//  MovieFetch.m
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/10/21.
//

#import "MovieFetch.h"
#import "DBManager.h"
#import "Movie.h"
static NSString *const entityName = @"Movie";
static NSString *const keyForSort = @"movieID";
@implementation MovieFetch
- (NSArray *)startFetching{
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
- (NSArray *)fetchingWithFilterByMovieID:(NSString *)movieID{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"movieID = %@",movieID];
    [fetchRequest setPredicate:predicate];
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
