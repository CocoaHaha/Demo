//
//  ViewController.m
//  We
//
//  Created by 石向锋 on 2017/6/2.
//  Copyright © 2017年 CocoHaHa. All rights reserved.
//

#import "ViewController.h"
#import <Accelerate/Accelerate.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Label
    UILabel * Label = [[UILabel alloc]init];
    Label.frame = CGRectMake(0, 0,self.view.frame.size.width , self.view.frame.size.height);
    Label.text = @"这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。这是一个问题啊，没有什么问题，就是新的问题，还是不是新的问题。";
    Label.textColor = [UIColor blackColor];
    Label.font = [UIFont systemFontOfSize:14];
    Label.textAlignment = NSTextAlignmentLeft;
    Label.numberOfLines = 0;
    Label.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:Label];
    
    
    //按钮
    UIButton * Button = [[UIButton alloc]init];
    Button.frame = CGRectMake(50, 50, 50, 50);
    [Button setTitle:@"点击" forState:UIControlStateNormal];
    [Button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    Button.backgroundColor = [UIColor blueColor];
    Button.titleLabel.textAlignment = 1;
    [Button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Button];
    
//     [self convertViewToImage];
//    
//    [self configBlurEffect];
    
}

-(void)buttonClick
{
    UIImage * image = [self captureImageFromView:self.view];
    
    
    
    //    NSData * data = UIImageJPEGRepresentation(image,0.00001);
    //NSData * data = UIImagePNGRepresentation(image);
    
    //UIImage * images = [UIImage imageWithData:data];
    //ImageView
    UIImageView * ImageView = [[UIImageView alloc]init];
    ImageView.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    ImageView.image = [self blurredImageWithImage:image radius:5 iterations:2 tintColor:[UIColor blackColor]];
    [self.view addSubview:ImageView];
    ImageView.contentMode = UIViewContentModeScaleAspectFill;
    //[ImageView setImageToBlur: [UIImage imageNamed:@"huoying.jpg"] blurRadius: completionBlock:nil];
    ImageView.userInteractionEnabled = YES;
    [self.view addSubview:ImageView];
    
    
    
    //Label
    UILabel * twoLabel = [[UILabel alloc]init];
    twoLabel.frame = CGRectMake((self.view.frame.size.width - 200)/2, (self.view.frame.size.height - 100)/2, 200, 100);
    twoLabel.text = @"这是正常的效果！这是正常的效果！这是正常的效果！这是正常的效果！这是正常";
    twoLabel.textColor = [UIColor blackColor];
    twoLabel.font = [UIFont systemFontOfSize:20];
    twoLabel.numberOfLines = 0;
    twoLabel.textAlignment = NSTextAlignmentCenter;
    twoLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:twoLabel];
}

//截图功能
-(UIImage *)captureImageFromView:(UIView *)view
{
    //这个保存的是非高清截图
    //CGRect screenRect = [view bounds];
    //UIGraphicsBeginImageContext(screenRect.size);
    //下面这个保存的是高清截图
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//加模糊化效果
- (UIImage *)blurredImageWithImage:(UIImage *)image radius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor

{
    
    //image must be nonzero size
    
    if (floorf(image.size.width) * floorf(image.size.height) <= 0.0f) return image;
    
    //boxsize must be an odd integer
    
    uint32_t boxSize = (uint32_t)(radius * image.scale);
    
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    
    CGImageRef imageRef = image.CGImage;
    
    vImage_Buffer buffer1, buffer2;
    
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    
    size_t bytes = buffer1.rowBytes * buffer1.height;
    
    buffer1.data = malloc(bytes);
    
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
        
    {
        
        //perform blur
        
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        
        void *temp = buffer1.data;
        
        buffer1.data = buffer2.data;
        
        buffer2.data = temp;
        
    }
    
    //free buffers
    
    free(buffer2.data);
    
    free(tempBuffer);
    
    //create image context from buffer
    
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
        
    {
        
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
        
    }
    
    //create image from context
    
    imageRef = CGBitmapContextCreateImage(ctx);
    
    UIImage *image2 = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    
    CGImageRelease(imageRef);
    
    CGContextRelease(ctx);
    
    free(buffer1.data);
    
    return image2;
    
}

-(UIImage *)convertViewToImage

{
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}
- (void)configBlurEffect{
    

    // 创建模糊View
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.alpha = 0.6;
    effectView.layer.cornerRadius = 10.0f;
    effectView.layer.masksToBounds = YES;
    effectView.frame = CGRectMake(80, 300, 160, 80);
    [self.view addSubview:effectView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:effectView.bounds];
    label.text = @"Blur Effect";
    label.backgroundColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    //    [effectView.contentView addSubview:label];
    // 在创建的模糊View的上面再添加一个子模糊View
    UIVisualEffectView *subEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:(UIBlurEffect *)effectView.effect]];
    
    subEffectView.frame = effectView.bounds;
    
    subEffectView.alpha = 0.99;
    
    [effectView.contentView addSubview:subEffectView];
    
    [subEffectView.contentView addSubview:label];
}


-(BOOL)validatePwd:(NSString *)param
{
    NSString *pwdRegex = @"^[a-zA-Z0-9]+$";
    NSPredicate *pwdPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pwdRegex];
    return [pwdPredicate evaluateWithObject:param];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
