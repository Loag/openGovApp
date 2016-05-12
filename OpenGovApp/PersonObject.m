//
//  PersonObject.m
//  OpenGovApp
//
//  Created by Logan  on 4/27/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import "PersonObject.h"

@implementation PersonObject


-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];

    if (self) {

        NSArray *roleArray = [dictionary objectForKey:@"roles"];

        NSDictionary *detailDictionary = [roleArray lastObject];


        _personDescription = [detailDictionary objectForKey:@"description"];        

        _personParty = [detailDictionary objectForKey:@"party"];

        _firstName = [dictionary objectForKey:@"firstname"];

        _lastName = [dictionary objectForKey:@"lastname"];

        _roleType = [detailDictionary objectForKey:@"role_type_label"];

        _roleRank = [detailDictionary objectForKey:@"senator_rank_label"];

        _representingState = [detailDictionary objectForKey:@"state"];

        if (!([detailDictionary objectForKey:@"district"] == NULL)) {

            _district = [detailDictionary objectForKey:@"district"];
        }

    }

    return self;
}

+(void)retrievePerson:(NSString *)identifier WithCompletion:(void (^)(PersonObject *))complete
{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.govtrack.us/api/v2/person/%@",identifier]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      // ...

                                      if (!error) {

                                          NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

                                          PersonObject *object = [[PersonObject alloc]initWithDictionary:results];

                                          if (object) {
                                              complete(object);
                                          }
                                          else
                                          {
                                              complete(nil);
                                          }
                                      }
                                  }];
    [task resume];
}


@end
