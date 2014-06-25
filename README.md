Facebook-SDK-Wrapper
====================

Facebook SDK Wrapper

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

Coding part:

Add this in Appdelegate.m

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}
