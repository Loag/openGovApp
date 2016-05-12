//
//  DataManager.h
//  OpenGovApp
//
//  Created by Logan  on 4/9/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoleObject.h"
#import "BillObject.h"
#import "PersonObject.h"
#import "VotingRecordObject.h"
@interface DataManager : NSObject

@property NSArray *roleArray;
@property NSArray *billsArray;

@property PersonObject *personObject;

+ (instancetype)sharedManager;

-(void)retrieveAllDataWithCompletion:(void (^)(BOOL complete))complete;

-(void)retrievePersonAndVoteRecord:(NSString *)identifier personWithCompletion:(void (^)(PersonObject * person, NSArray *voteRecord))complete;
-(void)retrieveBillWithIdentifier:(NSString *)identifier withCompletion:(void (^)(BillObject * bill))complete;
@end
