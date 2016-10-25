//
//  SignatureViewController.m
//  Signature
//
//  Created by Kevin on 2016/10/25.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "SignatureViewController.h"
#import "ZJYSignatureView.h"
#import "ImageViewController.h"

@interface SignatureViewController ()

@property (strong, nonatomic) IBOutlet ZJYSignatureView *signatureView;

@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearButtonPressed:(UIBarButtonItem *)sender {
    [self.signatureView clearSignature];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ImageSignatureSegue"]) {
        ImageViewController *vc = segue.destinationViewController;
        vc.signatureImage = [self.signatureView getSignatureImage];
    }
}

@end
