//
//  Commit.m
//  gitHubClient
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "Commit.h"

@implementation Commit

- (NSString *)commitDate
{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    NSDate *date = [dateFormatter dateFromString:_commitDate];
    
    NSDateFormatter *newFormatter = [NSDateFormatter new];
    [newFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [newFormatter setDateFormat:@"HH:mm:ss dd.MM.yyyy"];
    
    return [newFormatter stringFromDate:date];
}
@end
