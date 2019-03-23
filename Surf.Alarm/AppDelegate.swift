import UIKit
import Rswift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)

        UNUserNotificationCenter.current().delegate = NotificationHandler.shared
        
        NotificationScheduler.declareNotificationCategories()
        
        if !UserDefaults.standard.bool(forKey: Constants.firstLaunchOccurred) {
            UserDefaults.standard.set(true, forKey: Constants.firstLaunchOccurred)
            NetworkService.refreshAllSurfSpots()
        }
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        AlarmService.shared.refreshAlarms()

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        #if DEBUG

        AlarmService.shared.testAlarm()

        #else
        
        AlarmService.shared.refreshAlarms()

        #endif
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

