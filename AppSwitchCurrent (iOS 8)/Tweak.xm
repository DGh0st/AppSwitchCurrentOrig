@interface SBAppSwitcherPageViewController
-(void)setOffsetToIndex:(NSInteger)arg1 animated:(BOOL)arg2;
@end

@interface SBAppSwitcherIconController
-(void)setOffsetToIndex:(NSInteger)arg1 animated:(BOOL)arg2;
@end

#define dSettingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.dgh0st.appswitchcurrentOrig.plist"]
#define dIsEnabled [[[NSDictionary dictionaryWithContentsOfFile:dSettingsPath] objectForKey:@"isEnabled"] boolValue]
#define dSBLastApp [[[NSDictionary dictionaryWithContentsOfFile:dSettingsPath] objectForKey:@"sbLastApp"] boolValue]

NSMutableDictionary *prefs = nil;

%hook SBAppSwitcherPageViewController
-(void)setOffsetToIndex:(NSInteger)arg1 animated:(BOOL)arg2{
	if(dIsEnabled){
		BOOL changeIndex = YES;
		if(arg1 == 0){
			changeIndex = NO;
		}
		if(arg1 != 0){
			arg1--;
		}
		if(dSBLastApp && arg1 == 0 && changeIndex){
			arg1 = 1;
		}
	}
	%orig(arg1 , arg2);
}
%end

%hook SBAppSwitcherIconController
-(void)setOffsetToIndex:(NSInteger)arg1 animated:(BOOL)arg2{
	if(dIsEnabled){
		BOOL changeIndex = YES;
		if(arg1 == 0){
			changeIndex = NO;
		}
		if(arg1 != 0){
			arg1--;
		}
		if(dSBLastApp && arg1 == 0 && changeIndex){
			arg1 = 1;
		}
	}
	%orig(arg1 , arg2);
}
%end

void loadPreferences() {
	prefs = [NSMutableDictionary dictionaryWithContentsOfFile:dSettingsPath];
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
				    NULL,
				    (CFNotificationCallback)loadPreferences,
				    CFSTR("com.dgh0st.appswitchcurrentOrig/settingschanged"),
				    NULL,
				    CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPreferences();
}
