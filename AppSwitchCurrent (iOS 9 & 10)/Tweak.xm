@interface SBDeckSwitcherViewController : UIViewController
@property (nonatomic,copy) NSArray * displayItems;
@end

@interface CS3DSwitcherViewController : UIViewController
-(SBDeckSwitcherViewController *)deckSwitcher;
@end

BOOL isEnabled = YES;
BOOL isSBLastAppEnabled = NO;

%hook SBDeckSwitcherViewController
-(NSUInteger)_indexForPresentationOrDismissalIsPresenting:(BOOL)arg1 {
	NSUInteger result = %orig(arg1);
	if (isEnabled && arg1 && result != 0 && !(result == 1 && isSBLastAppEnabled)) {
		result--;
	}
	return result;
}
%end

%hook CS3DSwitcherViewController
-(void)dismissToIndex:(NSInteger)arg1 animated:(BOOL)arg2 {
	if (isEnabled && arg1 != 0 && !(arg1 == 1 && isSBLastAppEnabled)) {
		arg1++; // weird work around for correct dismiss animtation
	}
	%orig(arg1, arg2);
}

-(void)scrollToIndex:(NSInteger)arg1 animated:(BOOL)arg2 {
	if (isEnabled && arg1 != 0 && !(arg1 == 1 && isSBLastAppEnabled)) {
		arg1--;
	}
	%orig(arg1, arg2);
}
%end

void loadPreferences() {
	CFPreferencesAppSynchronize(CFSTR("com.dgh0st.appswitchcurrent10"));

	NSDictionary *prefs = nil;
	if ([NSHomeDirectory() isEqualToString:@"/var/mobile"]) {
		CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.dgh0st.appswitchcurrent10"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
		if (keyList) {
			prefs = (NSDictionary *)CFPreferencesCopyMultiple(keyList, CFSTR("com.dgh0st.appswitchcurrent10"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
			if (!prefs) {
				prefs = [NSDictionary dictionary];
			}
			CFRelease(keyList);
		} else {
			prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.dgh0st.appswitchcurrent10.plist"];
		}
	}

	isEnabled = [prefs objectForKey:@"isEnabled"] ? [[prefs objectForKey:@"isEnabled"] boolValue] : YES;
	isSBLastAppEnabled = [prefs objectForKey:@"isSBLastAppEnabled"] ? [[prefs objectForKey:@"isSBLastAppEnabled"] boolValue] : NO;
}

%dtor {
	CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, CFSTR("com.dgh0st.appswitchcurrent10/settingschanged"), NULL);
}

%ctor {
	loadPreferences();

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPreferences, CFSTR("com.dgh0st.appswitchcurrent10/settingschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}