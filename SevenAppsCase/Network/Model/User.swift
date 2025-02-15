//
//  User.swift
//  SevenAppsCase
//
//  Created by Barış Dilekçi on 14.02.2025.
//

import Foundation


/* Bu modeli QucikType ile oluşturdum.  JSON yapısını yapıştırdım, gerekli ayarlamaları yapıp buraya aktardım. */


struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
}
