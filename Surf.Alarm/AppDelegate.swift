import UIKit
import Rswift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)

        UNUserNotificationCenter.current().delegate = NotificationHandler.shared
        NotificationScheduler.declareNotificationCategories()
        
        if !UserDefaults.standard.bool(forKey: Constants.firstLaunchOccurred) {
            UserDefaults.standard.set(true, forKey: Constants.firstLaunchOccurred)
            NetworkService.refreshAllSurfSpots()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                let main = R.storyboard.main().instantiateInitialViewController()
                self.window?.rootViewController = main
                self.window?.makeKeyAndVisible()
            }
        }

        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        AlarmService.shared.refreshAlarms()

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        AlarmService.shared.refreshAlarms()
//        AlarmService.shared.testAlarm()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

