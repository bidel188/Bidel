//
//  SettingViewController.m
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/18/21.
//

#import "SettingViewController.h"
#import "SWRevealViewController.h"
@interface SettingViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnUser;


@end

@implementation SettingViewController
NSMutableArray *array ;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnUser setTarget: self.revealViewController];
    [self.btnUser setAction: @selector( revealToggle: )];
    self.revealViewController.rearViewRevealWidth = self.view.frame.size.width-70;
    
    
}


@end
