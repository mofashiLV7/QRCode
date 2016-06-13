//
//  ViewController.m
//  QRCode
//
//  Created by Michael Katarina on 16/6/13.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)createQRCode:(id)sender {
    
    self.imageV.image = [[QRCodeManager shareInstance]generateQRCodeWithMsg:@"hahah" fgImage:nil];
}


@end
