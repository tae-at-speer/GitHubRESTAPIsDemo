//
//  GitHubUser.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import Foundation

struct GitHubUser: Codable {
    
    var login: String
    var id: Int
    var node_id: String
    var avatar_url: String
    var gravatar_id: String
    var url: String
    var html_url: String
    var followers_url: String
    var following_url: String
    var gists_url: String
    var starred_url: String
    var subscriptions_url: String
    var organizations_url: String
    var repos_url: String
    var events_url: String
    var received_events_url: String
    var type: String
    var site_admin: Bool
    var score: Float
    //variable for user profile
    var name: String
    var followers: Int
    var following: Int
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case node_id
        case avatar_url
        case gravatar_id
        case url
        case html_url
        case followers_url
        case following_url
        case gists_url
        case starred_url
        case subscriptions_url
        case organizations_url
        case repos_url
        case events_url
        case received_events_url
        case type
        case site_admin
        case score
        case name
        case followers
        case following
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        login = try container.decodeIfPresent(String.self, forKey: .login) ?? ""
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        node_id = try container.decodeIfPresent(String.self, forKey: .node_id) ?? ""
        avatar_url = try container.decodeIfPresent(String.self, forKey: .avatar_url) ?? ""
        gravatar_id = try container.decodeIfPresent(String.self, forKey: .gravatar_id) ?? ""
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        html_url = try container.decodeIfPresent(String.self, forKey: .html_url) ?? ""
        followers_url = try container.decodeIfPresent(String.self, forKey: .followers_url) ?? ""
        following_url = try container.decodeIfPresent(String.self, forKey: .following_url) ?? ""
        gists_url = try container.decodeIfPresent(String.self, forKey: .gists_url) ?? ""
        starred_url = try container.decodeIfPresent(String.self, forKey: .starred_url) ?? ""
        subscriptions_url = try container.decodeIfPresent(String.self, forKey: .subscriptions_url) ?? ""
        organizations_url = try container.decodeIfPresent(String.self, forKey: .organizations_url) ?? ""
        repos_url = try container.decodeIfPresent(String.self, forKey: .repos_url) ?? ""
        events_url = try container.decodeIfPresent(String.self, forKey: .events_url) ?? ""
        received_events_url = try container.decodeIfPresent(String.self, forKey: .received_events_url) ?? ""
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        site_admin = try container.decodeIfPresent(Bool.self, forKey: .site_admin) ?? false
        score = try container.decodeIfPresent(Float.self, forKey: .score) ?? 0.0
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        followers = try container.decodeIfPresent(Int.self, forKey: .followers) ?? 0
        following = try container.decodeIfPresent(Int.self, forKey: .following) ?? 0
    }
}
