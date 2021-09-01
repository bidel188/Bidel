//
//  AboutViewController.m
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/18/21.
//

#import "AboutViewController.h"
#import <WebKit/WKWebView.h>
#import <UIKit/UIKit.h>
@interface AboutViewController ()
@property (strong, nonatomic) IBOutlet WKWebView *myWebView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.themoviedb.org/about"]]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
