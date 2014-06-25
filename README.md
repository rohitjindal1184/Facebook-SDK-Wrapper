Facebook-SDK-Wrapper
====================

Facebook SDK Wrapper

You only need to call the method of the class no need to manage the FBSession object because for Naive developer it will cause crashes in app. Just create a shared intanse of this class a use it with mehods. <b>This is Singleton class </b>

Prerequesties :

farmeworks

1. Facebook Latest SDK 
2. Accounts.framework
3. AdSupport.framework
4. Security.framework
5. libsqlite3.dylib


#Coding prerequesties

# In info.plist

1. Add FacebookAppID  field and put the Facebook app id regarding this field.

2. Add url scheme with url  "fbyourfacebookappID".

![ScreenShot](https://cloud.githubusercontent.com/assets/4582872/3380730/f25fdba6-fc0d-11e3-8821-b0b1725bd4ab.png)
  

#Add this in Appdelegate.m

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}


#Methods

To sahred instance 
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
