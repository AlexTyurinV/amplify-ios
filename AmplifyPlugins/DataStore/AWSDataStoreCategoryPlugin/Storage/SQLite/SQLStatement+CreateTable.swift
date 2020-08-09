//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify
import Foundation

/// Represents a `create table` SQL statement. The table is created based on the `ModelSchema`
/// associated with the passed `Model.Type`.
struct CreateTableStatement: SQLStatement {

    let schema: ModelSchema

    init(schema: ModelSchema) {
        self.schema = schema
    }

    var stringValue: String {
        let name = schema.name
        var statement = "create table if not exists \(name) (\n"

        let columns = schema.columns
        let foreignKeys = schema.foreignKeys

        for (index, column) in columns.enumerated() {
            statement += "  \"\(column.sqlName)\" \(column.sqlType.rawValue)"
            if column.isPrimaryKey {
                statement += " primary key"
            }
            if column.isRequired {
                statement += " not null"
            }
            if column.isOneToOne && column.isForeignKey {
                statement += " unique"
            }

            let isNotLastColumn = index < columns.endIndex - 1
            if isNotLastColumn {
                statement += ",\n"
            }
        }

        let hasForeignKeys = !foreignKeys.isEmpty
        if hasForeignKeys {
            statement += ",\n"
        }

        for (index, foreignKey) in foreignKeys.enumerated() {
            statement += "  foreign key(\"\(foreignKey.sqlName)\") "
            let associatedModel = foreignKey.requiredAssociatedModel
            // TODO: Handle the force unwrapping
            let schema = ModelRegistry.modelSchema(from: associatedModel)!
            let associatedId = schema.primaryKey
            let associatedModelName = schema.name
            statement += "references \(associatedModelName)(\"\(associatedId.sqlName)\")\n"
            statement += "    on delete cascade"
            let isNotLastKey = index < foreignKeys.endIndex - 1
            if isNotLastKey {
                statement += "\n"
            }
        }

        statement += "\n);"
        return statement
    }
}
