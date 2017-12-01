//
//  GCDBlackBox.swift
//  Virtual Tourist
//
//  Created by VIdushi Jaiswal on 14/11/17.
//  Copyright © 2017 Vidushi Jaiswal. All rights reserved.
//

import Foundation
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

