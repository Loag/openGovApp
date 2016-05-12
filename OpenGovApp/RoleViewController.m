//
//  RoleViewController.m
//  OpenGovApp
//
//  Created by Logan  on 4/11/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import "AppDelegate.h"
#import "RoleViewController.h"
#import "DataManager.h"
#import "RoleCell.h"
#import "RoleObject.h"
#import "PersonViewController.h"
#import "PersonObject.h"
@interface RoleViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic) UITableView *tableView;

@property NSArray *fullRoleArray;

@property PersonObject *personObject;

@property NSArray *votingRecordArray;

@property NSMutableArray *senatorsArray;
@property NSMutableArray *representativesArray;

@property NSMutableArray *displayArray;

@property UISearchBar *searchBar;
@property BOOL searchResultsBool;
@property NSMutableArray *resultsArray;

@end

@implementation RoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIImage *EAV = [UIImage imageNamed:@"topLogo"];
    [self.navigationItem setTitleView:[[UIImageView alloc]initWithImage:EAV]];

    self.navigationItem.hidesBackButton = YES;

    static dispatch_once_t pred;

    dispatch_once(&pred, ^{
        [self setupTableView];

    });
}

-(void)setupTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)];
    _tableView.rowHeight = 75;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[RoleCell class] forCellReuseIdentifier:@"Cell"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorColor = [UIColor whiteColor];
    _tableView.allowsMultipleSelection = NO;
    [self.view addSubview:_tableView];

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];

    self.searchBar.accessibilityLabel = @"Search Bar";
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    self.navigationItem.titleView = self.searchBar;

    UIView * viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [viewHeader setBackgroundColor:[UIColor clearColor]];

    UISegmentedControl *segmentedController = [[UISegmentedControl alloc]initWithItems:@[@"Senators",@"Representatives"]];
    segmentedController.frame = CGRectMake(10, 5, self.view.frame.size.width-20, 30);
    [segmentedController setSelectedSegmentIndex:0];
    [segmentedController addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];

    [viewHeader addSubview:segmentedController];

    _tableView.tableHeaderView = viewHeader;

    [[DataManager sharedManager]retrieveAllDataWithCompletion:^(BOOL complete) {

        if (complete) {

            _fullRoleArray = [DataManager sharedManager].roleArray;

            [self splitRoleArrayIntoSenatorsAndReps:_fullRoleArray];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

#pragma mark search bar

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    self.searchResultsBool = NO;
    [self.tableView reloadData];
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    return true;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

    if([searchText  isEqual: @""])
    {
        self.searchResultsBool = FALSE;
    }

    else if (!([searchText isEqual:@""]))
    {
        self.resultsArray = [NSMutableArray new];
        self.searchResultsBool = true;



        for (RoleObject *object in self.displayArray)
        {
            NSRange stopNameRange = [object.fullName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (stopNameRange.location != NSNotFound)
            {
                [self.resultsArray addObject:object];
            }
        }
    }

    [self.tableView reloadData];
}



- (void)MySegmentControlAction:(UISegmentedControl *)segment
{
    _displayArray = [NSMutableArray new];

    if(segment.selectedSegmentIndex == 0)
    {
        _displayArray = _senatorsArray;
    }

    else
    {
        _displayArray = _representativesArray;
    }

    [self.tableView reloadData];
}

-(void)splitRoleArrayIntoSenatorsAndReps:(NSArray *)roleArray
{

    _senatorsArray = [NSMutableArray new];
    _representativesArray = [NSMutableArray new];

    for (RoleObject *roleObject in roleArray) {

        if ([roleObject.roleType isEqualToString:@"Senator"]) {

            // add object to senator array
            [_senatorsArray addObject:roleObject];
        }
        else if ([roleObject.roleType isEqualToString:@"Representative"])
        {
            // add object to representative array
            [_representativesArray addObject:roleObject];
        }
    }

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
    _senatorsArray = [[_senatorsArray sortedArrayUsingDescriptors:@[sort]] mutableCopy];

    _representativesArray = [[_representativesArray sortedArrayUsingDescriptors:@[sort]] mutableCopy];

    _displayArray = _senatorsArray;
}

-(RoleCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoleCell *cell = [[RoleCell alloc]initCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (_searchResultsBool) {

        RoleObject *object = [self.resultsArray objectAtIndex:indexPath.row];

        if ([object.personParty isEqualToString:@"Republican"]) {

            cell.titleLabel.textColor = [UIColor redColor];
            cell.descriptionLabel.textColor = [UIColor redColor];
        }

        else if ((![object.personParty isEqualToString:@"Republican"]) && (![object.personParty isEqualToString:@"Democrat"]))
        {
            cell.titleLabel.textColor = [UIColor lightGrayColor];
            cell.descriptionLabel.textColor = [UIColor lightGrayColor];
        }

        cell.partyImageView.image = object.partyImage;
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@",object.firstName,object.lastName];
        cell.descriptionLabel.text = object.personDescription;
        
        return cell;
    }

    else
    {
        RoleObject *object = [self.displayArray objectAtIndex:indexPath.row];

        if ([object.personParty isEqualToString:@"Republican"]) {

            cell.titleLabel.textColor = [UIColor redColor];
            cell.descriptionLabel.textColor = [UIColor redColor];
        }

        else if ((![object.personParty isEqualToString:@"Republican"]) && (![object.personParty isEqualToString:@"Democrat"]))
        {
            cell.titleLabel.textColor = [UIColor lightGrayColor];
            cell.descriptionLabel.textColor = [UIColor lightGrayColor];
        }

        cell.partyImageView.image = object.partyImage;
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@",object.firstName,object.lastName];
        cell.descriptionLabel.text = object.personDescription;
        
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchResultsBool) {

        return _resultsArray.count;
    }
    else
    {
        return _displayArray.count;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchResultsBool) {
        RoleObject *selectedPerson = [self.resultsArray objectAtIndex:indexPath.row];

        [[DataManager sharedManager]retrievePersonAndVoteRecord:selectedPerson.Identifier personWithCompletion:^(PersonObject *person, NSArray *voteRecord) {

            if (person && voteRecord) {

                _personObject = person;
                _votingRecordArray = voteRecord;

                dispatch_async(dispatch_get_main_queue(), ^{
                    // code here
                    [self performSegueWithIdentifier:@"ToPerson" sender:self];
                });
                // go to the new view controller showing this shit
                
            }
            
        }];
    }
    else
    {
        RoleObject *selectedPerson = [self.displayArray objectAtIndex:indexPath.row];

        [[DataManager sharedManager]retrievePersonAndVoteRecord:selectedPerson.Identifier personWithCompletion:^(PersonObject *person, NSArray *voteRecord) {

            if (person && voteRecord) {

                _personObject = person;
                _votingRecordArray = voteRecord;

                dispatch_async(dispatch_get_main_queue(), ^{
                    // code here
                    [self performSegueWithIdentifier:@"ToPerson" sender:self];
                });
                // go to the new view controller showing this shit
                
            }
            
        }];
    }
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
    PersonViewController *personVC = segue.destinationViewController;
    personVC.personObject = _personObject;
    personVC.voteRecordArray = _votingRecordArray;
}

@end
