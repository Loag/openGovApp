//
//  DataManager.m
//  OpenGovApp
//
//  Created by Logan  on 4/9/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

// this object will initialize all data calls 

+ (instancetype)sharedManager
{
    static DataManager *sharedInstance = nil;
    static dispatch_once_t pred;

    dispatch_once(&pred, ^{
        sharedInstance = [[DataManager alloc]init];
    });

    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        _roleArray = [NSArray new];

    }
    return self;
}

-(void)retrieveAllDataWithCompletion:(void (^)(BOOL))complete
{
    dispatch_group_t group = dispatch_group_create();

    // pair a dispatch_group_enter for each dispatch_group_leave
    dispatch_group_enter(group);     // pair 1 enter

    [RoleObject retrieveRoleWithCompletion:^(NSArray *Role) {

        if (Role) {

            [[DataManager sharedManager]setRoleArray:Role];

            dispatch_group_leave(group); // pair 1 leave

        }
    }];

    // again... (and again...)
    dispatch_group_enter(group);     // pair 2 enter

    [BillObject retrieveBillsWithCompletion:^(NSArray *Bills) {

        if (Bills) {

            [[DataManager sharedManager]setBillsArray:Bills];

            dispatch_group_leave(group); // pair 2 leave

        }
    }];

    // Next, setup the code to execute after all the paired enter/leave calls.
    //
    // Option 1: Get a notification on a block that will be scheduled on the specified queue:
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        complete(YES);
    });

    // Option 2: Block an wait for the calls to complete in code already running
    // (as cbartel points out, be careful with running this on the main/UI queue!):
    //
    // dispatch_group_wait(group, DISPATCH_TIME_FOREVER); // blocks current thread
    // NSLog(@"finally!");
}

-(void)retrievePersonAndVoteRecord:(NSString *)identifier personWithCompletion:(void (^)(PersonObject *, NSArray *))complete
{
    dispatch_group_t group = dispatch_group_create();

    // pair a dispatch_group_enter for each dispatch_group_leave

    __block PersonObject *personObject;

    __block NSArray *votingRecordArray;

    dispatch_group_enter(group);     // pair 1 enter

    [PersonObject retrievePerson:identifier WithCompletion:^(PersonObject *person) {

        if (person) {

             personObject = person;

            dispatch_group_leave(group); // pair 1 leave
        }
    }];

    // again... (and again...)
    dispatch_group_enter(group);     // pair 2 enter

    [VotingRecordObject retrieveVotingRecordForIdentifer:identifier WithCompletion:^(NSArray *votingRecord) {

        if (votingRecord) {


            votingRecordArray = votingRecord;
            dispatch_group_leave(group); // pair 1 leave
        }
    }];


    // Next, setup the code to execute after all the paired enter/leave calls.
    //
    // Option 1: Get a notification on a block that will be scheduled on the specified queue:
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        complete(personObject,votingRecordArray);
    });
}

-(void)retrieveBillWithIdentifier:(NSString *)identifier withCompletion:(void (^)(BillObject *))complete
{
    [BillObject retrieveBillWithIdentifier:identifier withCompletion:^(BillObject *bill) {

        if (bill) {
            complete(bill);
        }
    }];
}

@end
