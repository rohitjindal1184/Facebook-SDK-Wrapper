//
//  Facebook.m
//  Facebook
//
//  Created by rohit.jindal on 4/23/14.
//  Copyright (c) 2014 Rohitjindal@yahoo.com . All rights reserved.
//

#import "Facebook.h"



@interface Facebook()
@property (nonatomic, readwrite, strong) NSArray *arrPermissions;
@property (nonatomic, copy)   completion completionBlock;
@property (nonatomic, strong) FBSession *session;
@end

@implementation Facebook

+(instancetype) sharedInstance
{
    static Facebook *initObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        initObj = [[Facebook alloc] init];
    });
    
    return initObj;
}
-(BOOL)isLogin
{
    return _login;
}
-(void) setPermissions:(NSArray *)permissions
{
    _arrPermissions = permissions;
    
    if (permissions) {

        _session = [[FBSession alloc]initWithAppID:nil permissions:permissions defaultAudience:FBSessionDefaultAudienceFriends urlSchemeSuffix:nil tokenCacheStrategy:nil];
        
        [FBSession setActiveSession:_session];
    }
}

-(void) openSessionWithCompletion:(completion)blk
{
    if(self.session == nil)
        self.arrPermissions = _arrPermissions;
    NSLog(@"%u",[FBSession activeSession].state);
    if([FBSession activeSession].state <= 0)
    {
    [[FBSession activeSession]openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        if (error) {
                NSDictionary *dic = error.userInfo;
                if([dic objectForKey:@"com.facebook.sdk:ErrorLoginFailedReason"])
                {
                    if([[dic objectForKey:@"com.facebook.sdk:ErrorLoginFailedReason"] isEqualToString:@"com.facebook.sdk:SystemLoginDisallowedWithoutError"])
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"User Disallowed." message:@"Please allow App to connect with facebook in settings." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [alert show];
                        alert = nil;
                    }
                }
                return ;
            
            blk(nil,error);
            return;
        }
        
        switch (status) {// this case will run if the session is opened successfully.
            case FBSessionStateClosed:
            case FBSessionStateOpen:
            {
                _login = YES;
                self.accessToken = [[[FBSession activeSession]accessTokenData] accessToken];
                blk([NSNumber numberWithInt:status],nil);
                return;
            }
                break;
            case FBSessionStateClosedLoginFailed:
                [[FBSession activeSession] closeAndClearTokenInformation];
                return;
                break;
            default:
                return;
                break;
        }
        return;
    }];
    }
    else
    {
        if(![[FBSession activeSession]isOpen])
        {
        [[FBSession activeSession]closeAndClearTokenInformation];
        FBSession.activeSession=nil;
        [[FBSession activeSession]openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            if (error) {
                self.completionBlock(nil,error);
                return;
            }
            
            
                switch (status) {
                    case FBSessionStateOpen:
                    {
                        _login = YES;
                        self.accessToken = [[[FBSession activeSession]accessTokenData] accessToken];
                        blk([[[FBSession activeSession]accessTokenData] accessToken],nil);
                        return;
                    }
                        break;
                    default:
                        return;
                        break;
                }
            
        }];
        }
        
    }
   
    
}
-(void) loginwithComplitionBloack:(completion)blk
{
    self.completionBlock = blk;
    [self openSessionWithCompletion:^(id data, NSError *error) {
        self.completionBlock([[self.session accessTokenData]accessToken],error);
    }];
}

-(void) getUserInfo:(completion)blk
{
    self.completionBlock = blk;
    
    if ([[FBSession activeSession] isOpen]) {
        [[FBRequest requestForMe]startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            self.completionBlock(result,error);
        }];
    }
    else {
        [self openSessionWithCompletion:^(id data, NSError *error) {
           
            if (error) {
                self.completionBlock(nil,error);
                return;
            }
            
            if ([data isKindOfClass:[NSNumber class]]) {
                NSNumber *numStatus = (NSNumber *)data;
                NSInteger status = [numStatus integerValue];
                
                switch (status) {
                    case FBSessionStateOpen:
                    {
                        [[FBRequest requestForMe]startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                            self.completionBlock(result,error);
                        }];
                    }
                        break;
                    default:
                        break;
                }
            }
        }];
    }
}
-(void) postwithName:(NSString *)name caption:(NSString *)caption description:(NSString *)description link:(NSString *)link image:(NSString *)imageurl comptlitionBlock:(completion)blk
{
    if([[FBSession activeSession ]isOpen])
    {
        _login = YES;
        self.accessToken = [[[FBSession activeSession]accessTokenData] accessToken];
        [self postOnFacebookwithName:name caption:caption description:description link:link image:imageurl comptlitionBlock:^(id data, NSError *error) {
            self.completionBlock(data,error);
        }];
    }
    self.completionBlock = blk;
    [self openSessionWithCompletion:^(id data, NSError *error) {
        if(!error)
        {
            if([[FBSession activeSession]isOpen])
            {
            _login = YES;
            self.accessToken = [[[FBSession activeSession]accessTokenData] accessToken];
            [self postOnFacebookwithName:name caption:caption description:description link:link image:imageurl comptlitionBlock:^(id data, NSError *error) {
                self.completionBlock(data,error);
            }];
            }

        }
    }];
}

-(void)postOnFacebookwithName:(NSString *)name caption:(NSString *)caption description:(NSString *)description link:(NSString *)link image:(NSString *)imageurl comptlitionBlock:(completion)blk
{
        NSMutableDictionary *params = [[NSMutableDictionary alloc ]init ];
    if(name != nil)
        [params setObject:name forKey:@"name"];
    if(caption != nil)
        [params setObject:caption forKey:@"caption"];
    if(description != nil)
        [params setObject:description forKey:@"description"];
    if(link != nil)
        [params setObject:link forKey:@"link"];
    if(imageurl != nil)
        [params setObject:imageurl forKey:@"picture"];

    // Show the feed dialog

    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  if (error) {
                                                      blk(nil,error);
                                                  }else {
                                                      if (result == FBWebDialogResultDialogNotCompleted) {
                                                          NSError *error = [[NSError alloc]initWithDomain:@"UserCancelled" code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Opreation canceled by user",@"error",nil]];
                                                          blk(nil,error);
                                                      } else {
                                                          // Handle the publish feed callback
                                                          NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                          blk(urlParams,nil);
                                                            }
                                                  }
                                              }];
}
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}



-(void)dealloc
{
    [self logOut];
}


//Delete Session
-(void) logOut
{
    self.completionBlock = nil;
    _login = NO;
    [self.session closeAndClearTokenInformation];
    self.session = nil;
}

@end
