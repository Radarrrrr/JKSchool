//
//  UserInfo.m
//  JKSchool
//
//  Created by Radar on 2020/2/15.
//  Copyright © 2020年 radar. All rights reserved.
//

#import "UserInfo.h"


@implementation HHUser 

@end


@implementation UserInfo
@synthesize curUser = _curUser;

- (id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

+ (instancetype)sharedInfo
{
    static dispatch_once_t onceToken;
    static UserInfo *uInfo;
    dispatch_once(&onceToken, ^{
        uInfo = [[UserInfo alloc] init];
    });
    return uInfo;
}

- (void)setCurUser:(HHUser *)curUser
{    
    _curUser = curUser;
}
- (HHUser *)curUser
{
    if(!_curUser)
    {
        _curUser = [self loadUser];
    }
    
    return _curUser;
}

- (void)saveUser:(HHUser *)user
{
    NSString *uid = nil;
    NSString *name = nil;
    NSString *type = nil;
    
    if(user && user.uid && ![user.uid isEqualToString:@""])
    {
        uid = user.uid;
        name = user.name;
        type = user.type;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"userinfo_uid"];
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"userinfo_name"];
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:@"userinfo_type"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(!uid)
    {
        self.curUser = nil;
    }
    else
    {
        self.curUser = user;
    }
}
- (HHUser *)loadUser
{
    HHUser *user = [[HHUser alloc] init];
    
    user.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo_uid"];
    user.name = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo_name"];
    user.type = [[NSUserDefaults standardUserDefaults] objectForKey:@"userinfo_type"];
    
    if(!user.uid) return nil;
    
    return user;
}


@end
