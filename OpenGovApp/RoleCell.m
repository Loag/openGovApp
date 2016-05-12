//
//  RoleCell.m
//  OpenGovApp
//
//  Created by Logan  on 4/11/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import "RoleCell.h"

@implementation RoleCell

-(instancetype)initCell
{
    self = [super init];
    if (self) {

        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;

        self.frame = CGRectMake(0, 0, screenWidth, 75);

        [self setupLabel];
    }

    return self;
}

-(void)setupLabel
{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor colorWithRed:0.000 green:0.427 blue:0.941 alpha:1.00];
    _titleLabel.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:_titleLabel];

    _descriptionLabel = [[UILabel alloc]init];
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _descriptionLabel.textAlignment = NSTextAlignmentLeft;
    _descriptionLabel.numberOfLines = 2;
    _descriptionLabel.font = [UIFont systemFontOfSize:14];
    _descriptionLabel.textColor = [UIColor colorWithRed:0.000 green:0.427 blue:0.941 alpha:1.00];
    _descriptionLabel.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:_descriptionLabel];

    _partyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    _partyImageView.center = CGPointMake(self.frame.size.width*.9, self.frame.size.height/2);

    [self.contentView addSubview:_partyImageView];

    [self titleLabelConstraints];
    [self descriptionLabelConstraints];
}

-(void)titleLabelConstraints
{
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];

    // incomming will override these constraints and layout the incomming message, these constraints are for the outgoing message to me constrained
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];


    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
    //
}


-(void)descriptionLabelConstraints
{
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:2]];

    // incomming will override these constraints and layout the incomming message, these constraints are for the outgoing message to me constrained
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];


    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-60]];
    //
}

@end
