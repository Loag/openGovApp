//
//  ViewController.m
//  OpenGovApp
//
//  Created by Logan  on 4/9/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//
#import "AppDelegate.h"
#import "ViewController.h"
#import "DataManager.h"
#import "BillCell.h"
#import "BillObject.h"
#import "BillViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITabBarDelegate>

@property UITabBar *homeTabBar;

@property (nonatomic) UITableView *tableView;

@property NSArray *fullBillArray;

@property BillObject *billObject;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIImage *EAV = [UIImage imageNamed:@"topLogo"];
    [self.navigationItem setTitleView:[[UIImageView alloc]initWithImage:EAV]];

    self.navigationItem.hidesBackButton = YES;
    static dispatch_once_t pred;

    dispatch_once(&pred, ^{

        [self tabBar];
    });

    [self setupTableView];
}

-(void)setupTableView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    _tableView = [[UITableView alloc]initWithFrame:screenRect];
    _tableView.rowHeight = 150;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[BillCell class] forCellReuseIdentifier:@"Cell"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorColor = [UIColor whiteColor];
    _tableView.allowsMultipleSelection = NO;
    [self.view addSubview:_tableView];

    [[DataManager sharedManager]retrieveAllDataWithCompletion:^(BOOL complete) {

        if (complete) {

            _fullBillArray = [DataManager sharedManager].billsArray;

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

-(BillCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillCell *cell = [[BillCell alloc]initCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BillObject *object = [self.fullBillArray objectAtIndex:indexPath.row];

    cell.titleLabel.text = object.billTitle;
    cell.dateLabel.text = object.currentStatusDescription;

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fullBillArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillObject *pushObject = [self.fullBillArray objectAtIndex:indexPath.row];

    _billObject = pushObject;

    [self performSegueWithIdentifier:@"ToBillFromVC" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"ToBillFromVC"]) {

        BillViewController *billVC = segue.destinationViewController;

        billVC.bill = _billObject;
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


#pragma mark tab bar
-(void)tabBar
{
    UITabBarItem *item1 = [[UITabBarItem alloc]init];
    UITabBarItem *item2 = [[UITabBarItem alloc]init];
    //UITabBarItem *item3 = [[UITabBarItem alloc]init];


    item2.image = [[UIImage imageNamed:@"contract"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"command"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    item2.title = @"Bills";
    item1.title = @"Congress";

    [item2 setSelectedImage:[[UIImage imageNamed:@"contract (1)"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setSelectedImage:[[UIImage imageNamed:@"command (1)"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                        forState:UIControlStateSelected];

    //77.3, 70.2, 34.5
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.000 green:0.427 blue:0.941 alpha:1.00] } forState:UIControlStateNormal];

    self.homeTabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 75)];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.894 green:0.820 blue:0.463 alpha:1.00]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0.894 green:0.820 blue:0.463 alpha:1.00]];
    self.homeTabBar.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-10);
    self.homeTabBar.delegate = self;

    self.homeTabBar.autoresizesSubviews = NO;
    self.homeTabBar.clipsToBounds = YES;

    item1.tag = 1;
    item2.tag = 2;
    //item3.tag = 3;

    self.homeTabBar.items = @[item2,item1];
    [self.homeTabBar setSelectedItem:item2];

    self.homeTabBar.tag = 30;
    [self.navigationController.view addSubview:self.homeTabBar];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case 1:
            // friends clicked
            [self goToRole];
            break;

        case 2:
            // messages clicked
            [self goToBill];
            break;
            
        default:nil;
            break;
    }
}

-(void)goToRole
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self pushViewController:appDelegate.roleController];
}

-(void)goToBill
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self pushViewController:appDelegate.billController];
}


- (void)pushViewController:(UIViewController *)viewController {
    if (viewController) {
        @try {
            [self.navigationController pushViewController:viewController animated:NO];
        } @catch (NSException * ex) {
            //“Pushing the same view controller instance more than once is not supported”
            //NSInvalidArgumentException
            NSLog(@"Exception: [%@]:%@",[ex  class], ex );
            NSLog(@"ex.name:'%@'", ex.name);
            NSLog(@"ex.reason:'%@'", ex.reason);
            //Full error includes class pointer address so only care if it starts with this error
            NSRange range = [ex.reason rangeOfString:@"Pushing the same view controller instance more than once is not supported"];

            if ([ex.name isEqualToString:@"NSInvalidArgumentException"] &&
                range.location != NSNotFound) {
                //view controller already exists in the stack - just pop back to it
                [self.navigationController popToViewController:viewController animated:NO];
            } else {
                NSLog(@"ERROR:UNHANDLED EXCEPTION TYPE:%@", ex);
            }
        } @finally {
            //NSLog(@"finally");
        }
    } else {
        NSLog(@"ERROR:pushViewController: viewController is nil");
    }
}


@end
