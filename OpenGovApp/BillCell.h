//
//  BillCell.h
//  OpenGovApp
//
//  Created by Logan  on 4/11/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillCell : UITableViewCell

@property UILabel *titleLabel;

@property UILabel *dateLabel;

-(instancetype)initCell;

@end
