//
//  HighLowCell.m
//  sugarME
//
//  Created by Fresh Prince on 30.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "HighLowCell.h"

@implementation HighLowCell
@synthesize highValueLabel = _highValueLabel;
@synthesize lowValueLabel = _lowValueLabel;
@synthesize titleLabel = _titleLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
