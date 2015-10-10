//
//  ViewController.m
//  Homework24_Draw2
//
//  Created by MD on 14.04.15.
//  Copyright (c) 2015 hh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic)   IBOutlet UIImageView *drawImage;
@property (assign, nonatomic) CGPoint lastPoint;

@property (weak, nonatomic)    UIView *boardForDraw;
@property (weak, nonatomic)    UISlider* slider;
@property (strong, nonatomic)  NSArray* arrayColor;
@property (strong , nonatomic) UIColor* colorViewController;

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray* array = [NSArray arrayWithObjects:	[UIColor greenColor], [UIColor blueColor],
                      [UIColor yellowColor],[UIColor redColor],
                      [UIColor cyanColor],  [UIColor magentaColor],
                      [UIColor orangeColor],[UIColor purpleColor],
                      [UIColor clearColor], nil];
    
    self.arrayColor = array;
    
    
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.view.bounds),
                                                         CGRectGetMaxY(self.view.bounds)- ((CGRectGetHeight(self.view.bounds)*17)/100),
                                                         CGRectGetWidth(self.view.bounds),
                                                         (CGRectGetHeight(self.view.bounds)*17)/100)];
    
    self.boardForDraw = v;
    self.boardForDraw.backgroundColor = [UIColor brownColor];
    
    [self.view addSubview:self.boardForDraw];
    
    self.boardForDraw.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    
    
    CGFloat halfWeightBoard = CGRectGetWidth(self.boardForDraw.bounds)/2;
    CGFloat sizeWeightCellColor = halfWeightBoard/4.5;
    CGFloat sizeHeightCellColor = CGRectGetHeight(self.boardForDraw.bounds)/2.5;
    
    int x,y,tag;
    tag=x=y=0;
    
    
    for (int i=1; i<=2; i++) {
        x=0;
        for (int j=1; j<=4; j++) {
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self action:@selector(buttonMethod:)  forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"" forState:UIControlStateNormal];
            button.frame = CGRectMake(x, y, sizeWeightCellColor, sizeHeightCellColor);
            button.tag = tag;
            
            button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
            button.backgroundColor = [self.arrayColor objectAtIndex:tag];
            [self.boardForDraw addSubview:button];
            tag++;
            x+=sizeWeightCellColor+5;
        }
        y+=sizeHeightCellColor+5;
    }
    
    
    
    
    UISlider* s = [[UISlider alloc] initWithFrame:CGRectMake(halfWeightBoard, sizeHeightCellColor, (halfWeightBoard*55)/100 , 20)];
    
    self.slider = s;
    self.slider.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [self.slider setMinimumValue:5.0];
    [self.slider setMaximumValue:50.0];
    self.slider.value = self.slider.maximumValue/2.0;
    [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.boardForDraw addSubview:self.slider];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(buttonMethod:)  forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"" forState:UIControlStateNormal];
    button.frame = CGRectMake(CGRectGetWidth(s.bounds)+halfWeightBoard+10, 10, sizeWeightCellColor, sizeHeightCellColor);
    button.tag = tag++;
    
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    button.backgroundColor = [UIColor whiteColor];
    [self.boardForDraw addSubview:button];
    
    UIButton *buttonClear = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonClear addTarget:self action:@selector(buttonClear:)  forControlEvents:UIControlEventTouchUpInside];
    [buttonClear setTitle:@"Clear" forState:UIControlStateNormal];
    buttonClear.frame = CGRectMake(CGRectGetWidth(s.bounds)+halfWeightBoard+10, 10+sizeHeightCellColor*1.2, sizeWeightCellColor, sizeHeightCellColor);
    
    buttonClear.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    buttonClear.backgroundColor = [UIColor whiteColor];
    [self.boardForDraw addSubview:buttonClear];
    
}


- (IBAction)buttonMethod:(UIButton*)sender {
    
    self.colorViewController = [self.arrayColor objectAtIndex:sender.tag];

}

- (IBAction)buttonClear:(UIButton*)sender {
    
    self.drawImage.image = nil;
}

-(void) sliderValueChange:(UISlider*)sender {
    UISlider* slider = (UISlider*)sender;
    [[UIScreen mainScreen] setBrightness:[slider value]];
    NSLog(@" value = %f ",sender.value);
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    
    UITouch* touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self.drawImage];
    
    UIGraphicsBeginImageContext(self.drawImage.frame.size);
    
    [self.drawImage.image drawInRect:CGRectMake(0, 0,
                                     CGRectGetWidth(self.drawImage.frame),
                                     CGRectGetHeight(self.drawImage.frame))];
    
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),
                                   [self colorViewController ].CGColor);

    CGContextAddEllipseInRect(UIGraphicsGetCurrentContext(),
                              CGRectMake(self.lastPoint.x,
                                         self.lastPoint.y,
                                         self.slider.value,
                                          self.slider.value));

    CGContextFillPath(UIGraphicsGetCurrentContext());
    
    self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch* touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.drawImage];
    
    UIGraphicsBeginImageContext(self.drawImage.frame.size);
    
    [self.drawImage.image drawInRect:CGRectMake(0, 0,
                                                CGRectGetWidth(self.drawImage.frame),
                                                CGRectGetHeight(self.drawImage.frame))];
    
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [self colorViewController ].CGColor);
    
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),  self.slider.value);
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
    
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    
    self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.lastPoint = currentPoint;
    UIGraphicsEndImageContext();

}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
