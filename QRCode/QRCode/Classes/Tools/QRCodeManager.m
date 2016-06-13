//
//  QRCodeManager.m
//  QRCode
//
//  Created by Michael Katarina on 16/6/13.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

#import "QRCodeManager.h"

@implementation QRCodeManager

static QRCodeManager *_instance;
+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    
    return _instance;
}



#pragma mark -----------------------生成二维码代码
/**
 *  生成二维码
 *
 *  @param inputMsg 二维码保存的信息
 *  @param fgImage  前景图片
 *
 *  @return 返回的二维码图片
 */
-(UIImage *)generateQRCodeWithMsg:(NSString *)inputMsg fgImage:(UIImage *)fgImage{
    // 1.将内容生成二维码
    // 1.1创建滤镜(name = "CIQRCodeGenerator")
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 1.1.1恢复默认设置
    [filter setDefaults];
    
    // 1.1.2设置生成的二维码的容错率 key = inputCorrectionLevel value = @"L/M/Q/H"
    [filter setValue:@"H" forKeyPath:@"inputCorrectionLevel"];
    
    // 2.设置输入的内容(KVC)
    // 注意:key = inputMessage, value必须是NSData类型
    NSData *inputData = [inputMsg dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:inputData forKeyPath:@"inputMessage"];
    
    // 3.获取输出的图片
    CIImage *outImage = [filter outputImage];
    
    // 4.获取高清图片
    UIImage *hdImage = [self createHDImageWithOriginalImage:outImage];

    // 5.判断是否有前景图片
    if (fgImage == nil) {
        return  hdImage;
    }
    
    // 6.获取有前景图片的二维码图像
     return [self createResultImageWithHDImage:hdImage fgImage:fgImage];
    
}

-(UIImage *)createHDImageWithOriginalImage:(CIImage *)ciImage{
    
    // 1.创建Transform,放大10倍
    CGAffineTransform transform = CGAffineTransformMakeScale(10, 10);
    
    // 2.放大图片
    ciImage = [ciImage imageByApplyingTransform:transform];
    
    return [UIImage imageWithCIImage:ciImage];
    
}

- (UIImage *)createResultImageWithHDImage:(UIImage *)hdImage fgImage:(UIImage *)fgImage{
    
    // 1.获取高清图片的size
    CGSize size = hdImage.size;
    
    // 2.开启图形上下文
    UIGraphicsBeginImageContext(size);
    
    // 3.将高清图片画到上下文中
    [hdImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 4.将前景图片画到上下文中
    //设置图片的大小
    CGFloat w = 80;
    CGFloat h = 80;
    CGFloat x = (size.width - w) * 0.5;
    CGFloat y = (size.height - h) * 0.5;
    [fgImage drawInRect:CGRectMake(x, y, w, h)];
    
    // 5.获取上下文中图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return resultImage;
}



#pragma mark -----------------------识别二维码代码
-(NSArray *)detectorQRCodeWithQRCodeImage:(UIImage *)qrCodeImage{
    
    // 1.创建过滤器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    
    // 2.获取CIImage对象
    CIImage *ciImage = [[CIImage alloc]initWithImage:qrCodeImage];
    
    // 3.识别图片中的二维码
    NSArray *features = [detector featuresInImage:ciImage];
    
    // 4.遍历数组,拿到二维码信息
    NSMutableArray *resultArray = [NSMutableArray array];
    for (CIQRCodeFeature *f in features) {
        [resultArray addObject:f.messageString];
    }
    
    return resultArray;
}













@end
