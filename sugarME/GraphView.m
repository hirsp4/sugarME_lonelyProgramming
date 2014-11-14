//
//  GraphView.m
//  sugarME
//
//  Created by Fresh Prince on 05.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "GraphView.h"
#import "Blutzucker.h"
#import "AppDelegate.h"

@implementation GraphView
@synthesize blutzuckerValues, managedObjectContext;

- (void)drawBarGraphWithContext:(CGContextRef)ctx
{
    float maxBarHeight = kGraphHeight - kBarTop - kOffsetY;
    int i=0;
    for (NSManagedObject *obj in blutzuckerValues)
    {
        float barX = kOffsetX + kStepX + i* kStepX - kBarWidth / 2;
        float barY = kBarTop + maxBarHeight - maxBarHeight * ([[obj valueForKey:@"value"]floatValue]/9.0f);
        float barHeight = maxBarHeight * ([[obj valueForKey:@"value"]floatValue]/9.0f);
        
        CGRect barRect = CGRectMake(barX, barY-5, kBarWidth, barHeight+5);
        if(([[obj valueForKey:@"value"]floatValue]/1.0f)<3.5 || ([[obj valueForKey:@"value"]floatValue]/1.0f)> 5.7){
            CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
        }else CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
        [self drawBar:barRect context:ctx];
        i++;
    }
    
}
- (void)drawRect:(CGRect)rect
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    [self performFetches];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM"];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    int howManyHorizontal = (kGraphBottom - kGraphTop - kOffsetY) / kStepY;
    for (int i = 0; i <= howManyHorizontal; i++)
    {
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - i * kStepY);
        CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - i * kStepY);
    }
    CGContextStrokePath(context);
    CGContextSetLineDash(context, 0, NULL, 0);
    CGContextSetLineWidth(context,1.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - 3.5 * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - 3.5 * kStepY);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - 5.7 * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - 5.7 * kStepY);
    CGContextStrokePath(context);
    CGContextSetLineWidth(context,2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - 0 * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - 0 * kStepY);
    CGContextMoveToPoint(context, kOffsetX + 0 * kStepX, kGraphTop);
    CGContextAddLineToPoint(context, kOffsetX + 0 * kStepX, kGraphBottom-kOffsetX);

    CGContextStrokePath(context);
    
    [self drawBarGraphWithContext:context];
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    for (int i = 0; i < [self.blutzuckerValues count]; i++)
    {
        CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman);
        NSString *theText = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[[blutzuckerValues objectAtIndex:i]valueForKey:@"date"]]];
        CGContextShowTextAtPoint(context, kOffsetX -13 + (i +1)* kStepX, kGraphBottom+3, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
        CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman);

            NSString *theText2 = [NSString stringWithFormat:@"%@", [[blutzuckerValues objectAtIndex:i]valueForKey:@"value"]];
            CGContextShowTextAtPoint(context, kOffsetX -8 + (i +1)* kStepX, kGraphBottom-70, [theText2 cStringUsingEncoding:NSUTF8StringEncoding], [theText2 length]);

    }    
}

- (void)drawBar:(CGRect)rect context:(CGContextRef)ctx
{
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

-(void) performFetches{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Blutzucker" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.blutzuckerValues = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    self.blutzuckerValues=[self.blutzuckerValues sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
}


@end
