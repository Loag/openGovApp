//
//  VoteTableViewCell.m
//  OpenGovApp
//
//  Created by Logan  on 5/3/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import "VoteTableViewCell.h"

@implementation VoteTableViewCell

-(instancetype)initCell
{
    self = [super init];
    if (self) {

        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;

        self.frame = CGRectMake(0, 0, screenWidth, 120);

        [self setupLabel];
    }

    return self;
}

-(void)setupLabel
{
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 0;
    
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor blueColor];
    _titleLabel.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:_titleLabel];

    _votingStatusLabel = [[UILabel alloc]init];
    _votingStatusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _votingStatusLabel.textAlignment = NSTextAlignmentLeft;
    _votingStatusLabel.font = [UIFont systemFontOfSize:12];
    _votingStatusLabel.textColor = [UIColor blueColor];
    _votingStatusLabel.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:_votingStatusLabel];

    [self representingStateLabelConstraints];
    [self rvotingStatusContsraints];
}

-(void)representingStateLabelConstraints
{
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];

    // incomming will override these constraints and layout the incomming message, these constraints are for the outgoing message to me constrained
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];


    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
    //
}

-(void)rvotingStatusContsraints
{
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_votingStatusLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];

    // incomming will override these constraints and layout the incomming message, these constraints are for the outgoing message to me constrained
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_votingStatusLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];


    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_votingStatusLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
    //
}


@end
