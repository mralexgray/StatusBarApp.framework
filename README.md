StatusBarApp.framework
======================

A rednkulously simple, drop-in framework for adding a "StatusBar" menu to any Cocoa App.  So easy... you'll cry in disbelief.  

Follow the steps below… and then all it "Requires" is...

_Controller.h_

```#import <MenuApp/MenuApp.h>```

```@property (unsafe_unretained) IBOutlet MenuAppController	*menu;```

_Controller.m_

```	[_menu loadStatusMenu];```


So to get up in this, just…

1. Fork project.
2.  Add to your Xcode project as submodule.  

    ```
cd /projects/MyProjectFolder```
    
    ```git submodule add https://github.com/<YOURgithubUSERNAME>/StatusBarApp.framework.git StatusBarApp.framework
```

3. Add Xcode project to your Project.

     ```File -> Add Files to "Your Project -> MenuApp.xcodeproj```

4.  Add ```MenuApp``` framework as a "dependency" to your project.  

    ![](http://f.cl.ly/items/1J1x3l2K0P3i1T3R3R1q/Image%202013.04.16%201%3A18%3A09%20PM.png)

4.  Add a "Copy Files" phase to your "Build Phases" that Copies the Framework into your project's "Frameworks" folder.  This will eventually end up being at ```YourApp.app/Contents/Frameworks/MenuApp.framework```.  

    ![](http://f.cl.ly/items/2Z1y3906072e3j3c2I2O/Image%202013.04.16%201%3A16%3A26%20PM.png)

5. Add the framework to "Link Binary With Libraries" build phase.

    ![](http://f.cl.ly/items/330m24072v3x330j3S07/Image%202013.04.16%201%3A20%3A07%20PM.png)


6. Make sure your App knows to look for it's private frameworks when starting up by adding ```@executable_path/../Frameworks``` to your project's "Runpath Search Paths" under "Build Settings.



