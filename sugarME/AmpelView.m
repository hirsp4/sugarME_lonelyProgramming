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
@synthesize hba1cValues, managedObjectContext, hba1cEinstellungen;
/**
 *  first called method. draws the latest measured hba1c value to an uiview container.
 *
 *  @param rect
 */
- (void)drawRect:(CGRect)rect {
    // get the managed object context to fetch data
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    // set date format
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy - HH:mm"];
    //fetch the data
    [self performFetches];
    
    float normalLowValue = 3.0f;
    float normalHighValue = 8.0f;
    if([[[self.hba1cEinstellungen lastObject]valueForKey:@"zielbereich"]length]>0){
        normalLowValue= [[[[self.hba1cEinstellungen lastObject]valueForKey:@"zielbereich"]substringToIndex:3]floatValue];
        normalHighValue = [[[[self.hba1cEinstellungen lastObject]valueForKey:@"zielbereich"]substringWithRange:NSMakeRange(5, 3)]floatValue];
    }
    if(normalHighValue<normalLowValue){
        float temp = normalLowValue;
        normalLowValue = normalHighValue;
        normalHighValue=temp;
    }

    
    // build ampel
    CGRect rectangle = CGRectMake(30, 80, 70, 170);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0,1.0);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.5);
    CGContextFillRect(context, rectangle);
    CGContextStrokeRect(context, rectangle);
    
    CGRect rectangle2 = CGRectMake(50, 250, 30, 20);
    context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0,1.0);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.5);
    CGContextFillRect(context, rectangle2);
    CGContextStrokeRect(context, rectangle2);
    
    CGRect rectangle3 = CGRectMake(60, 270, 10, 40);
    context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0,1.0);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.5);
    CGContextFillRect(context, rectangle3);
    CGContextStrokeRect(context, rectangle3);
    
    // build circles
    int radius = 20;
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    circle.position = CGPointMake(45,
                                  95);
    
    circle.strokeColor = [UIColor blackColor].CGColor;
    circle.lineWidth = 1;
    
    CAShapeLayer *circle2 = [CAShapeLayer layer];
    circle2.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    circle2.position = CGPointMake(45,
                                  145);
    
    circle2.strokeColor = [UIColor blackColor].CGColor;
    circle2.lineWidth = 1;
    
    CAShapeLayer *circle3 = [CAShapeLayer layer];
    circle3.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    circle3.position = CGPointMake(45,
                                  195);
    
    circle3.strokeColor = [UIColor blackColor].CGColor;
    circle3.lineWidth = 1;

    // set colors for the circles depending on the latest measured value
    if([[[self.hba1cValues firstObject]valueForKey:@"value"]floatValue]>(normalHighValue+2.0f) || [[[self.hba1cValues firstObject]valueForKey:@"value"]floatValue]<(normalLowValue-2.0f)){
        circle.fillColor = [UIColor redColor].CGColor;
        circle2.fillColor = [UIColor lightGrayColor].CGColor;
        circle3.fillColor = [UIColor lightGrayColor].CGColor;
    }else if(([[[self.hba1cValues firstObject]valueForKey:@"value"]floatValue]>=normalHighValue && [[[self.hba1cValues firstObject]valueForKey:@"value"]floatValue]<=(normalHighValue+2.0f)) || ([[[self.hba1cValues firstObject]valueForKey:@"value"]floatValue]<=normalLowValue && [[[self.hba1cValues firstObject]valueForKey:@"value"]floatValue]>=(normalLowValue-2.0f))){
        circle.fillColor = [UIColor lightGrayColor].CGColor;
        circle2.fillColor = [UIColor yellowColor].CGColor;
        circle3.fillColor = [UIColor lightGrayColor].CGColor;
    }else if([[[self.hba1cValues firstObject]valueForKey:@"value"]floatValue]>=normalLowValue && [[[self.hba1cValues firstObject]valueForKey:@"value"]floatValue]<=normalHighValue){
        circle.fillColor = [UIColor lightGrayColor].CGColor;
        circle2.fillColor = [UIColor lightGrayColor].CGColor;
        circle3.fillColor = [UIColor greenColor].CGColor;
    }
    if(self.hba1cValues.count==0){
        circle.fillColor = [UIColor lightGrayColor].CGColor;
        circle2.fillColor = [UIColor lightGrayColor].CGColor;
        circle3.fillColor = [UIColor lightGrayColor].CGColor;
    }
    [self.layer addSublayer:circle];
    [self.layer addSublayer:circle2];
    [self.layer addSublayer:circle3];

    
    // set the value description text on the right side of the ampel
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    CGContextSelectFont(context, "Helvetica", 20, kCGEncodingMacRoman);
    NSString *theText1 = [NSString stringWithFormat:@"%@", @"Letzter Wert:"];
    CGContextShowTextAtPoint(context, 150,140, [theText1 cStringUsingEncoding:NSUTF8StringEncoding], [theText1 length]);
    if (self.hba1cValues.count!=0) {
    CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman);
    NSString *theText = [NSString stringWithFormat:@"%@", @"Gemessen am: "];
    CGContextShowTextAtPoint(context, 168,205, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
    NSString *theText3=[[NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[[self.hba1cValues firstObject]valueForKey:@"date"]]]stringByAppendingString:@" Uhr"];
    CGContextShowTextAtPoint(context, 145,220, [theText3 cStringUsingEncoding:NSUTF8StringEncoding], [theText3 length]);
    CGContextSelectFont(context, "Helvetica-Bold", 30, kCGEncodingMacRoman);
    NSString *theText2 = [[NSString stringWithFormat:@"%@", [[self.hba1cValues firstObject]valueForKey:@"value"]]stringByAppendingString:@"%"];
    CGContextShowTextAtPoint(context, 178,180, [theText2 cStringUsingEncoding:NSUTF8StringEncoding], [theText2 length]);
    
    CGContextSelectFont(context, "Helvetica", 11, kCGEncodingMacRoman);
    NSString *skala = [NSString stringWithFormat:@"%@", @"Rot:  >"];
    skala = [skala stringByAppendingString:[NSString stringWithFormat:@"%.1f", (normalHighValue+2.0f)]];
    skala = [skala stringByAppendingString:[NSString stringWithFormat:@"%@", @"% oder <"]];
    skala = [skala stringByAppendingString:[NSString stringWithFormat:@"%.1f", (normalLowValue-2.0f)]];
    skala = [skala stringByAppendingString:[NSString stringWithFormat:@"%@", @"%"]];
    CGContextShowTextAtPoint(context, 170,280, [skala cStringUsingEncoding:NSUTF8StringEncoding], [skala length]);
        
    NSString *skala1 = [NSString stringWithFormat:@"%@", @"Gelb: +/- 2% Toleranz"];
    CGContextShowTextAtPoint(context, 170,295, [skala1 cStringUsingEncoding:NSUTF8StringEncoding], [skala1 length]);
        
    NSString *skala2 = [NSString stringWithFormat:@"%@", @"Gruen: >="];
    skala2 = [skala2 stringByAppendingString:[NSString stringWithFormat:@"%.1f", normalLowValue]];
    skala2 = [skala2 stringByAppendingString:[NSString stringWithFormat:@"%@", @"% und <="]];
    skala2 = [skala2 stringByAppendingString:[NSString stringWithFormat:@"%.1f", normalHighValue]];
    skala2 = [skala2 stringByAppendingString:[NSString stringWithFormat:@"%@", @"%"]];
    CGContextShowTextAtPoint(context, 170,310, [skala2 cStringUsingEncoding:NSUTF8StringEncoding], [skala2 length]);
    }

    
}
/**
 *  fetch the hba1c data from the sugarmeDB
 */
-(void) performFetches{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"HbA1c" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    self.hba1cValues =[[managedObjectContext executeFetchRequest:fetchRequest error:&error] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    
    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity2 = [NSEntityDescription
                                   entityForName:@"HbA1cEinstellungen" inManagedObjectContext:managedObjectContext];
    [fetchRequest2 setEntity:entity2];
    self.hba1cEinstellungen =[managedObjectContext executeFetchRequest:fetchRequest2 error:&error];

}

@end
