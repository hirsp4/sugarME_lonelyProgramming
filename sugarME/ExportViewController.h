//
//  ExportViewController.h
//  sugarME
//
//  Created by Fresh Prince on 31.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ExportViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) MFMailComposeViewController *globalMailComposer;

@end
