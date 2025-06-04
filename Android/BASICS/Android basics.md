
![[Pasted image 20250418125532.png]]


- `onCreate()` →  activity is **first created**. UI is set up here (layouts, buttons, etc).
    
- `onStart()` →  activity is now **visible** to the user, but not yet interactive.
    
- `onResume()` →  activity is now **in the foreground** and ready for **user interaction**.



# Broadcast reciever

`private BroadcastReceiver broadcastReceiver;`

- **Android that listens for system-wide or app-specific events** 

|Event|What it Means|
|---|---|
|`BOOT_COMPLETED`|Device just turned on|
|`SMS_RECEIVED`|New SMS message arrived|
|`BATTERY_LOW`|Battery is getting low|
|`CONNECTIVITY_CHANGE`|Internet connection changed|
|`SCREEN_OFF`|Screen turned off|
|_Custom actions_|Apps can create their own broadcasts too!|

