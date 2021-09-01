//
//  CustomReminderTableViewCell.m
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/12/21.
//

#import "CustomReminderTableViewCell.h"
@interface CustomReminderTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *lbFirstLine;
@property (strong, nonatomic) IBOutlet UILabel *lbSecondLine;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewPoster;

@property (strong,nonatomic) Movie* movie;
@end

@implementation CustomReminderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithMovie:(Movie *)movie{
    self = [super init];
    self.movie = movie;
    if(self){
        self.lbFirstLine.text = [self.movie.title stringByAppendingFormat:@"- %@ - %@",self.movie.releaseDate,self.movie.rate2];
        self.lbSecondLine.text = [self.movie reminderTime];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData* data= [NSData dataWithContentsOfURL:[NSURL URLWithString:[@"https://image.tmdb.org/t/p/w780/" stringByAppendingString:movie.imgLink]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageViewPoster setImage:[UIImage imageWithData:data]];
            });
        });
    }
    return self;
}
@end
