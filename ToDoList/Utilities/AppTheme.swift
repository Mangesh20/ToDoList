//
//  AppTheme.swift
//  ToDoList
//
//  Created by Mangesh Tekale on 23/04/23.
//

import Foundation
import UIKit

func UIColorFromRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
}

struct AppTheme {
   fileprivate struct Color {
       static let darkNavyBlue = UIColorFromRGB(red: 5.0, green: 102.0, blue: 141.0)
       static let lighNavyBlue = UIColorFromRGB(red: 66.0, green: 122.0, blue: 161.0)
       static let faintBlue = UIColorFromRGB(red: 235.0, green: 242.0, blue: 250.0)
       static let redColor = UIColorFromRGB(red: 159, green: 7, blue: 5)
       static let white = UIColor.white
       static let high = UIColorFromRGB(red: 255, green: 112, blue: 112)
       static let medium = UIColorFromRGB(red: 198, green: 202, blue: 83)
       static let low = UIColorFromRGB(red: 121, green: 221, blue: 159)
       static let none = UIColorFromRGB(red: 213, green: 232, blue: 235)
    }
    
    fileprivate struct Font {
        static let boldLarge = UIFont(name: "AvenirNext-DemiBold", size: 16.0)!
        static let regularMedium = UIFont(name: "AvenirNext-Regular", size: 14.0)!
        static let regularLarge = UIFont(name: "AvenirNext-Regular", size: 16.0)!
        static let boldVeryLarge =  UIFont(name: "AvenirNext-DemiBold", size: 20.0)!
        
    }
    
    
    struct NavigationBar {
        static let barTintColor = Color.darkNavyBlue
        static let tintColor = Color.faintBlue
        static let titleColor = Color.faintBlue
        static let titleFont =  Font.boldVeryLarge
    }
    
    struct SectionHeader {
        static let titleTextColor = Color.darkNavyBlue
        static let titleFont = Font.boldLarge
    }
    
    struct Text {
        static let title = Font.boldLarge
        static let paragraph = Font.regularMedium
        static let subHeading = Font.regularLarge
        static let heading = Font.boldVeryLarge
        
        static let titleColor = Color.darkNavyBlue
        static let paragraphColor = Color.lighNavyBlue
        static let headingColor = Color.darkNavyBlue
        static let subHeadingColor = Color.lighNavyBlue

    }
    

    struct CollectionView {
        static let backgroundColor =  Color.faintBlue
    }

    struct View {
        static let backgroundColor =  Color.faintBlue
    }


    struct CollectionViewCell {
        static let backgroundColor =  Color.white
    }


    static func configNavigatorBar() {
        // Override point for customization after application launch.
        UINavigationBar.appearance().backgroundColor = AppTheme.NavigationBar.barTintColor
        UINavigationBar.appearance().barTintColor = AppTheme.NavigationBar.barTintColor
        UIBarButtonItem.appearance().tintColor = AppTheme.NavigationBar.tintColor
    }
    
    struct TaskCellStyles {
        static let taskCellBgColor = Color.white
        static let nameLabelColor = Color.darkNavyBlue
        static let remainingTimeLabelColor = Color.lighNavyBlue
        static let valueLabelColor = Color.lighNavyBlue
        static let doneIconColor = Color.lighNavyBlue
        static let deleteIconColor = Color.lighNavyBlue
        static let reaminingTimeOverdueColor = Color.redColor

        static let nameLabelFont = Font.boldLarge
        static let remainingTimeLabelFont = Font.regularMedium
        static let valueLabelFont = Font.regularMedium
        
    }

    struct TaskPriorityColors {
        static let high = Color.high
        static let medium = Color.medium
        static let low = Color.low
        static let none = Color.none
    }



}
