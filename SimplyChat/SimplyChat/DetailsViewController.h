//
//  DetailsViewController.h
//  SimplyChat
//
//  Created by Jivko Rusev on 11/9/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) User *contact;
@property (weak, nonatomic) IBOutlet UILabel *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *locationTextField;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end
