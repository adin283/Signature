//
//  ZJYSignatureView.h
//  Signature
//
//  Created by Kevin on 2016/10/25.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJYSignatureView : UIView

@property (strong, nonatomic) IBOutlet UILabel *signatureLabel;
@property (strong, nonatomic) CAShapeLayer *shapeLayer;

- (UIImage *)getSignatureImage;
- (void)clearSignature;

@end
