//
//  HighLowCell.h
//  sugarME
//
//  Created by Fresh Prince on 30.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighLowCell : UITableViewCell
    @property (nonatomic, weak) IBOutlet UILabel *highValueLabel;
    @property (nonatomic, weak) IBOutlet UILabel *lowValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *meanLabel;

    @property (nonatomic, weak) IBOutlet UILabel *titleLabel;
    @property (nonatomic, weak) IBOutlet UILabel *highDateLabel;
    @property (nonatomic, weak) IBOutlet UILabel *lowDateLabel;
@end
