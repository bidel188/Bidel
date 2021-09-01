//
//  CustomCollectionViewCell.h
//  PROJECT
//
//  Created by Nguyễn Văn Hoàng on 8/10/21.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
NS_ASSUME_NONNULL_BEGIN

@interface CustomCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPoster;
-(instancetype) initWithMovie:(Movie *)movie andCache:(NSCache*) cache;

@end

NS_ASSUME_NONNULL_END
