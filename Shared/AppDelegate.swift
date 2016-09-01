/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	Manages app lifecycle  split view.
 */


import UIKit
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        #if os(iOS)
            let navigationController = splitViewController.viewControllers.last! as! UINavigationController
            navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        #endif
        splitViewController.delegate = self
        return true
    }

    // MARK: Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? AssetGridViewController else { return false }
        if topAsDetailController.fetchResult == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: AnyObject?) -> Bool {
        // Let the storyboard handle the segue for every case except going from detail:assetgrid to detail:asset.
        guard !splitViewController.isCollapsed else { return false }
        guard !(vc is UINavigationController) else { return false }
        guard let detailNavController =
            splitViewController.viewControllers.last! as? UINavigationController,
            detailNavController.viewControllers.count == 1
            else { return false }

        detailNavController.pushViewController(vc, animated: true)
        return true
    }
}

/// In iOS / tvOS 10 beta 3, the APIs that work with generic PHFetchResults are properly annotated for
/// ObjC generics and imported into Swift, but these two methods aren't (because methods can't be generic
/// in ObjC). This extension wraps the type-casting necessary to preserve generic type parameters all
/// the way through from a PHFetchResult to a PHChange to a PHFetchResultChangeDetails to another PHFetchResult.
extension PHChange {
    func changeDetails<T: PHObject>(for object: T) -> PHObjectChangeDetails<T>? {
        return self.changeDetails(for: object) as! PHObjectChangeDetails<T>?
    }
    func changeDetails<T: PHObject>(for fetchResult: PHFetchResult<T>) -> PHFetchResultChangeDetails<T>? {
        return self.changeDetails(for: fetchResult)
    }
}
