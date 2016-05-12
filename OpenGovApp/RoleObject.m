//
//  RoleObject.m
//  OpenGovApp
//
//  Created by Logan  on 4/9/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import "RoleObject.h"

@implementation RoleObject

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];

    if (self) {

        _personDescription = [dictionary objectForKey:@"description"];

        if (!([dictionary objectForKey:@"leadership_title"] == [NSNull null])) {
            _leaderShipTitle = [dictionary objectForKey:@"leadership_title"];
        }

        _personParty = [dictionary objectForKey:@"party"];

        if ([_personParty isEqualToString:@"Democrat"]) {

            _partyImage = [UIImage imageNamed:@"democrat"];
        }

        else if ([_personParty isEqualToString:@"Republican"])
        {
            _partyImage = [UIImage imageNamed:@"republican"];
        }

        else
        {
            _partyImage = [UIImage imageNamed:@"independent"];
        }

        NSDictionary *personDict = [dictionary objectForKey:@"person"];
        
        _Identifier = [personDict objectForKey:@"id"];

        _firstName = [personDict objectForKey:@"firstname"];

        _lastName = [personDict objectForKey:@"lastname"];

        _fullName = [NSString stringWithFormat:@"%@ %@",_firstName,_lastName];

        _roleType = [dictionary objectForKey:@"role_type_label"];

        _roleRank = [dictionary objectForKey:@"senator_rank_label"];

        _representingState = [dictionary objectForKey:@"state"];

        if (!([dictionary objectForKey:@"district"] == NULL)) {

            _district = [dictionary objectForKey:@"district"];
        }

    }

    return self;
}

+(void)retrieveRoleWithCompletion:(void (^)(NSArray *))complete
{

    NSURL *url = [NSURL URLWithString:@"https://www.govtrack.us/api/v2/role?current=true&limit=600"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      // ...

                                      if (!error) {

                                          NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

                                          NSArray *allRoleArray = [results objectForKey:@"objects"];

                                          NSMutableArray *returnArray = [NSMutableArray new];

                                          for (NSDictionary *roleDict in allRoleArray) {

                                              RoleObject *object = [[RoleObject alloc]initWithDictionary:roleDict];

                                              if (object) {
                                                  
                                                  [returnArray addObject:object];
                                              }

                                          }

                                          complete(returnArray);

                                      }
                                  }];
    
    [task resume];
}


@end
