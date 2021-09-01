//
//  CustomReminderTableViewCell.h
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/12/21.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
NS_ASSUME_NONNULL_BEGIN

@interface CustomReminderTableViewCell : UITableViewCell
-(instancetype) initWithMovie: (Movie*) movie;
@end

NS_ASSUME_NONNULL_END
