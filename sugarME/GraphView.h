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
#define kStepY 15
#define kOffsetY 10

#define kBarTop 10
#define kBarWidth 20
#define kCircleRadius 1.3
#define dangerousHighValue 15
#define dangerousLowValue 2
#define normalHighValue 5.7
#define normalLowValue 3.5

@interface GraphView : UIView
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSMutableArray *blutzuckerValues;
@end
