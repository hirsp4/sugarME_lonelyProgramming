//
//  GraphView.h
//  sugarME
//
//  Created by Fresh Prince on 05.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kGraphHeight 280
#define kDefaultGraphWidth 300
#define kOffsetX 10
#define kStepX 30
#define kGraphBottom 280
#define kGraphTop 0
#define kStepY 30
#define kOffsetY 10

#define kBarTop 10
#define kBarWidth 20
#define kCircleRadius 3

@interface GraphView : UIView
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSMutableArray *blutzuckerValues;
@end
