//
//  DetailsViewController.m
//  SimplyChat
//
//  Created by Jivko Rusev on 11/9/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DetailsViewController.h"
#import "UIImage+Helpers.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameTextField.text = [self.contact description];
    self.locationTextField.text = [NSString stringWithFormat:@"Location: %@", self.contact.city];
    
    // Load image async
    if (self.contact.imageUrl.length) {
        NSURL *imageUrl = [NSURL URLWithString:self.contact.imageUrl];
        [UIImage loadFromURL:imageUrl callback:^(UIImage *image) {
            self.photoImageView.image = image;
            self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.height /2;
            self.photoImageView.layer.masksToBounds = YES;
            self.photoImageView.layer.borderWidth = 0;
        }];
    }
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
