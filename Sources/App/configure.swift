import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    
    //Connect to the database
    app.databases.use(.postgres(configuration:
    SQLPostgresConfiguration(hostname: "localhost", username: "postgres", password: "",
    database: "plants_nc3",
    tls: .prefer(try .init(configuration: .clientDefault)))), as: .psql)
    
    
    
    
    //Add Migrations
    app.migrations.add(CreatePlantsTable())
    app.migrations.add(UsersTableMigrationAction())
    try await app.autoMigrate()
    
    // register routes
    try routes(app)
}
