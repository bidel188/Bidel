//
//  TableViewCell.m
//  FinalAdvange
//
//  Created by Nguyễn Văn Hoàng on 8/3/21.
//

#import "TableViewCell.h"
#import "ViewController.h"
@interface TableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *lbNameOfSong;
@property (assign, nonatomic) NSInteger row;

@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnLikeClick:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(addToFavoriteWithIndex:)]){
        [self.delegate addToFavoriteWithIndex:self.row];
    }

}
- (instancetype)initWithNameOfSong:(NSString *)nameOfSong andRow:(NSInteger)row{
    self = [super init];
    if(self){
        [self.lbNameOfSong setText:nameOfSong];
        self.row = row;
    }
    return  self;
}
@end
