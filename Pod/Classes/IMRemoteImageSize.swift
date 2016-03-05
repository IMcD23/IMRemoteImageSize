//
//  IMRemoteImageSize.swift
//
//  Created by Ian McDowell (mcdow.ian@gmail.com).
//  Copyright © 2016 Ian McDowell. All rights reserved.
//

import UIKit

public extension UIImage {
    
    static func getImageSize(url: NSURL, completion: (size: CGSize) -> Void) {
        ImageSizeFetcher(url: url, completion: completion).fetch()
    }
    
}

private class ImageSizeFetcher: NSObject, NSURLSessionDelegate, NSURLSessionDataDelegate {
    
    private let types: [ImageType] = [ImageTypeJPG(), ImageTypeGIF(), ImageTypePNG(), ImageTypeBMP()]
    
    private var url: NSURL
    private var completion: ((size: CGSize) -> Void)?
    private var sizeRequestData = NSMutableData()
    
    init(url: NSURL, completion: (size: CGSize) -> Void) {
        self.url = url
        self.completion = completion
    }
    
    func fetch() {
        let request = NSURLRequest(URL: url)
        
        // create session and make ourself the delegate
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
        
        // create a data task without a completion handler (handled by delegate instead)
        let task = session.dataTaskWithRequest(request)
        
        task.resume()
    }
    
    @objc func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        let receivedData = self.sizeRequestData
        
        receivedData.appendData(data)
        
        guard let string = NSString(data: receivedData, encoding: NSASCIIStringEncoding) else {
            return
        }
        
        for type in types {
            if type.isOfType(string) {
                let size = type.getSize(data, string: string)
                
                dataTask.cancel()
                
                if self.completion != nil {
                    
                    completion!(size: size)
                    self.completion = nil
                    return
                }
                
            }
        }
        
        // image didnt match any types
        if self.completion != nil {
            completion!(size: CGSizeZero)
            self.completion = nil
        }
        
    }
    
    @objc func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil && self.completion != nil {
            completion!(size: CGSizeZero)
            self.completion = nil
        }
    }

}

private protocol ImageType: class {
    
    func isOfType(string: NSString) -> Bool
    
    func getSize(data: NSData, string: NSString) -> CGSize
}


private class ImageTypePNG: ImageType {
    
    func isOfType(string: NSString) -> Bool {
        let str = "\(UnicodeScalar(0x89))PNG\r\n"
        
        if string.substringToIndex(6) == str {
            if string.substringWithRange(NSMakeRange(12, 4)) == "IHDR" {
                return true
            }
        }
        return false
    }
    
    func getSize(data: NSData, string: NSString) -> CGSize {
        
        let width = OSReadSwapInt32(data.bytes, 24 - 8).littleEndian
        let height = OSReadSwapInt32(data.bytes, 24 - 4).littleEndian
        
        return CGSizeMake(CGFloat(width), CGFloat(height))
    }
}

private class ImageTypeGIF: ImageType {
    
    func isOfType(string: NSString) -> Bool {
        return string.substringToIndex(6) == "GIF87a" || string.substringToIndex(6) == "GIF89a"
    }
    
    func getSize(data: NSData, string: NSString) -> CGSize {
        
        let width = OSReadSwapInt16(data.bytes, 6).bigEndian
        let height = OSReadSwapInt16(data.bytes, 8).bigEndian
        
        return CGSizeMake(CGFloat(width), CGFloat(height))
    }
}

private class ImageTypeBMP: ImageType {
    
    func isOfType(string: NSString) -> Bool {
        return string.substringToIndex(2) == "BM"
    }
    
    func getSize(data: NSData, string: NSString) -> CGSize {
        
        let width = OSReadSwapInt32(data.bytes, 18).bigEndian
        let height = OSReadSwapInt32(data.bytes, 22).bigEndian
        
        return CGSizeMake(CGFloat(width), CGFloat(height))
    }
}


private class ImageTypeJPG: ImageType {
    
    func isOfType(string: NSString) -> Bool {
        let str = "\(UnicodeScalar(0xff))\(UnicodeScalar(0xd8))"
        
        return string.substringToIndex(2) == str
    }
    
    func getSize(data: NSData, string: NSString) -> CGSize {
        
        let length = data.length
        let bytes = Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(data.bytes), count: data.length))
        
        var offset: Int = 4
        var block_length: UInt16 = UInt16(bytes[offset]) * 256 + UInt16(bytes[offset + 1])
        
        while offset < length {
            offset += Int(block_length)
            
            if offset >= length {
                break
            }
            if bytes[offset] != 0xFF {
                break
            }
            
            let s = bytes[offset + 1]
            if s >= 0xC0 && s <= 0xCF {
                let height: UInt16 = UInt16(bytes[offset + 5]) * 256 + UInt16(bytes[offset + 6])
                let width: UInt16 = UInt16(bytes[offset + 7]) * 256 + UInt16(bytes[offset + 8])
                
                return CGSizeMake(CGFloat(width), CGFloat(height))
            } else {
                offset += 2
                block_length = UInt16(bytes[offset]) * 256 + UInt16(bytes[offset + 1])
            }
        }
        
        
        return CGSizeZero
    }
    
    func extractSize(data: NSData, i: Int) -> CGSize {
        return CGSizeZero
    }
}
