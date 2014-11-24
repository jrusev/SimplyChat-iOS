//
//  Notifier.h
//  SimplyChat
//
//  Created by Jivko Rusev on 11/7/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Notifier : UIViewController

+(void)showAlert:(NSString*)title message:(NSString*)message andBtn:(NSString*)button;

@end
