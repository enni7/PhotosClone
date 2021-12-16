//
//  PhotoDatabase.swift
//  PhotosClone
//
//  Created by Anna Izzo on 15/12/21.
//

import Foundation
import SwiftUI

class PhotoDatabase : ObservableObject {
    init () {
        self.photos = self.photosSortedByDate()
    }
    
    @Published var photos = [
        Photo(title: "IMG_0051", date: Date(timeInterval: -7775729, since: Date.now)),
        Photo(title: "IMG_0052", date: Date(timeInterval: -12331686, since: Date.now)),
        Photo(title: "IMG_0053", date: Date(timeInterval: -16803837, since: Date.now)),
        Photo(title: "IMG_0055", date: Date(timeInterval: -21834686, since: Date.now)),
        Photo(title: "IMG_0056", date: Date(timeInterval: -29617850, since: Date.now)),
        Photo(title: "IMG_0057", date: Date(timeInterval: -4223453, since: Date.now)),
        Photo(title: "IMG_0058", date: Date(timeInterval: -3069942, since: Date.now), isFavorite: true),
        Photo(title: "IMG_0059", date: Date(timeInterval: -24163324, since: Date.now), isFavorite: true),
        Photo(title: "IMG_0060", date: Date(timeInterval: -17049506, since: Date.now)),
        Photo(title: "IMG_0061", date: Date(timeInterval: -18820360, since: Date.now)),
        Photo(title: "IMG_0062", date: Date(timeInterval: -9370383, since: Date.now)),
        Photo(title: "IMG_0063", date: Date(timeInterval: -3072738, since: Date.now)),
        Photo(title: "IMG_0064", date: Date(timeInterval: -8709089, since: Date.now)),
        Photo(title: "IMG_0065", date: Date(timeInterval: -27973322, since: Date.now)),
        Photo(title: "IMG_0066", date: Date(timeInterval: -26875672, since: Date.now)),
        Photo(title: "IMG_0067", date: Date(timeInterval: -29101001, since: Date.now)),
        Photo(title: "IMG_0068", date: Date(timeInterval: -17444721, since: Date.now)),
        Photo(title: "IMG_0069", date: Date(timeInterval: -22695234, since: Date.now)),
        Photo(title: "IMG_0070", date: Date(timeInterval: -19574712, since: Date.now)),
        Photo(title: "IMG_0071", date: Date(timeInterval: -14201442, since: Date.now)),
        Photo(title: "IMG_0072", date: Date(timeInterval: -8316894, since: Date.now)),
        Photo(title: "IMG_0073", date: Date(timeInterval: -4066106, since: Date.now)),
        Photo(title: "IMG_0074", date: Date(timeInterval: -380304, since: Date.now), isFavorite: true),
        Photo(title: "IMG_0075", date: Date(timeInterval: -2551756, since: Date.now)),
        Photo(title: "IMG_0076", date: Date(timeInterval: -8580509, since: Date.now)),
        Photo(title: "IMG_0077", date: Date(timeInterval: -7044031, since: Date.now)),
        Photo(title: "IMG_0078", date: Date(timeInterval: -5345061, since: Date.now)),
        Photo(title: "IMG_0079", date: Date(timeInterval: -1635688, since: Date.now)),
        Photo(title: "IMG_0080", date: Date(timeInterval: -15843400, since: Date.now)),
        Photo(title: "IMG_0081", date: Date(timeInterval: -784399, since: Date.now), isFavorite: true),
        Photo(title: "IMG_0082", date: Date(timeInterval: -18070107, since: Date.now)),
        Photo(title: "IMG_0083", date: Date(timeInterval: -4893856, since: Date.now)),
        Photo(title: "IMG_0084", date: Date(timeInterval: -17404195, since: Date.now)),
        Photo(title: "IMG_0086", date: Date(timeInterval: -13967209, since: Date.now)),
        Photo(title: "IMG_0087", date: Date(timeInterval: -1789966, since: Date.now), isFavorite: true),
        Photo(title: "IMG_0031", date: Date(timeInterval: -18233341, since: Date.now)),
        Photo(title: "IMG_0032", date: Date(timeInterval: -8950271, since: Date.now)),
        Photo(title: "IMG_0033", date: Date(timeInterval: -27408076, since: Date.now)),
        Photo(title: "IMG_0034", date: Date(timeInterval: -12114260, since: Date.now)),
        Photo(title: "IMG_0035", date: Date(timeInterval: -13710382, since: Date.now), isFavorite: true),
        Photo(title: "IMG_0045", date: Date(timeInterval: -16275762, since: Date.now)),
        Photo(title: "IMG_0046", date: Date(timeInterval: -16076566, since: Date.now)),
        Photo(title: "IMG_0047", date: Date(timeInterval: -23585628, since: Date.now)),
        Photo(title: "IMG_0048", date: Date(timeInterval: -7775729, since: Date.now)),
        Photo(title: "IMG_0049", date: Date(timeInterval: -12331686, since: Date.now)),
        Photo(title: "IMG_0050", date: Date(timeInterval: -16803837, since: Date.now)),
        Photo(title: "IMG_0088", date: Date(timeInterval: -2535097, since: Date.now))
    ]
        
    func indexForPhoto(photo: Photo) -> Int {
        if let index = self.photos.firstIndex(where: {$0.id == photo.id}) {
            return (index)
        } else {return 0}
    }
    
    func scrolledCurrentPhotoIndex(offset: CGFloat, colWidth: CGFloat) -> Int {
        var index = Int()
        let offset = abs(offset)
        let divided = Int(offset / (colWidth + 4))
        switch colWidth {
        case 70:
            index = 5 * divided
        case 120:
            index = 3 * divided
        default:
            index = divided
        }
        
        if index <= 0 {
            return 0
        } else if index < self.photos.count {
            return index
        } else {
            return (self.photos.count - 1)
        }
    }
    
    func photosSortedByDate() -> [Photo] {
        let sorted = self.photos.sorted{ $0.date < $1.date }
        return sorted
    }
    
    func rotateImg(index: Int, rightTrueLeftFalse: Bool) {
        let currOrient = self.photos[index].image.imageOrientation
        
        let rightOriented = UIImage(cgImage: self.photos[index].image.cgImage!, scale: 1, orientation: .right)
        let leftOriented = UIImage(cgImage: self.photos[index].image.cgImage!, scale: 1, orientation: .left)
        let upOriented = UIImage(cgImage: self.photos[index].image.cgImage!, scale: 1, orientation: .up)
        let downOriented = UIImage(cgImage: self.photos[index].image.cgImage!, scale: 1, orientation: .down)
        
        switch currOrient {
        case .up:
            self.photos[index].image = rightTrueLeftFalse ? rightOriented : leftOriented
        case .left:
            self.photos[index].image = rightTrueLeftFalse ? upOriented : downOriented
        case .right:
            self.photos[index].image = rightTrueLeftFalse ? downOriented : upOriented
        default:
            self.photos[index].image = rightTrueLeftFalse ? leftOriented : rightOriented
            
        }
    }
    
//    enum PreviousOrNext {
//        case previous, next
//    }
//    func previousNextPhoto(currPhoto: Photo, previousNext: PhotoDatabase.PreviousOrNext) -> Photo {
//
//        var newPhoto = currPhoto
//        guard let index = self.photos.firstIndex(where: { $0.id == currPhoto.id }) else { return newPhoto}
//        if previousNext == .previous && index != 0 {
//            newPhoto = self.photos[index - 1]
//        } else if previousNext == .next && index != self.photos.count - 1 {
//            newPhoto = self.photos[index + 1]
//        }
//        return newPhoto
//    }
    
}

