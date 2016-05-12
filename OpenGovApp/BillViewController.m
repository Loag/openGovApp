//
//  BillViewController.m
//  OpenGovApp
//
//  Created by Logan  on 5/3/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import "BillViewController.h"

@interface BillViewController ()

@property UILabel *headerDescriptionLabel;

@property UILabel *fullNameLabel;

@property UILabel *representingStateLabel;

@end

@implementation BillViewController


-(void)Controller_Common_Init
{
    // do all setup in here

    _headerDescriptionLabel = [UILabel new];
    _headerDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _headerDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    _headerDescriptionLabel.numberOfLines = 0;

    [self.view addSubview:_headerDescriptionLabel];

    _fullNameLabel = [UILabel new];
    _fullNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _fullNameLabel.textAlignment = NSTextAlignmentCenter;
    _fullNameLabel.numberOfLines = 0;
    [self.view addSubview:_fullNameLabel];

    _representingStateLabel = [UILabel new];
    _representingStateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _representingStateLabel.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:_representingStateLabel];

    [self headerDescriptionLabelConstraints];
    [self fullNameLabelConstraints];
    [self representingStateLabelConstraints];
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *EAV = [UIImage imageNamed:@"topLogo"];
    [self.navigationItem setTitleView:[[UIImageView alloc]initWithImage:EAV]];

    [self Controller_Common_Init];

    self.headerDescriptionLabel.text = [NSString stringWithFormat:@"Bill Description: %@",self.bill.currentStatusDescription];
    self.fullNameLabel.text = [NSString stringWithFormat:@"Bill Title: %@",self.bill.billTitle];
    NSString *removedUnderScores = [self.bill.currentStatus stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    self.representingStateLabel.text = [NSString stringWithFormat:@"Current Status: %@",removedUnderScores];
}


#pragma mark - Autolayout

- (void)headerDescriptionLabelConstraints
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_fullNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:70]];

    // incomming will override these constraints and layout the incomming message, these constraints are for the outgoing message to me constrained

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_fullNameLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
    //
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_fullNameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];
}

- (void)fullNameLabelConstraints
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_headerDescriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_fullNameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];

    // incomming will override these constraints and layout the incomming message, these constraints are for the outgoing message to me constrained

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_headerDescriptionLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
    //
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_headerDescriptionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];
}

- (void)representingStateLabelConstraints
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_representingStateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_headerDescriptionLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20]];

    // incomming will override these constraints and layout the incomming message, these constraints are for the outgoing message to me constrained

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_representingStateLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
    //
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_representingStateLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];
}

@end
