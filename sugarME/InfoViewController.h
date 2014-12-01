//
//  ViewController.h
//  Mail
//
//  Created by Faton Shabanaj on 01.12.14.
//  Copyright (c) 2014 Faton Shabanaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface InfoViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)Email:(id)sender;

@end

