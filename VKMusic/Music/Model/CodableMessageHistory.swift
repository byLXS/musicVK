//
//  CodableMessageHistory.swift
//  VKMusic
//
//  Created by Robert on 10.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//

import Foundation

struct CodableMessageHistory: Codable {
    let response: ResponseM
}

struct ResponseM: Codable {
    let items: [ItemHistory]
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
        case count = "count"
    }
}

struct ItemHistory: Codable {
    let attachments: [Attachment]
    let randomID: Int
    let id: Int
    let isHidden: Bool
    let fromID: Int
    let text: String
    let important: Bool
    let conversationMessageID: Int
    let date: Double
    let out: Int
    let peerID: Int
    let fwdMessages: [FwdMessage]
    
    enum CodingKeys: String, CodingKey {
        case attachments = "attachments"
        case randomID = "random_id"
        case id = "id"
        case isHidden = "is_hidden"
        case fromID = "from_id"
        case text = "text"
        case important = "important"
        case conversationMessageID = "conversation_message_id"
        case date = "date"
        case out = "out"
        case peerID = "peer_id"
        case fwdMessages = "fwd_messages"
    }
}

struct FwdMessage: Codable {
    let date, fromID: Int
    let text: String
    let attachments: [Attachment]
    let updateTime: Int
    
    enum CodingKeys: String, CodingKey {
        case date
        case fromID = "from_id"
        case text, attachments
        case updateTime = "update_time"
    }
}

struct Attachment: Codable {
    let type: String?
    let video: VideoHistory?
    let photo: Photo?
    let sticker: StickerHistory?
    let audio: AudioDialogs?
}

struct Photo: Codable {
    let albumID, id: Int
    let text, accessKey: String
    let date, ownerID: Int
    let sizes: [SizeHistory]
    
    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case id, text
        case accessKey = "access_key"
        case date
        case ownerID = "owner_id"
        case sizes
    }
}

struct AudioDialogs: Codable {
    let id, ownerID: Int
    let artist, title: String
    let duration, date: Int
    let url: String
    let isHq: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case artist, title, duration, date, url
        case isHq = "is_hq"
    }
}

struct StickerHistory: Codable {
    let productID, stickerID: Int
    let images, imagesWithBackground: [Image]
    let animationURL: String?
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case stickerID = "sticker_id"
        case images
        case imagesWithBackground = "images_with_background"
        case animationURL = "animation_url"
    }
}

struct Image: Codable {
    let height: Int
    let url: URL
    let width: Int
}

struct SizeHistory: Codable {
    let height: Int
    let type: String
    let url: URL
    let width: Int
}

struct VideoHistory: Codable {
    let firstFrame130, firstFrame320: URL
    let width: Int
    let description: String
    let ownerID: Int?
    let date: Int
    let firstFrame160, firstFrame800: String
    let height: Int
    let views: Int
    let id: Int?
    let accessKey: String
    let canAdd: Int
    let photo130: URL
    let comments: Int
    let title, photo320: String
    let duration: Int
    let photo800: URL
    
    enum CodingKeys: String, CodingKey {
        case firstFrame130 = "first_frame_130"
        case firstFrame320 = "first_frame_320"
        case width, description
        case ownerID = "owner_id"
        case date
        case firstFrame160 = "first_frame_160"
        case firstFrame800 = "first_frame_800"
        case height, views, id
        case accessKey = "access_key"
        case canAdd = "can_add"
        case photo130 = "photo_130"
        case comments, title
        case photo320 = "photo_320"
        case duration
        case photo800 = "photo_800"
    }
}


struct VideoGet: Codable {
    let items: [ItemVideo]
    let count: Int
}

struct ItemVideo: Codable {
    let firstFrame130, firstFrame320: String
    let width: Int
    let description: String
    let ownerID, date: Int
    let firstFrame160, firstFrame800: String
    let height, views, id, canAdd: Int
    let player: URL
    let photo130: String
    let comments: Int
    let title, photo320: String
    let duration: Int
    let photo800: String
    
    enum CodingKeys: String, CodingKey {
        case firstFrame130 = "first_frame_130"
        case firstFrame320 = "first_frame_320"
        case width, description
        case ownerID = "owner_id"
        case date
        case firstFrame160 = "first_frame_160"
        case firstFrame800 = "first_frame_800"
        case height, views, id
        case canAdd = "can_add"
        case player
        case photo130 = "photo_130"
        case comments, title
        case photo320 = "photo_320"
        case duration
        case photo800 = "photo_800"
    }
}
