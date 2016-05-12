//
//  VoteTableViewCell.h
//  OpenGovApp
//
//  Created by Logan  on 5/3/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteTableViewCell : UITableViewCell

@property UILabel *titleLabel;

@property UILabel *votingStatusLabel;

-(instancetype)initCell;

@end
