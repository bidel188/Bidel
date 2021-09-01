//
//  TableViewController.h
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/18/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MyDelegate <NSObject>

-(void)SetValueForParam:(NSInteger) url andRateFrom:(double) rate andYearFrom:(NSUInteger) year andSortBy:(NSString*) keyForSort andNumberOfPage:(NSUInteger) noPage;
@end
@interface TableViewController : UITableViewController
@property (nonatomic,weak) id<MyDelegate> delegate2;
@end

NS_ASSUME_NONNULL_END
