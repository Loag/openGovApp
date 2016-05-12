//
//  RoleCell.h
//  OpenGovApp
//
//  Created by Logan  on 4/11/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoleCell : UITableViewCell
@property UILabel *titleLabel;

@property UILabel *partyLabel;

@property UILabel *descriptionLabel;

@property UIImageView *partyImageView;

-(instancetype)initCell;

@end
