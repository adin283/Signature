//
//  ImageViewController.m
//  Signature
//
//  Created by Kevin on 2016/10/25.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *signatureImageView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.signatureImageView.image = self.signatureImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
