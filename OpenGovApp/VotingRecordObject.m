//
//  VotingRecordObject.m
//  OpenGovApp
//
//  Created by Logan  on 5/2/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import "VotingRecordObject.h"

@implementation VotingRecordObject

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];

    if (self) {

        NSDictionary *optionDict = [dictionary objectForKey:@"option"];

        _votingStatus = [optionDict objectForKey:@"value"];

        NSDictionary *votingDict = [dictionary objectForKey:@"vote"];
        
        _votingCatagory = [votingDict objectForKey:@"category_label"];

        _chamber = [votingDict objectForKey:@"chamber_label"];

        _identifier = [votingDict objectForKey:@"related_bill"];

        _floorQuestion = [votingDict objectForKey:@"question"];

    }

    return self;
}

+(void)retrieveVotingRecordForIdentifer:(NSString *)identifier WithCompletion:(void (^)(NSArray * votingRecord))complete;
{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.govtrack.us/api/v2/vote_voter/?person=%@&limit=100&order_by=-created&format=json&fields=vote__id,created,option__value,vote__category,vote__chamber,vote__question,vote__number,vote__related_bill",identifier]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      // ...

                                      if (!error) {

                                          NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

                                          NSArray *allVotesArray = [results objectForKey:@"objects"];

                                          NSMutableArray *returnArray = [NSMutableArray new];

                                          for (NSDictionary *dict in allVotesArray) {

                                              VotingRecordObject *voteObject = [[VotingRecordObject alloc]initWithDictionary:dict];

                                              [returnArray addObject:voteObject];
                                          }

                                          complete(returnArray);
                                      }
                                  }];
    [task resume];
}


@end
