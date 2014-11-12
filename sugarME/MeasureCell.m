//
//  MeasureCell.m
//  sugarME
//
//  Created by Fresh Prince on 30.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "MeasureCell.h"

@implementation MeasureCell
@synthesize titleLabel = _titleLabel;
@synthesize day1Labels = _day1Labels;
@synthesize day2Labels = _day2Labels;
@synthesize day3Labels = _day3Labels;
@synthesize day4Labels = _day4Labels;
@synthesize day5Labels = _day5Labels;
@synthesize day6Labels = _day6Labels;
@synthesize day7Labels = _day7Labels;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
