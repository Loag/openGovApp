//
//  BillObject.h
//  OpenGovApp
//
//  Created by Logan  on 4/10/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillObject : NSObject

// EX Bill
@property NSString *BillResolutionType;

// current status of the bill
@property NSString *currentStatus;

// date of last status change in bill
@property NSString *currentStatusDate;

// description of status update
@property NSString *currentStatusDescription;

// Bill ID
@property NSString *identifier;

// major actions takin with bill in array of strings
@property NSArray *majorActions;

// bill number in current congress
@property NSString *number;

// title of the bill, acts as description
@property NSString *billTitle;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

// retrieve current bills in congress
+(void)retrieveBillsWithCompletion:(void (^)(NSArray *Bills))complete;

+(void)retrieveBillWithIdentifier:(NSString *)identifier withCompletion:(void (^)(BillObject *bill))complete;

@end
