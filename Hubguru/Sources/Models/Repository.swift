//
// Repository.swift
//
// Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import SwiftyJSON

/// Represents a GitHub repository.
public struct Repository: ExpressibleByJSON {

	// MARK: Initializers

	/// Initialize an instance with a JSON representation.
	///
	/// - Parameters:
	///     - json: A JSON rerpresentation of this repository.
	///
	/// - SeeAlso: ExpressibleByJSON
	public init(json: JSON) {
		id = json["id"].intValue
        owner = json["owner"]["login"].stringValue
		name = json["name"].stringValue
		isFork = json["fork"].boolValue
        watchers = json["watchers"].intValue
        stars = json["stargazers_count"].intValue
        forks = json["forks"].intValue
	}

	// MARK: Properties

	/// A unique ID of this reposiroty.
	public let id: Int

    /// A repository owner.
    public let owner: String
    
	/// A name of this repository.
	public let name: String

	/// Whether this repository is a fork.
	public let isFork: Bool

    /// A number of watchers.
    public let watchers: Int
    
    /// A number of stars.
    public let stars: Int
    
    /// A number of forks.
    public let forks: Int
}
