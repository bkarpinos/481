//: Playground - noun: a place where people can play

import UIKit

//let string2 = "123 Main St. / (555) 555-5555"
let input = "nov 22nd"

let types: NSTextCheckingResult.CheckingType = [.date]
let detector = try? NSDataDetector(types: types.rawValue)
let matches = detector?.matches(in: input, options: [], range: NSMakeRange(0, (input as NSString).length))
for match in matches! {
    print(match.date ?? "no_date")
    
}


//
//detector?.enumerateMatches(in: input, options: [], range: NSMakeRange(0, (input as NSString).length)){
//    (result, flags, _) in
//    print(result ?? "no_date")
//}

//let input = "november 22"
//let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
//let matches = detector?.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
//
//for match in matches! {
//    let url = (input as NSString).substring(with: match.range)
//    print(url)
//}
