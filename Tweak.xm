@interface SBAppSwitcherPageViewController
-(void)setOffsetToIndex:(unsigned long long)arg1 animated:(BOOL)arg2;
@end

@interface SBAppSwitcherIconController
-(void)setOffsetToIndex:(unsigned long long)arg1 animated:(BOOL)arg2;
@end

static BOOL dIsEnabled = YES;
static BOOL dSBLastApp = NO;

%hook SBAppSwitcherPageViewController
-(void)setOffsetToIndex:(unsigned long long)arg1 animated:(BOOL)arg2{
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
-(void)setOffsetToIndex:(unsigned long long)arg1 animated:(BOOL)arg2{
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
	NSMutableDictionary* prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"var/mobile/Library/Preferences/com.dgh0st.appswitchcurrent.plist"];
	if(prefs){
		dIsEnabled = ([prefs objectForKey:@"isEnabled"] ? [[prefs objectForKey:@"isEnabled"] boolValue] : dIsEnabled);
		dSBLastApp = ([prefs objectForKey:@"sbLastApp"] ? [[prefs objectForKey:@"sbLastApp"] boolValue] : dSBLastApp);
	}
	[prefs release];
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
