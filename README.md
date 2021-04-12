# Minor Project

COVID-19 Testing and Application Platform.

## Tools and Technologies used

1. Android Studio (version 4.1.3) - An integrated development environment for developing Android applications.
2. Flutter (version 2.0.3) - Framework used to develop applications for Android, iOS, Linux, Mac, Windows, Google Fuchsia, and the web from a single codebase.
3. Dart (version 2.0.12) - Dart is a programming language designed for client development, such as for the web and mobile apps. It is developed by Google and can also used to build server and desktop applications.
4. Firebase - Firebase is a platform developed by Google for creating mobile and web applications.Cloud Firestore database provided by Firebase used.
5. Project dependencies - firebase_core: ^0.7.0, cloud_firestore: ^0.16.0, firebase_auth: ^0.20.0, geolocator: ^6.1.13, http: ^0.12.2, flutter_local_notifications: ^4.0.1+1, webview_flutter: ^2.0.2
6. GeoIQ COVID-19 API

## Steps to run the project

1. Android Studio, Flutter and Java must be installed on the computer.
- [How to Install Android Studio](https://developer.android.com/studio/install)
- [How to Install Flutter](https://flutter.dev/docs/get-started/install)
- [How to Install Java](https://java.com/en/download/help/windows_manual_download.html)

2. After successfully installing Android studio, Flutter and Java, downloaded the project as a zip file from [this link](https://github.com/Bhushan-Koyande/Minor-Project).
   Extract the contents of zip file at a desired location in your computer.

3. Next we will set up the IDE. Open plugin preferences (File > Settings > Plugins) in Android Studio.Select Marketplace, select the Flutter plugin and click Install.  
   
4. Click on Open...(File > Open...).Browse and select the project folder and click OK.Android Studio will open the project.

5. Now we will set up an android device for running the app.Connect your device to your development machine with a USB cable. If you developed on Windows, you might need to install the appropriate USB driver for your device.
   Perform the following steps to enable USB debugging in the Developer options window:
   - Open the Settings app.
   - If your device uses Android v8.0 or higher, select System. Otherwise, proceed to the next step.
   - Scroll to the bottom and select About phone.
   - Scroll to the bottom and tap Build number seven times.
   - Return to the previous screen, scroll to the bottom, and tap Developer options.
   - In the Developer options window, scroll down to find and enable USB debugging.
 
6. Run the app on your device as follows:
   - In Android Studio, select your app from the run/debug configurations drop-down menu in the toolbar.
   - In the toolbar, select the device that you want to run your app on from the target device drop-down menu.

7. Click Run.Android Studio installs your app on your connected device and starts it. 
   


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
