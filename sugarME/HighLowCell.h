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
    @property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end
