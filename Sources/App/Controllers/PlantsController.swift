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
        plants.get(use: index)
        plants.post(use: post)
        plants.put(use: update)
        plants.delete(":id", use: delete)
        plants.get(":id", use: getPlantByID)
    }
    
    //GET
    func index (req: Request)throws-> EventLoopFuture<[Plant]>{
        Plant.query(on: req.db).all()
    }
    
    //GET by ID
    func getPlantByID(req: Request) throws -> EventLoopFuture<Plant>{
        return Plant.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    //PST
    func post (req: Request)throws-> EventLoopFuture<Plant>{
        let plant = try req.content.decode(Plant.self)
        return plant.create(on: req.db).map{plant}
        
    }
    
    //PUT
    func update(req: Request)throws->EventLoopFuture<HTTPStatus>{
        let newPlant = try req.content.decode(Plant.self)
        return Plant.find(newPlant.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.name = newPlant.name
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    //DELETE
    func delete(req: Request)throws->EventLoopFuture<HTTPStatus>{
        return Plant.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {$0.delete(on: req.db)}
            .transform(to: .ok)
    }
}


