//
//  PersonObject.h
//  OpenGovApp
//
//  Created by Logan  on 4/27/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonObject : NSObject

// in format Junior Senator From Missouri
@property NSString *personDescription;

// if leadership role
@property NSString *leaderShipTitle;

// party of person
@property NSString *personParty;

// identifier of person by feds
@property NSString *Identifier;

@property NSString *firstName;

@property NSString *lastName;

// position in gov ex Senator
@property NSString *roleType;

// rank ex JUNIOR senator
@property NSString *roleRank;

// shorthand representated state
@property NSString *representingState;



// FOR HOUSE MEMBERS ONLY

// district of representative
@property NSString *district;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

+(void)retrievePerson:(NSString *)identifier WithCompletion:(void (^)(PersonObject *person))complete;


@end
