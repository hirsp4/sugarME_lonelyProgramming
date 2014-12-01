//
//  ViewController.m
//  Mail
//
//  Created by Faton Shabanaj on 01.12.14.
//  Copyright (c) 2014 Faton Shabanaj. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Email:(id)sender {
        // Email Subject
        NSString *emailTitle = @"Kontaktanfrage sugarME";
        // Email Content
        NSString *messageBody = @"<h1>Ich kontaktiere Sie aus folgendem Grund</h1>"; // Change the message body to HTML
        // To address
        NSString *address = [(UIButton *)sender currentTitle];
        NSArray *toRecipents = [NSArray arrayWithObject:address];
        
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
        mailCompose.mailComposeDelegate = self;
        [mailCompose setSubject:emailTitle];
        [mailCompose setToRecipients:toRecipents];
        [mailCompose setMessageBody:messageBody isHTML:YES];
    
        
        // Present mail view controller on screen
        [self presentViewController:mailCompose animated:YES completion:NULL];
        
    }
    

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end


