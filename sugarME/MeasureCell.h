//
//  MeasureCell.h
//  sugarME
//
//  Created by Fresh Prince on 30.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeasureCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *day1Labels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *day2Labels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *day3Labels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *day4Labels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *day5Labels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *day6Labels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *day7Labels;

@end
