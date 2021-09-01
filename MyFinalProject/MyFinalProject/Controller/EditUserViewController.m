//
//  EditUserViewController.m
//  MyFinalProject
//
//  Created by Nguyễn Văn Hoàng on 8/14/21.
//


#import "User.h"
#import "DBManager.h"
#import "UserFetcher.h"
#import "EditUserViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface EditUserViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UITextField *tfName;
@property (strong, nonatomic) IBOutlet UITextField *tfEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnGender;
@property (strong, nonatomic) IBOutlet UILabel *lbGender;
@property (strong, nonatomic) IBOutlet UIImageView *imageAvatar;
@property (strong, nonatomic) IBOutlet UILabel *lbDateOfBirt;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIDatePicker *dateTimePicker;

- (void)getUser;
- (void)avatarClick;
- (void)dateClick;
@end

@implementation EditUserViewController
BOOL isMale = YES;
NSDateFormatter *formatter5;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUser];
    [self.imageAvatar setImage:[UIImage imageWithData:self.user.image]];
    self.imageAvatar .layer.cornerRadius = self.imageAvatar.frame.size.width / 2;
    self.imageAvatar.layer.masksToBounds = YES;
    [self.lbGender setText:self.user.gender];
    [self.lbDateOfBirt setText:self.user.dateOfBirth];
    [self.tfName setText:self.user.name];
    [self.tfEmail setText:self.user.email];
    [self.view1 setFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height*70/100-30)];
    [self.view1 setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*30/100)];
    [self.view2 setHidden:YES];
    [self.dateTimePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    
    if([self.user.gender isEqualToString:@"Male"]){
        isMale = YES;
    }
    if(isMale){
        [self.btnGender setImage:[UIImage imageNamed:@"male"] forState:UIControlStateNormal];
    }else{
        [self.btnGender setImage:[UIImage imageNamed:@"female"] forState:UIControlStateNormal];
    }
    formatter5 = [[NSDateFormatter alloc] init];
    [formatter5 setDateFormat:@"yyyy/MM/dd"];
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick)];
    UITapGestureRecognizer *singleFingerTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateClick)];
    [self.imageAvatar addGestureRecognizer:singleFingerTap];
    [self.lbDateOfBirt addGestureRecognizer:singleFingerTap2 ];
    
}
- (IBAction)btnCancelClick:(id)sender {
    UITabBarController *newFrontController = [self.storyboard instantiateInitialViewController];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
//    [newFrontController setModalPresentationStyle:UIModalPresentationOverFullScreen];
//    [self presentViewController:newFrontController animated:YES completion:nil];
    [self.revealViewController pushFrontViewController:newFrontController animated:YES];
}
- (void)getUser{
    NSArray *array = [[UserFetcher new] startFetching];
    if(array == nil || array.count<1){
        User *newUser =[[User alloc] initWithName:@"" andEmail:@"" andGender:@"Male" andDateOfBirth:@"" andImage:UIImagePNGRepresentation([UIImage imageNamed:@""])];
        [[DBManager sharedInstance] addUser:newUser];
        self.user = newUser;
        return;
    }else{
        self.user = [array objectAtIndex:0];
        return;
    }
}
- (IBAction)btnGenderClick:(id)sender {
    if(isMale){
        [self.btnGender setImage:[UIImage imageNamed:@"female"] forState:UIControlStateNormal];
        [self.lbGender setText:@"Female"];
    }else{
        [self.btnGender setImage:[UIImage imageNamed:@"male"] forState:UIControlStateNormal];
        [self.lbGender setText:@"Male"];
    }
    isMale =!isMale;
}
- (void)avatarClick{
    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
    [pickerLibrary setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    pickerLibrary.delegate = self;
    [pickerLibrary setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:pickerLibrary animated:YES completion:Nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [self.imageAvatar setImage:info[UIImagePickerControllerOriginalImage]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnDone:(id)sender {
    NSString *name;
    NSString *email;
    NSString *dateOfBirth;
    NSString *gender;
    if(![self.tfName.text isEqualToString:@""]){
        name = [self.tfName text];
    }else{
        name = @"Your Name";
    }
    if(![self.tfEmail.text isEqualToString:@""]){
        email = [self.tfEmail text];
    }else{
        email = @"Your Email";
    }
    dateOfBirth = self.lbDateOfBirt.text;
    gender = self.lbGender.text;
    NSData *imageData = UIImagePNGRepresentation(self.imageAvatar.image);
    User *user = [[User alloc] initWithName:name andEmail:email andGender:gender andDateOfBirth:dateOfBirth andImage:imageData];
    [[DBManager sharedInstance] updateUser:user];
    self.user = user;
    UITabBarController *newFrontController = [self.storyboard instantiateInitialViewController];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//    [newFrontController setModalPresentationStyle:UIModalPresentationOverFullScreen];
//    [self presentViewController:newFrontController animated:YES completion:nil];
    [self.revealViewController pushFrontViewController:newFrontController animated:YES];
}
- (void)dateClick{
    [self.view2 setHidden:NO];
    [self.view1 setUserInteractionEnabled:NO];
}
- (IBAction)cancelChoseDateClick:(id)sender {
    [self.view1 setUserInteractionEnabled:YES];
    [self.view2 setHidden:YES];
}
- (IBAction)doneChoseDateClick:(id)sender {
    self.lbDateOfBirt.text = [formatter5 stringFromDate:[self.dateTimePicker date]];
    [self.view1 setUserInteractionEnabled:YES];
    [self.view2 setHidden:YES];
}
@end
