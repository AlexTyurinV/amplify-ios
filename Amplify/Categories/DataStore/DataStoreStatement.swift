//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// This protocol represents a statement that will be executed in a specific storage
/// implementations. Concrete types of this protocol may include SQL insert statements,
/// queries or GraphQL mutations.
public protocol DataStoreStatement {

    /// The type of the variables container related to a concrete statement implementation
    associatedtype Variables

    /// The schema of the model associated with a particular statement
    var schema: ModelSchema { get }

    /// The actual string content of the statement (e.g. a SQL query or a GraphQL document)
    var stringValue: String { get }

    /// The variables associated with the statement
    var variables: Variables { get }
}
