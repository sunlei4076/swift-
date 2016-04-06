//
//  OC_SweepViewController.m
//  koalac_PPM
//
//  Created by liuny on 15/7/7.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

#import "OC_SweepViewController.h"

@interface OC_SweepViewController ()
{
    ZBarReaderView *reader;
    NSTimer *timer;
    UIImageView *sweepLineImage;
}
@property (weak, nonatomic) IBOutlet UIImageView *sweepAreaView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBgView;
@end

@implementation OC_SweepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initControl];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self stopTimer];
    [reader stop];
    if (reader.torchMode == 1){
        reader.torchMode = 0;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [reader start];
    [self createTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initControl
{
    self.title = @"扫描";
    //back
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIImage *image = [UIImage imageNamed:@"NavigationBack"];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    //初始化
    reader = [[ZBarReaderView alloc] init];
    reader.frame = self.view.bounds;
    reader.readerDelegate = self;
    reader.tracksSymbols = NO;
    reader.torchMode = 0;
    [self.view insertSubview:reader atIndex:0];
    
    UIImage *sweepLine = [UIImage imageNamed:@"Sweep_Line"];
    sweepLineImage = [[UIImageView alloc] initWithImage:sweepLine];
    CGRect frame = sweepLineImage.frame;
    frame.origin.x = self.sweepAreaView.frame.origin.x;
    frame.origin.y = self.sweepAreaView.frame.origin.y;
    frame.size.width = sweepLine.size.width;
    frame.size.height = sweepLine.size.height;
    sweepLineImage.frame = frame;
    [self.view addSubview:sweepLineImage];
    
    image = [UIImage imageNamed:@"Sweep_BottomBlack"];
    self.bottomBgView.image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//二维码的横线移动
-(void)moveUpAddDownLine
{
    if(sweepLineImage){
        CGRect frame = sweepLineImage.frame;
        if(frame.origin.y < self.sweepAreaView.center.y){
            frame.origin.y = CGRectGetMaxY(self.sweepAreaView.frame);
            [UIView animateWithDuration:2.0 animations:^{
                sweepLineImage.frame = frame;
            }];
        }else{
            frame.origin.y = CGRectGetMinY(self.sweepAreaView.frame);
            [UIView animateWithDuration:2.0 animations:^{
                sweepLineImage.frame = frame;
            }];
        }
    }
}

-(void)createTimer
{
    if(timer == nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(moveUpAddDownLine) userInfo:nil repeats:YES];
    }
}

-(void)stopTimer
{
    if(timer != nil){
        [timer invalidate];
        timer = nil;
    }
}

- (IBAction)openLight:(id)sender {
    if(reader.torchMode == 0){
        reader.torchMode = 1;
    }else{
        reader.torchMode = 0;
    }
}

#pragma mark - ZBarReaderViewDelegate
-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    // 得到扫描的条码内容
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(sweepSuccess:)]){
        [self.delegate sweepSuccess:symbolStr];
    }
    [reader stop];
}

-(void)readerView:(ZBarReaderView *)readerView didStopWithError:(NSError *)error
{
    if (error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"扫描失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
@end
