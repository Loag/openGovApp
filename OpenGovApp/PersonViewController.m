//
//  PersonViewController.m
//  OpenGovApp
//
//  Created by Logan  on 4/27/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import "PersonViewController.h"
#import "VoteTableViewCell.h"
#import "DataManager.h"
#import "BillObject.h"
#import "BillViewController.h"
@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource>

@property UILabel *headerDescriptionLabel;

@property UILabel *fullNameLabel;

@property UILabel *representingStateLabel;

@property UILabel *votePercentageabel;

@property UILabel *partyLabel;

@property UITableView *tableView;

@property BillObject *billObject;

@end


@implementation PersonViewController

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

    [self.view addSubview:_fullNameLabel];

    _representingStateLabel = [UILabel new];
    _representingStateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _representingStateLabel.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:_representingStateLabel];

    _votePercentageabel = [UILabel new];
    _votePercentageabel.translatesAutoresizingMaskIntoConstraints = NO;
    _votePercentageabel.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:_votePercentageabel];

    _partyLabel = [UILabel new];
    _partyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _partyLabel.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:_partyLabel];

    [self setupTableView];

    [self headerDescriptionLabelConstraints];
    [self fullNameLabelConstraints];
    [self representingStateLabelConstraints];
    [self partyLabelConstraints];
    [self votePercentageLabelConstraints];
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *EAV = [UIImage imageNamed:@"topLogo"];
    [self.navigationItem setTitleView:[[UIImageView alloc]initWithImage:EAV]];

    [self Controller_Common_Init];

    self.headerDescriptionLabel.text = self.personObject.personDescription;
    self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@",self.personObject.firstName,self.personObject.lastName];
    self.partyLabel.text = self.personObject.personParty;
    self.votePercentageabel.text = [self votingRecordPercentages:_voteRecordArray];
    self.representingStateLabel.text = self.personObject.representingState;
}

-(void)setupTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 170, self.view.frame.size.width, self.view.frame.size.height-215)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 120;
    [self.tableView registerClass:[VoteTableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.allowsMultipleSelection = NO;
    self.tableView.separatorColor = [UIColor colorWithRed:0.000 green:0.620 blue:0.804 alpha:1.00];
    [self.view addSubview:self.tableView];

    //[self tableViewOfVotesConstraints];
}

-(NSString *)votingRecordPercentages:(NSArray *)voteRecordArray
{
    NSMutableArray *countNilVotesArray = [NSMutableArray new];

    for (VotingRecordObject *object in voteRecordArray) {

        if ([object.votingStatus isEqualToString:@"Not Voting"]) {

            [countNilVotesArray addObject:object];
        }
    }

    return [NSString stringWithFormat:@"Missed votes %lu%%",(unsigned long)countNilVotesArray.count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.voteRecordArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoteTableViewCell *cell = [[VoteTableViewCell alloc]initCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    VotingRecordObject *recordObject = [self.voteRecordArray objectAtIndex:indexPath.row];

    cell.titleLabel.text = recordObject.floorQuestion;
    cell.votingStatusLabel.text = [NSString stringWithFormat:@"Vote Status: %@",recordObject.votingStatus];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // find the bill that was clicked
    VotingRecordObject *object = [self.voteRecordArray objectAtIndex:indexPath.row];
    [[DataManager sharedManager]retrieveBillWithIdentifier:object.identifier withCompletion:^(BillObject *bill) {

        if (bill) {

            // set push bill here
            _billObject = bill;

            dispatch_async(dispatch_get_main_queue(), ^{
                // code here
                [self performSegueWithIdentifier:@"ToBill" sender:self];
            });
        }
    }];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];

    }

    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }

    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BillViewController *billVC = segue.destinationViewController;

    billVC.bill = _billObject;
}

#pragma mark - Autolayout

- (void)headerDescriptionLabelConstraints
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_fullNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:65]];

    // incomming will override these constraints and layout the incomming message, these constraints are for the outgoing message to me constrained

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_fullNameLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    //
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_fullNameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
}

- (void)fullNameLabelConstraints
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_headerDescriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_fullNameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1]];

    // incomming will override these constraints and layout the incomming message, these constraints are for the outgoing message to me constrained

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_headerDescriptionLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    //
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_headerDescriptionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
}

- (void)partyLabelConstraints
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_partyLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_headerDescriptionLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1]];

    // incomming will override these constraints and layout the incomming message, these constraints are for the outgoing message to me constrained

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_partyLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    //
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_partyLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
}

-(void)votePercentageLabelConstraints
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_votePercentageabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_partyLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1]];

    // incomming will override these constraints and layout the incomming message, these constraints are for the outgoing message to me constrained
    //
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_votePercentageabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width/2]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_votePercentageabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
}

-(void)representingStateLabelConstraints
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_representingStateLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_partyLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:1]];

    // incomming will override these constraints and layout the incomming message, these constraints are for the outgoing message to me constrained
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_representingStateLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.view.frame.size.width/2]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_representingStateLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    //
}

@end
