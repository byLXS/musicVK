//
//  CodableDialog.swift
//  VKMusic
//
//  Created by Robert on 14.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//

import Foundation

struct CodableDialog: Codable {
    let response: Response
}

struct Response: Codable {
    let count: Int
    let items: [Item]?
    let unreadCount: Int?
    let profiles: [Profile]?
    let groups: [Group]?
    
    enum CodingKeys: String, CodingKey {
        case count, items
        case unreadCount = "unread_count"
        case profiles, groups
    }
}

struct Group: Codable {
    let id: Int
    let name, screenName: String
    let isClosed: Int
    let type: String
    let photo50, photo100, photo200: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}

struct Item: Codable {
    let conversation: Conversation
    let lastMessage: LastMessage
    
    enum CodingKeys: String, CodingKey {
        case conversation
        case lastMessage = "last_message"
    }
}

struct Conversation: Codable {
    let peer: Peer
    let inRead, outRead, lastMessageID: Int
    let unreadCount: Int?
    let canWrite: CanWrite
    let chatSettings: ChatSettings?
    let pushSettings: PushSettings?
    let currentKeyboard: Keyboard?
    
    enum CodingKeys: String, CodingKey {
        case peer
        case inRead = "in_read"
        case outRead = "out_read"
        case lastMessageID = "last_message_id"
        case unreadCount = "unread_count"
        case canWrite = "can_write"
        case chatSettings = "chat_settings"
        case pushSettings = "push_settings"
        case currentKeyboard = "current_keyboard"
    }
}

struct CanWrite: Codable {
    let allowed: Bool
    let reason: Int?
}

struct ChatSettings: Codable {
    let title: String
    let membersCount: Int
    let state: String
    let photo: ChatSettingsPhoto
    let activeIDS: [Int]
    let acl: ACL
    let isGroupChannel: Bool
    let ownerID: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case membersCount = "members_count"
        case state, photo
        case activeIDS = "active_ids"
        case acl
        case isGroupChannel = "is_group_channel"
        case ownerID = "owner_id"
    }
}

struct ACL: Codable {
    let canInvite, canChangeInfo, canChangePin, canPromoteUsers: Bool
    let canSeeInviteLink, canChangeInviteLink: Bool
    
    enum CodingKeys: String, CodingKey {
        case canInvite = "can_invite"
        case canChangeInfo = "can_change_info"
        case canChangePin = "can_change_pin"
        case canPromoteUsers = "can_promote_users"
        case canSeeInviteLink = "can_see_invite_link"
        case canChangeInviteLink = "can_change_invite_link"
    }
}

struct ChatSettingsPhoto: Codable {
    let photo50, photo100, photo200: String
    
    enum CodingKeys: String, CodingKey {
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}

struct Keyboard: Codable {
    let oneTime: Bool
    let buttons: [[Button]]
    let authorID: Int
    
    enum CodingKeys: String, CodingKey {
        case oneTime = "one_time"
        case buttons
        case authorID = "author_id"
    }
}

struct Button: Codable {
    let color: String
    let action: Action
}

struct Action: Codable {
    let type, payload, label: String
}

struct Peer: Codable {
    let id: Int
    let type: TypeEnum
    let localID: Int
    
    enum CodingKeys: String, CodingKey {
        case id, type
        case localID = "local_id"
    }
}

enum TypeEnum: String, Codable {
    case chat = "chat"
    case group = "group"
    case user = "user"
}

struct PushSettings: Codable {
    let noSound: Bool
    let disabledUntil: Int
    let disabledForever: Bool
    
    enum CodingKeys: String, CodingKey {
        case noSound = "no_sound"
        case disabledUntil = "disabled_until"
        case disabledForever = "disabled_forever"
    }
}

struct LastMessage: Codable {
    let date, fromID, id, out: Int
    let peerID: Int
    let text: String
    let conversationMessageID: Int
    let fwdMessages: [JSONAny]?
    let important: Bool
    let randomID: Int
    let attachments: [LastMessageAttachment]?
    let isHidden: Bool
    let keyboard: Keyboard?
    let updateTime: Int?
    
    enum CodingKeys: String, CodingKey {
        case date
        case fromID = "from_id"
        case id, out
        case peerID = "peer_id"
        case text
        case conversationMessageID = "conversation_message_id"
        case fwdMessages = "fwd_messages"
        case important
        case randomID = "random_id"
        case attachments
        case isHidden = "is_hidden"
        case keyboard
        case updateTime = "update_time"
    }
}

struct LastMessageAttachment: Codable {
    let type: String
    let sticker: Sticker?
    let video: Video?
    let audio: Audio?
    let link: Link?
    let photo: LinkPhoto?
    let wall: Wall?
}

struct Audio: Codable {
    let id, ownerID: Int?
    let artist, title: String?
    let duration, date: Int?
    let url: String?
    let trackCode: String?
    let lyricsID, genreID: Int?
    let isHq, isExplicit: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case trackCode = "track_code"
        case ownerID = "owner_id"
        case artist, title, duration, date, url
        case lyricsID = "lyrics_id"
        case genreID = "genre_id"
        case isHq = "is_hq"
        case isExplicit = "is_explicit"
    }
}

struct Link: Codable {
    let url: String
    let title, caption, description: String
    let photo: LinkPhoto?
}

struct LinkPhoto: Codable {
    let id, albumID, ownerID: Int
    let sizes: [Size]
    let text: String
    let date: Int
    let userID: Int?
    let accessKey: String?
    let postID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case albumID = "album_id"
        case ownerID = "owner_id"
        case sizes, text, date
        case userID = "user_id"
        case accessKey = "access_key"
        case postID = "post_id"
    }
}

struct Size: Codable {
    let type: String?
    let url: String
    let width, height: Int
}

struct Sticker: Codable {
    let productID, stickerID: Int
    let images, imagesWithBackground: [Size]
    let animationURL: String
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case stickerID = "sticker_id"
        case images
        case imagesWithBackground = "images_with_background"
        case animationURL = "animation_url"
    }
}

struct Wall: Codable {
    let id, fromID, toID, date: Int
    let postType, text: String
    let markedAsAds: Int
    let attachments: [WallAttachment]
    let postSource: PostSource
    let comments: Comments
    let likes: Likes
    let reposts: Reposts
    let views: Views
    let accessKey: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fromID = "from_id"
        case toID = "to_id"
        case date
        case postType = "post_type"
        case text
        case markedAsAds = "marked_as_ads"
        case attachments
        case postSource = "post_source"
        case comments, likes, reposts, views
        case accessKey = "access_key"
    }
}

struct WallAttachment: Codable {
    let type: String
    let photo: LinkPhoto
}

struct Comments: Codable {
    let count, canPost: Int
    let groupsCanPost: Bool
    
    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
        case groupsCanPost = "groups_can_post"
    }
}

struct Likes: Codable {
    let count, userLikes, canLike, canPublish: Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
        case canLike = "can_like"
        case canPublish = "can_publish"
    }
}

struct PostSource: Codable {
    let type: String
}

struct Reposts: Codable {
    let count, userReposted: Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

struct Views: Codable {
    let count: Int
}

struct Video: Codable {
    let id, ownerID: Int
    let title: String
    let duration: Int
    let description: String
    let date, comments, views, width: Int
    let height: Int
    let photo130, photo320, photo800, photo1280: String
    let accessKey: String
    let firstFrame800, firstFrame1280, firstFrame320, firstFrame160: String
    let firstFrame130: String
    let canAdd: Int
    let isPrivate: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case title, duration, description, date, comments, views, width, height
        case photo130 = "photo_130"
        case photo320 = "photo_320"
        case photo800 = "photo_800"
        case photo1280 = "photo_1280"
        case accessKey = "access_key"
        case firstFrame800 = "first_frame_800"
        case firstFrame1280 = "first_frame_1280"
        case firstFrame320 = "first_frame_320"
        case firstFrame160 = "first_frame_160"
        case firstFrame130 = "first_frame_130"
        case canAdd = "can_add"
        case isPrivate = "is_private"
    }
}

struct Profile: Codable {
    let id: Int
    let firstName, lastName: String
    let sex: Int
    let screenName: String?
    let photo50, photo100: String
    let online: Int
    let onlineApp: String?
    let onlineMobile: Int?
    let deactivated: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case sex
        case screenName = "screen_name"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case online
        case onlineApp = "online_app"
        case onlineMobile = "online_mobile"
        case deactivated
    }
}


// MARK: Encode/decode helpers

class JSONNull: Codable {
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {
    let value: Any
    
    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }
    
    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }
    
    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }
    
    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }
    
    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }
    
    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

