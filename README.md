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


Coding prerequesties

1: In info.plist

Add FacebookAppID  field and put the Facebook app id regarding this field.
Add url scheme with url  "fbyourfacebookappID".
<img src="https://www.dropbox.com/s/rc36ae5psvi1fbo/Screen%20Shot%202014-06-25%20at%207.12.56%20AM.png" alt="Smiley face" height="42" width="42">
</br>
Coding part:

Add this in Appdelegate.m

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}


//Methods

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
