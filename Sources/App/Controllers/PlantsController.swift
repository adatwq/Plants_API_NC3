//
//  File.swift
//  
//
//  Created by Khawlah Khalid on 25/01/2024.
//

import Vapor
import Fluent

struct PlantsController: RouteCollection{
    func boot(routes: RoutesBuilder) throws {
        let plants = routes.grouped("plants")
            .grouped(JWTAuthMiddleware())
        plants.get(use: index)
        plants.post(use: post)
        plants.put(use: update)
        plants.delete(":id", use: delete)
        plants.get(":id", use: getPlantByID)
    }
    
    //GET
    func index (req: Request)async throws-> [Plant]{
      try await Plant.query(on: req.db).all()
    }
    
    //GET by ID
    func getPlantByID(req: Request) async throws -> Plant{
        let plant = try await Plant.find(req.parameters.get("id"), on: req.db)
        guard let plant else {
            throw Abort(.notFound)
        }
          return plant
    }
    
    //PST
    func post (req: Request)async throws-> Plant{
        let plant = try req.content.decode(Plant.self)
        try await plant.create(on: req.db)
        return plant
    }
    
    //PUT
    func update(req: Request)async throws-> Plant {
        let newPlant = try req.content.decode(Plant.self)
        let plantToUpdate = try await Plant.find(newPlant.id, on: req.db)
        guard let plantToUpdate else { throw Abort(.notFound) }
        plantToUpdate.name = newPlant.name
        try await plantToUpdate.save(on: req.db)
        return plantToUpdate
    }
    

    func delete(req: Request)async throws-> Plant{
        let plant = try await Plant.find(req.parameters.get("id"), on: req.db)
        guard let plant else { throw Abort(.notFound) }
        try await plant.delete(on: req.db)
        return plant
        
    }

}


