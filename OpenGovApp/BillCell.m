//
//  BillCell.m
//  OpenGovApp
//
//  Created by Logan  on 4/11/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import "BillCell.h"

@implementation BillCell

-(instancetype)initCell
{
    self = [super init];
    if (self) {

        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;

        self.frame = CGRectMake(0, 0, screenWidth, 150);

        [self setupLabel];
    }
    
    return self;
}

-(void)setupLabel
{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor colorWithRed:0.000 green:0.427 blue:0.941 alpha:1.00];
    _titleLabel.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:_titleLabel];

    _dateLabel = [[UILabel alloc]init];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _dateLabel.numberOfLines = 0;
    _dateLabel.font = [UIFont systemFontOfSize:10];
    _dateLabel.textColor = [UIColor colorWithRed:0.000 green:0.427 blue:0.941 alpha:1.00];
    _dateLabel.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:_dateLabel];

    [self representingStateLabelConstraints];
    [self dateLabelConstraints];
}


-(void)representingStateLabelConstraints
{
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];

    // incomming will override these constraints and layout the incomming message, these constraints are for the outgoing message to me constrained
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];


    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
    //
}

-(void)dateLabelConstraints
{
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];

    // incomming will override these constraints and layout the incomming message, these constraints are for the outgoing message to me constrained
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];


    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
    //
}


@end
