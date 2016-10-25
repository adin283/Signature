//
//  ZJYSignatureView.m
//  Signature
//
//  Created by Kevin on 2016/10/25.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "ZJYSignatureView.h"

@interface ZJYSignatureView ()

@property (strong, nonatomic) UIBezierPath *beizerPath;
@property (strong, nonatomic) UIImage *incrImage;
@property (assign, nonatomic) NSInteger control;
@property (strong, nonatomic) NSMutableArray *points;
@property (assign, nonatomic) CGPoint topLeftPoint;
@property (assign, nonatomic) CGPoint bottomRightPoint;

@end

@implementation ZJYSignatureView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    self.beizerPath = [UIBezierPath bezierPath];
    [self.beizerPath setLineWidth:2.0];
    [self setMultipleTouchEnabled:NO];
    self.points = [NSMutableArray arrayWithCapacity:5];
    
    self.topLeftPoint = CGPointMake(self.bounds.size.width, self.bounds.size.height);
    self.bottomRightPoint = CGPointZero;
}

- (void)drawRect:(CGRect)rect
{
    [self.incrImage drawInRect:rect];
    [self.beizerPath stroke];
    
    UIColor *fillColor = [UIColor redColor];
    [fillColor setFill];
    UIColor *strokeColor = [UIColor redColor];
    [strokeColor setStroke];
    [self.beizerPath stroke];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.signatureLabel superview]) {
        [self.signatureLabel removeFromSuperview];
    }
    
    self.control = 0;
    UITouch *touch = [touches anyObject];
    self.points[0] = [NSValue valueWithCGPoint:[touch locationInView:self]];
    
    [self storeTopLeftPoint:[self.points[0] CGPointValue]];
    [self storeBottomRightPoint:[self.points[0] CGPointValue]];
    
    CGPoint startPoint = [self.points[0] CGPointValue];
    CGPoint endPoint = CGPointMake(startPoint.x + 1.5, startPoint.y + 2);
    
    [self.beizerPath moveToPoint:startPoint];
    [self.beizerPath addLineToPoint:endPoint];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    [self storeTopLeftPoint:touchPoint];
    [self storeBottomRightPoint:touchPoint];
    
    self.control++;
    self.points[self.control] = [NSValue valueWithCGPoint:touchPoint];
    
    if (self.control == 4) {
        CGPoint p = CGPointMake(([self.points[2] CGPointValue].x + [self.points[4] CGPointValue].x) / 2.0, ([self.points[2] CGPointValue].y + [self.points[4] CGPointValue].y) / 2.0);
        self.points[3] = [NSValue valueWithCGPoint:p];
        
        [self.beizerPath moveToPoint:[self.points[0] CGPointValue]];
        [self.beizerPath addCurveToPoint:[self.points[3] CGPointValue] controlPoint1:[self.points[1] CGPointValue] controlPoint2:[self.points[2] CGPointValue]];
        
        [self setNeedsDisplay];
        
        self.points[0] = self.points[3];
        self.points[1] = self.points[4];
        self.control = 1;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self drawBitmapImage];
    [self setNeedsDisplay];
    [self.beizerPath removeAllPoints];
    self.control = 0;
    NSLog(@"topleft:%@, bottomRight:%@", NSStringFromCGPoint(self.topLeftPoint), NSStringFromCGPoint(self.bottomRightPoint));
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawBitmapImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    
    if (!self.incrImage)
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor whiteColor] setFill];
        [rectpath fill];
    }
    [self.incrImage drawAtPoint:CGPointZero];
    
    //Set final color for drawing
    UIColor *strokeColor = [UIColor redColor];
    [strokeColor setStroke];
    [self.beizerPath stroke];
    self.incrImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (UIImage *)getSignatureImage
{
    if ([self.signatureLabel superview]) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *signatureImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect sizeInPoint = [self getImageRect];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect rectInPixel = CGRectMake(sizeInPoint.origin.x * scale, sizeInPoint.origin.y * scale, sizeInPoint.size.width * 2, sizeInPoint.size.height * 2);
    CGImageRef imageRef = CGImageCreateWithImageInRect([signatureImage CGImage], rectInPixel);
    UIImage *cropImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropImage;
}

- (void)clearSignature
{
    self.incrImage = nil;
    [self configure];
    [self setNeedsDisplay];
}

- (void)storeTopLeftPoint:(CGPoint)point
{
    self.topLeftPoint = CGPointMake(fmin(self.topLeftPoint.x, point.x), fmin(self.topLeftPoint.y, point.y));
}

- (void)storeBottomRightPoint:(CGPoint)point
{
    self.bottomRightPoint = CGPointMake(fmax(self.bottomRightPoint.x, point.x), fmax(self.bottomRightPoint.y, point.y));
}

- (CGRect)getImageRect
{
    CGSize size = CGSizeMake(self.bottomRightPoint.x - self.topLeftPoint.x, self.bottomRightPoint.y - self.topLeftPoint.y);
    return CGRectMake(self.topLeftPoint.x, self.topLeftPoint.y, size.width, size.height);
}

@end
