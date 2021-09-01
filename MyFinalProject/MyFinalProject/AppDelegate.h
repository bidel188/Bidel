//
//  AppDelegate.h
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/10/21.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate : UIResponder <UNUserNotificationCenterDelegate,UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

