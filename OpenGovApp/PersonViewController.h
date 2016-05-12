//
//  PersonViewController.h
//  OpenGovApp
//
//  Created by Logan  on 4/27/16.
//  Copyright © 2016 Comet Cred. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonObject.h"
#import "VotingRecordObject.h"
@interface PersonViewController : UIViewController

@property PersonObject *personObject;

@property NSArray *voteRecordArray;

@end
