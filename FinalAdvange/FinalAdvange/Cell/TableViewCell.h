//
//  TableViewCell.h
//  FinalAdvange
//
//  Created by Nguyễn Văn Hoàng on 8/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  TableViewCellDelegate <NSObject>
- (void)addToFavoriteWithIndex:(NSUInteger) index;
@end
@interface TableViewCell : UITableViewCell
- (instancetype) initWithNameOfSong:(NSString *) nameOfSong andRow: (NSInteger) row;
@property (nonatomic,weak) id<TableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
