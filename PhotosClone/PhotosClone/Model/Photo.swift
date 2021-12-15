//
//  Photo.swift
//  PhotosClone
//
//  Created by Anna Izzo on 15/12/21.
//

import Foundation
import UIKit

struct Photo : Identifiable {
    
    var id: String {title}
    let title: String
    let image: UIImage!
    let date: Date
    var isFavorite: Bool
    
    init (title: String, date: Date? = Date.now, isFavorite: Bool? = false){
        self.title = title
        self.image = UIImage(named: title) ?? UIImage(systemName: "photo")!
        self.date = date ?? Date.now
        self.isFavorite = isFavorite ?? false
    }
    
    func photoAspectRatio() -> CGFloat {
        let ar = self.image.size.width / self.image.size.height
        return ar
    }
    
    func dateFormattedMonthDay() -> String {
        var date = self.date.formatted(date: .long, time: .omitted)
        date.removeLast(5)
        date.removeAll { $0 == ","}
        return date
    }
    
    func dateFormattedDayMonth() -> String {
        var date = self.date.formatted(date: .abbreviated, time: .omitted)
        date.removeLast(5)
        date.removeAll { $0 == ","}
        return date
    }
}
