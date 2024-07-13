//
//  NotificationNavigator.swift
//  PropertyHero
//
//  Created by KHOI LE on 8/6/23.
//

import UIKit

protocol NotificationNavigatorType {
    
}

struct NotificationNavigator: NotificationNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
}
