//
//  Facebook.h
//  Facebook
//
//  Created by rohit.jindal on 4/23/14.
//  Copyright (c) 2014 Rohitjindal@yahoo.com . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

typedef void (^completion)(id data,NSError *error);
@interface Facebook : NSObject
{
    completion complitionHandler;
}

@property (assign,nonatomic,getter = isLogin) BOOL login;
@property (nonatomic,strong)NSString *accessToken;

+(instancetype) sharedInstance;
/* object permission are required to get data fron fb server use only desire permission get detail on this Link - https://developers.facebook.com/docs/facebook-login/permissions/ */

-(void) setPermissions:(NSArray *)permissions;
//Method to get user info data returns in block as a dictionary
-(void) getUserInfo:(completion)completionBlock;
//Method to post on facebook returns post id.
-(void) postwithName:(NSString *)name caption:(NSString *)caption description:(NSString *)description link:(NSString *)link image:(NSString *)imageurl comptlitionBlock:(completion)blk;
//Method to login with facebook and returns access token
-(void) loginwithComplitionBloack:(completion)blk;

//Delete seesion and cookies
-(void) logOut;



///thanks







@end
