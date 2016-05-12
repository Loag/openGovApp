//
//  BillObject.m
//  OpenGovApp
//
//  Created by Logan  on 4/10/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import "BillObject.h"

@implementation BillObject

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];

    if (self) {

        _BillResolutionType = [dictionary objectForKey:@"bill_resolution_type"];
        _currentStatus = [dictionary objectForKey:@"current_status"];

//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.dateStyle = NSDateFormatterShortStyle;
//        dateFormatter.timeStyle = NSDateFormatterNoStyle;
//
//        NSDate *date = [dateFormatter dateFromString:[dictionary objectForKey:@"current_status_date"]];
//
//        NSLog(@"%@",date);
//         _currentStatusDate = [dictionary objectForKey:@"current_status_date"];

        _currentStatusDescription = [dictionary objectForKey:@"current_status_description"];
        _identifier = [dictionary objectForKey:@"id"];
        _majorActions = [dictionary objectForKey:@"major_actions"];
        _number = [dictionary objectForKey:@"number"];
        _billTitle = [dictionary objectForKey:@"title"];
    }

    return self;
}

+(void)retrieveBillsWithCompletion:(void (^)(NSArray *))complete
{
    NSURL *url = [NSURL URLWithString:@"https://www.govtrack.us/api/v2/bill?congress=114&order_by=-current_status_date&limit=200"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {

                                      if (!error) {

                                          NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

                                          NSArray *allRoleArray = [results objectForKey:@"objects"];

                                          NSMutableArray *returnArray = [NSMutableArray new];

                                          for (NSDictionary *roleDict in allRoleArray) {

                                              BillObject *object = [[BillObject alloc]initWithDictionary:roleDict];

                                              if (object) {

                                                  [returnArray addObject:object];
                                              }
                                          }
                                          complete(returnArray);
                                      }
                                  }];
    
    [task resume];
}

+(void)retrieveBillWithIdentifier:(NSString *)identifier withCompletion:(void (^)(BillObject *))complete
{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.govtrack.us/api/v2/bill/%@",identifier]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {

                                      if (!error) {

                                          NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];


                                          BillObject *returnObject = [[BillObject alloc]initWithDictionary:results];

                                          if (results) {

                                              complete(returnObject);

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
