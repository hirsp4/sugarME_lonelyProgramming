//
//  ExportViewController.m
//  sugarME
//
//  Created by Fresh Prince on 31.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "ExportViewController.h"
#import "AppDelegate.h"

@interface ExportViewController ()

@end

@implementation ExportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Senden" style:UIBarButtonItemStylePlain target:self action:@selector(sendData:)];
    self.navigationItem.rightBarButtonItem = sendButton;
    [self cycleTheGlobalMailComposer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) sendData:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Diabetes Daten";
    // Email Content
    NSString *messageBody = @"Wow, so viele Daten!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"shabf2@bfh.ch"];
    
    self.globalMailComposer.mailComposeDelegate = self;
    [self.globalMailComposer setSubject:emailTitle];
    [self.globalMailComposer setMessageBody:messageBody isHTML:NO];
    [self.globalMailComposer setToRecipients:toRecipents];
    
    
    // Present mail view controller on screen
    [self presentViewController:self.globalMailComposer animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:^
     { [self cycleTheGlobalMailComposer]; }
     ];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)cycleTheGlobalMailComposer
         {
             // we are cycling the damned GlobalMailComposer... due to horrible iOS issue
             self.globalMailComposer = nil;
             self.globalMailComposer = [[MFMailComposeViewController alloc] init];
         }
@end
