//
//  ViewController.m
//  FinalAdvange
//
//  Created by Nguyễn Văn Hoàng on 8/2/21.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "TableViewCell.h"
#import <Foundation/NSDate.h>
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate>
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) NSMutableArray *allPathOfMusics;
@property (nonatomic,strong) NSMutableArray *nameOfMusics;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (assign, nonatomic) NSUInteger indexOfCurrentSong;
@property (strong, nonatomic) NSMutableArray<NSString*> *previousSong;
@property (strong, nonatomic) IBOutlet UILabel *lbTotalTime;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *lbCurrentTime;
@property (strong,nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) IBOutlet UIButton *btnPrevious;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIButton *btnStopOrResum;
@property (strong, nonatomic) IBOutlet UIButton *btnAutoPlay;
@property (strong, nonatomic) IBOutlet UIButton *btnRandomSong;
@property (assign,nonatomic)  BOOL isPlaying;
@property (assign,nonatomic)  BOOL autoPlay;
@property (assign,nonatomic)  BOOL isRandomSong;

- (void)getAllPathOfMusic;
- (void)updateSlider;
- (void)pauseOrResume:(UIButton *)aButton withEvent:(UIEvent*) event;
- (void)disableButton;
- (void)enableButton;
- (void)playSong:(NSUInteger) index;
- (void)nextSong;
@property (strong, nonatomic) IBOutlet UILabel *lbNameOfCurrentSong;
- (NSString*)getTimeString:(int) totalTime;
@end
NSString *path;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[UIColor darkGrayColor]];
    [self.navigationController.navigationBar.topItem setTitle:@"Bi's App Music"];
    [self.myTableView setBackgroundColor:[UIColor darkGrayColor]];
    self.allPathOfMusics = [[NSMutableArray alloc] init];
    self.nameOfMusics = [[NSMutableArray alloc] init];
    self.previousSong = [[NSMutableArray alloc] init];
    [self.myTableView setDataSource:self];
    [self.myTableView setDelegate:self];
    [self getAllPathOfMusic];
    self.isPlaying = NO;
    self.autoPlay = NO;
    self.isRandomSong = NO;
    [self disableButton];
    self.indexOfCurrentSong = -1;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSlider) userInfo:nil repeats:true];
    [timer fire];
}
- (void)getAllPathOfMusic{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Music" ofType:nil ];
    NSLog(@"%@",path);
    NSArray *musicPath2 = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
    for(NSString *subPath in musicPath2){
        NSString *fullPath = [path stringByAppendingFormat:@"/%@", subPath];
        [self.allPathOfMusics addObject:fullPath];
        [self.nameOfMusics addObject:[[subPath substringToIndex:[subPath length]-4] stringByReplacingOccurrencesOfString:@"-" withString:@" "]];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allPathOfMusics.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    if(!cell){
        [tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    }
    cell = [cell initWithNameOfSong:[self.nameOfMusics objectAtIndex:indexPath.row] andRow:indexPath.row];
    cell.delegate = self;
    return cell;
}
- (void)playSong:(NSUInteger)index{
    self.indexOfCurrentSong = index;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[self.allPathOfMusics  objectAtIndex:index]] error:nil];
    [self enableButton];
    self.isPlaying = YES;
    [self.lbNameOfCurrentSong setText:[self.nameOfMusics objectAtIndex:index]];
    self.slider.maximumValue = (float) self.audioPlayer.duration;
    self.slider.value = 0;
    [self.audioPlayer play];
    [self.lbTotalTime setText:[self getTimeString:(int)self.audioPlayer.duration]];
    [self.btnStopOrResum setImage:[UIImage  systemImageNamed:@"pause"] forState:UIControlStateNormal];
    self.isPlaying = YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.indexOfCurrentSong == -1){
        self.indexOfCurrentSong = indexPath.row;
    }else{
        if([[self.previousSong lastObject]integerValue] != indexPath.row)
        {
            [self.previousSong addObject:[@(self.indexOfCurrentSong) stringValue]];
        }
        self.indexOfCurrentSong = indexPath.row;
    }
    [self playSong:indexPath.row];
}
- (void)addToFavoriteWithIndex:(NSUInteger)index{
    NSLog(@"===============%ld",index);
}
- (IBAction)sliderChangeTime:(id)sender {
    [self.audioPlayer play];
    [self.audioPlayer duration];
    NSTimeInterval time =  (double) self.slider.value;
    self.audioPlayer.currentTime = time;
    [self.btnStopOrResum setImage:[UIImage  systemImageNamed:@"pause"] forState:UIControlStateNormal];
    self.isPlaying = YES;
    
    
}
- (void)updateSlider{
    int currentTime = (int) self.audioPlayer.currentTime;
    int durractionTime = (int) self.audioPlayer.duration;
    [self.lbCurrentTime setText:[self getTimeString:currentTime]];
    self.slider.value = (float) self.audioPlayer.currentTime;
    if(durractionTime == currentTime && durractionTime != 0 && self.autoPlay == YES){
        [self nextSong];
    }
    
}
- (NSString *)getTimeString:(int)totalTime{
    int second,minute;
    minute = totalTime/60;
    second = totalTime - minute*60;
    NSString *timeValue = [NSString stringWithFormat:@"%02d:%02d",minute,second];
    return  timeValue;
}
- (void)pauseOrResume:(UIButton *)aButton withEvent:(UIEvent *)event{
    NSLog(@"Touch");
}
- (IBAction)btnPauseOrResumeClick:(id)sender {
    if(self.isPlaying)
    {
        [self.btnStopOrResum setImage:[UIImage  systemImageNamed:@"play"] forState:UIControlStateNormal];
        self.isPlaying = !self.isPlaying;
        [self.audioPlayer stop];
    }else{
        [self.btnStopOrResum setImage:[UIImage  systemImageNamed:@"pause"] forState:UIControlStateNormal];
        self.isPlaying = !self.isPlaying;
        [self.audioPlayer play];
    }
}
- (void)disableButton{
    [self.btnNext setEnabled:NO];
    [self.btnPrevious setEnabled:NO];
    [self.btnStopOrResum setEnabled:NO];
    [self.slider setEnabled:NO];
}
- (void)enableButton{
    [self.btnNext setEnabled:YES];
    [self.btnPrevious setEnabled:YES];
    [self.btnStopOrResum setEnabled:YES];
    [self.slider setEnabled:YES];
}
- (IBAction)btnNextClick:(id)sender {
    [self nextSong];
}
- (IBAction)btnPreviousClick:(id)sender {
    if(self.previousSong.count >=1 )
    {
        NSInteger index = [[self.previousSong objectAtIndex:self.previousSong.count-1] integerValue];
        self.indexOfCurrentSong=index;
        [self playSong:index];
        [self.previousSong removeLastObject];
    }else{
        [self playSong:self.indexOfCurrentSong];
    }
}
- (void)nextSong{
    if(!self.isRandomSong)
    {
        [self.previousSong addObject:[@(self.indexOfCurrentSong)stringValue]];
        if(self.indexOfCurrentSong + 1 > self.nameOfMusics.count-1){
            [self playSong:0];
        }else{
            [self playSong:self.indexOfCurrentSong+1];
        }
    }else{
        [self playSong:(NSInteger)(0 + arc4random_uniform((int)self.allPathOfMusics.count))];
    }
}
- (IBAction)btnAutoPlayClick:(id)sender {
    if(self.autoPlay == NO){
        [self.btnAutoPlay setImage:[UIImage systemImageNamed:@"chevron.forward.circle.fill"] forState:UIControlStateNormal];
    }else{
        [self.btnAutoPlay setImage:[UIImage systemImageNamed:@"chevron.forward.circle"] forState:UIControlStateNormal];
    }
    self.autoPlay = !self.autoPlay;
}
- (IBAction)btnRandomSongClick:(id)sender {
    if(self.isRandomSong == NO){
        [self.btnRandomSong setImage:[UIImage systemImageNamed:@"arrow.triangle.2.circlepath.circle"] forState:UIControlStateNormal];
    }else{
        [self.btnRandomSong setImage:[UIImage systemImageNamed:@"arrow.triangle.2.circlepath.circle.fill"] forState:UIControlStateNormal];
    }
    self.isRandomSong = !self.isRandomSong;
}
@end
