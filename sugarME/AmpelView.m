//
//  AmpelView.m
//  sugarME
//
//  Created by Fresh Prince on 14.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "AmpelView.h"
#import "AppDelegate.h"
#import "HbA1c.h"

@implementation AmpelView
@synthesize hba1cValues, managedObjectContext;

- (void)drawRect:(CGRect)rect {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    [self performFetches];

    
    CGRect rectangle = CGRectMake(30, 80, 70, 170);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0,1.0);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.5);
    CGContextFillRect(context, rectangle);
    CGContextStrokeRect(context, rectangle);
    
    int radius = 20;
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    circle.position = CGPointMake(45,
                                  95);
    
    circle.fillColor = [UIColor redColor].CGColor;
    circle.strokeColor = [UIColor blackColor].CGColor;
    circle.lineWidth = 1;
    
    CAShapeLayer *circle2 = [CAShapeLayer layer];
    circle2.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    circle2.position = CGPointMake(45,
                                  145);
    
    circle2.fillColor = [UIColor yellowColor].CGColor;
    circle2.strokeColor = [UIColor blackColor].CGColor;
    circle2.lineWidth = 1;
    
    CAShapeLayer *circle3 = [CAShapeLayer layer];
    circle3.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    circle3.position = CGPointMake(45,
                                  195);
    
    circle3.fillColor = [UIColor greenColor].CGColor;
    circle3.strokeColor = [UIColor blackColor].CGColor;
    circle3.lineWidth = 1;
    
    [self.layer addSublayer:circle];
    [self.layer addSublayer:circle2];
    [self.layer addSublayer:circle3];
    
}
-(void) performFetches{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"HbA1c" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    self.hba1cValues =[[managedObjectContext executeFetchRequest:fetchRequest error:&error] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    
}

@end
