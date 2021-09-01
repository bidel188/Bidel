//
//  CustomCastCollectionViewCell.m
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/11/21.
//

#import "CustomCastCollectionViewCell.h"
@interface CustomCastCollectionViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *imageViewCast;
@property (strong, nonatomic) IBOutlet UILabel *lbCastName;

@end
@implementation CustomCastCollectionViewCell
NSString *baseURLImageCA = @"https://image.tmdb.org/t/p/w780/";
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithata:(NSString *)name andURL:(NSString *)url{
    self = [super init];
    if(self){
        [self.lbCastName setText:name];
        NSLog(@"%@",url);
        if([url isEqualToString:@""]){
            [self.imageViewCast setImage:[UIImage imageNamed:@"non"]];
        }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData* data= [NSData dataWithContentsOfURL:[NSURL URLWithString:[baseURLImageCA stringByAppendingFormat:@"%@", url]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageViewCast setImage:[UIImage imageWithData:data]];
            });
        });}}
    return self;
}
@end
