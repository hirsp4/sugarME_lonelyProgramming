//
//  ValueCell.m
//  sugarME
//
//  Created by Fresh Prince on 31.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "ValueCell.h"

@implementation ValueCell
@synthesize timeLabel = _timeLabel;
@synthesize typeLabel = _typeLabel;
@synthesize valueLabel = _valueLabel;
@synthesize unitLabel = _unitLabel;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
