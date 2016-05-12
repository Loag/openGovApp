//
//  VotingRecordObject.h
//  OpenGovApp
//
//  Created by Logan  on 5/2/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VotingRecordObject : NSObject

@property NSString *votingStatus;

@property NSString *votingCatagory;

@property NSString *chamber;

@property NSString *identifier;

@property NSString *floorQuestion;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

+(void)retrieveVotingRecordForIdentifer:(NSString *)identifier WithCompletion:(void (^)(NSArray * votingRecord))complete;


@end
