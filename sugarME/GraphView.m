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
- (void)drawLineGraphWithContext:(CGContextRef)ctx
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM"];
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0] CGColor]);
    int maxGraphHeight = kGraphHeight - kOffsetY;
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight * ([[[blutzuckerValues firstObject]valueForKey:@"value"]floatValue]/9.0f));
    int i=0;
    for (NSManagedObject *obj in blutzuckerValues)
    {
        CGContextAddLineToPoint(ctx, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * ([[obj valueForKey:@"value"]floatValue]/9.0f)-9);
        i++;
    }
    
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0] CGColor]);
    i=0;
    for (NSManagedObject *obj in blutzuckerValues)
    {
        float x = kOffsetX + i * kStepX;
        float y = kGraphHeight - maxGraphHeight * ([[obj valueForKey:@"value"]floatValue]/9.0f);
        CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius-9, 2 * kCircleRadius, 2 * kCircleRadius);
        CGContextAddEllipseInRect(ctx, rect);
        i++;
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextSetTextMatrix(ctx, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    
    i=0;
    for (NSManagedObject *obj in blutzuckerValues)
    {
        float x = kOffsetX + i * kStepX;
        float y = kGraphHeight - maxGraphHeight * ([[obj valueForKey:@"value"]floatValue]/9.0f);
        CGContextSelectFont(ctx, "Helvetica", 10, kCGEncodingMacRoman);
        NSString *theText = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[obj valueForKey:@"date"]]];
        CGContextShowTextAtPoint(ctx, kOffsetX -9 + i* kStepX, kGraphBottom+3, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
        CGContextSelectFont(ctx, "Helvetica-Bold", 12, kCGEncodingMacRoman);
        NSString *theText2 = [NSString stringWithFormat:@"%@", [obj valueForKey:@"value"]];
        CGContextShowTextAtPoint(ctx, x - kCircleRadius+10, y - kCircleRadius+1, [theText2 cStringUsingEncoding:NSUTF8StringEncoding], [theText2 length]);
        i++;
    }
    
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.3] CGColor]);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight-10);
    CGContextAddLineToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight * ([[[blutzuckerValues firstObject] valueForKey:@"value"]floatValue]/9.0f));
    i=0;
    for (NSManagedObject *obj in blutzuckerValues)
    {
        CGContextAddLineToPoint(ctx, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * ([[obj valueForKey:@"value"]floatValue]/9.0f)-9);
        i++;
    }
    CGContextAddLineToPoint(ctx, kOffsetX + (blutzuckerValues.count - 1) * kStepX, kGraphHeight-10);
    CGContextClosePath(ctx);
    
    CGContextDrawPath(ctx, kCGPathFill);
    
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
    CGContextSetLineWidth(context,1.2);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - 3.5 * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - 3.5 * kStepY);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - 5.7 * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - 5.7 * kStepY);
    CGContextStrokePath(context);
    CGContextSetLineWidth(context,2.0);
    CGContextSetLineDash(context, 0, NULL, 0);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - 0 * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - 0 * kStepY);
    CGContextMoveToPoint(context, kOffsetX + 0 * kStepX, kGraphTop);
    CGContextAddLineToPoint(context, kOffsetX + 0 * kStepX, kGraphBottom-kOffsetX);

    CGContextStrokePath(context);
    
    [self drawLineGraphWithContext:context];
//    [self drawBarGraphWithContext:context];
//    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
//    CGContextSetTextDrawingMode(context, kCGTextFill);
//    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
//    for (int i = 0; i < [self.blutzuckerValues count]; i++)
//    {
//        CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman);
//        NSString *theText = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[[blutzuckerValues objectAtIndex:i]valueForKey:@"date"]]];
//        CGContextShowTextAtPoint(context, kOffsetX -13 + (i +1)* kStepX, kGraphBottom+3, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
//        CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman);
//
//            NSString *theText2 = [NSString stringWithFormat:@"%@", [[blutzuckerValues objectAtIndex:i]valueForKey:@"value"]];
//            CGContextShowTextAtPoint(context, kOffsetX -8 + (i +1)* kStepX, kGraphBottom-70, [theText2 cStringUsingEncoding:NSUTF8StringEncoding], [theText2 length]);
//
//    }    
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
    NSArray *tempArray;
    tempArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    tempArray=[tempArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    self.blutzuckerValues=[[NSMutableArray alloc] initWithArray:tempArray];
    while (self.blutzuckerValues.count>10) {
        [self.blutzuckerValues removeObjectAtIndex:0];
    }
}


@end
