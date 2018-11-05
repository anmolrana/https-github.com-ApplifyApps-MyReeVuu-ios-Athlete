//
//  DBManager.swift
//  ProjectTemplate
//
//  Created by Ankit Goyal on 15/03/2018.
//  Copyright © 2018 Applify Tech Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData

class DBManager: NSObject{
    static func saveUserDataWithParameters(uModal : UserModal) {
        let app: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        let context: NSManagedObjectContext? = app?.persistentContainer.viewContext
        //   NSManagedObjectContext *context = [app threadManagedObjectContext];
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:KCoreDataUserEntity)
        let predicate = NSPredicate(format: "userId == %@","\(uModal.id)")
        fetchRequest.predicate = predicate
        do {
            let userListArr = try(context?.fetch(fetchRequest)) as! [UserEntity]
            if userListArr.count != 0{
                let newDevice = userListArr.last
                self.saveUserEntity(newDevice: newDevice!, uModal: uModal, context: context!, isUpdating: true)
            }
            else{
                let  newDevice = NSEntityDescription.insertNewObject(forEntityName: KCoreDataUserEntity, into: context!) as! UserEntity
                self.saveUserEntity(newDevice: newDevice, uModal: uModal, context: context!, isUpdating: false)
                
            }
        } catch let errorMsg{
            NSUtility.DBlog(errorMsg as AnyObject)
        }
        
    }
    static func saveUserEntity (newDevice : UserEntity,uModal : UserModal,context: NSManagedObjectContext,isUpdating:Bool){
        newDevice.userId = "\(uModal.id)"
        newDevice.userAccountType = "\(uModal.accountType)"
        newDevice.userName = uModal.name
        newDevice.userUserName = uModal.username
        newDevice.userEmail = uModal.email
        newDevice.userAccessToken = uModal.accessToken
        newDevice.userEmailVerified = "\(uModal.emailVerified)"
        newDevice.userGender = "\(uModal.gender)"
        newDevice.userIsApproved = "\(uModal.isApproved)"
        newDevice.userIsBlocked = "\(uModal.isBlocked)"
        newDevice.userPhoneNumber = uModal.phoneNumber
        newDevice.userProfilePic = uModal.profilePic
        newDevice.userUserType = "\(uModal.userType)"
        newDevice.userProfileStatus = "\(uModal.profileStatus)"
        do {
            //add the info to the Entity
            try context.save()
        }
        catch _ as NSError {
            // // print("Could not save\(error),\(error.userInfo)")
        }
    }
    static func fetchUserDataWithParameters(userId : String) -> UserEntity? {
        if userId == ""{
            return nil
        }
        let app: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        
        let context: NSManagedObjectContext? = app?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:KCoreDataUserEntity)
        let predicate = NSPredicate(format: "userId == %@",userId)
        fetchRequest.predicate = predicate
        do {
            let userListArr = try(context?.fetch(fetchRequest)) as! [UserEntity]
            if userListArr.count != 0{
                let newDevice = userListArr.last
                return newDevice!
            }
            else{
                return nil
                
            }
        } catch let errorMsg{
            NSUtility.DBlog(errorMsg as AnyObject)
        }
        return nil
    }
    
    static func UpdateUserEmailVerified(userId : String){
        
        let app: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        
        let context: NSManagedObjectContext? = app?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:KCoreDataUserEntity)
        let predicate = NSPredicate(format: "userId == %@",userId)
        fetchRequest.predicate = predicate
        do {
            let userListArr = try(context?.fetch(fetchRequest)) as! [UserEntity]
            if userListArr.count != 0{
                for newDevice1 in userListArr{
                    newDevice1.userEmailVerified = "1"
                }
                try context?.save()
            }
            
        } catch let errorMsg{
            NSUtility.DBlog(errorMsg as AnyObject)
        }
        
    }
    
    static func deleteUser(userId:String){
        let app: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        let context: NSManagedObjectContext? = app?.persistentContainer.viewContext
        //   NSManagedObjectContext *context = [app threadManagedObjectContext];
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:KCoreDataUserEntity)
        let predicate = NSPredicate(format: "userId == %@",userId)
        fetchRequest.predicate = predicate
        do {
            let ListArr = try (context?.fetch(fetchRequest)) as! [UserEntity]
            if ListArr.count != 0{
                
                
                for newDevice1 in ListArr{
                    context?.delete(newDevice1)
                }
                try context?.save()
            }
        }
        catch  _{
            // print("Could not save\(error),\(error.userInfo)")
        }
    }
    static func deleteAllUsers(){
        let app: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        let context: NSManagedObjectContext? = app?.persistentContainer.viewContext
        //   NSManagedObjectContext *context = [app threadManagedObjectContext];
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:KCoreDataUserEntity)
        
        do {
            let ListArr = try (context?.fetch(fetchRequest)) as! [UserEntity]
            if ListArr.count != 0{
                
                
                for newDevice1 in ListArr{
                    context?.delete(newDevice1)
                }
                try context?.save()
            }
        }
        catch  _{
            // print("Could not save\(error),\(error.userInfo)")
        }
    }
    static func saveDataWithParameters<P>(uModal : P,dataType:P.Type) {
        let app: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        let context: NSManagedObjectContext? = app?.persistentContainer.viewContext
        var entityName = ""
        var id = ""
        if dataType is SportModal.Type{
            entityName = KCoreDataSportsEntity
            id = "\((uModal as! SportModal).id)"
        }
        else if dataType is LevelModal.Type{
            entityName = KCoreDataLevelEntity
            id = "\((uModal as! LevelModal).id)"
        }
        else if dataType is StateModal.Type{
            entityName = KCoreDataStatesEntity
            id = "\((uModal as! StateModal).id)"
        }
        else if dataType is QuestionersModal.Type{
            entityName = KCoreDataQuestionEntity
            id = "\((uModal as! QuestionersModal).id)"
        }
        else if dataType is AthleteBackgroundModal.Type{
            entityName = KCoreDataSportsInfoEntity
            id = "\((uModal as! AthleteBackgroundModal).sportId)"
        }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:entityName)
        let predicate = NSPredicate(format: "id == %@",id)
        fetchRequest.predicate = predicate

        if dataType is SportModal.Type{
            do {
                let userListArr = try(context?.fetch(fetchRequest)) as! [SportsEntity]
                if userListArr.count != 0{
                    let newDevice = userListArr.last
                    newDevice?.id = "\((uModal as! SportModal).id)"
                    newDevice?.name = (uModal as! SportModal).name
                    newDevice?.sportDescription = (uModal as! SportModal).sportDescription
                    newDevice?.image = (uModal as! SportModal).image
                }
                else{
                    let  newDevice = NSEntityDescription.insertNewObject(forEntityName: KCoreDataSportsEntity, into: context!) as! SportsEntity
                    newDevice.id = "\((uModal as! SportModal).id)"
                    newDevice.name = (uModal as! SportModal).name
                    newDevice.sportDescription = (uModal as! SportModal).sportDescription
                    newDevice.image = (uModal as! SportModal).image

                }
            }
            catch _ as NSError {
                // // print("Could not save\(error),\(error.userInfo)")
            }

        }
        else if dataType is LevelModal.Type{
            do {
                let userListArr = try(context?.fetch(fetchRequest)) as! [LevelsEntity]
                if userListArr.count != 0{
                    let newDevice = userListArr.last
                    newDevice?.id = "\((uModal as! LevelModal).id)"
                    newDevice?.name = (uModal as! LevelModal).name
                }
                else{
                    let  newDevice = NSEntityDescription.insertNewObject(forEntityName: KCoreDataLevelEntity, into: context!) as! LevelsEntity
                    newDevice.id = "\((uModal as! LevelModal).id)"
                    newDevice.name = (uModal as! LevelModal).name

                }
            }
            catch _ as NSError {
                // // print("Could not save\(error),\(error.userInfo)")
            }


        }
        else if dataType is StateModal.Type{
            do {
                let userListArr = try(context?.fetch(fetchRequest)) as! [StatesEntity]
                if userListArr.count != 0{
                    let newDevice = userListArr.last
                    newDevice?.id = "\((uModal as! StateModal).id)"
                    newDevice?.name = (uModal as! StateModal).name
                }
                else{
                    let  newDevice = NSEntityDescription.insertNewObject(forEntityName: KCoreDataStatesEntity, into: context!) as! StatesEntity
                    newDevice.id = "\((uModal as! StateModal).id)"
                    newDevice.name = (uModal as! StateModal).name

                }
            }
            catch _ as NSError {
                // // print("Could not save\(error),\(error.userInfo)")
            }

        }
        else if dataType is QuestionersModal.Type{
            do {
                let userListArr = try(context?.fetch(fetchRequest)) as! [QuestionEntity]
                if userListArr.count != 0{
                    let newDevice = userListArr.last
                    newDevice?.id = "\((uModal as! QuestionersModal).id)"
                    newDevice?.question = (uModal as! QuestionersModal).question
                    newDevice?.answer = (uModal as! QuestionersModal).answer
                    newDevice?.option = (uModal as! QuestionersModal).option
                    newDevice?.type = "\((uModal as! QuestionersModal).questionType)"
                }
                else{
                    let  newDevice = NSEntityDescription.insertNewObject(forEntityName: KCoreDataQuestionEntity, into: context!) as! QuestionEntity
                    newDevice.id = "\((uModal as! QuestionersModal).id)"
                    newDevice.question = (uModal as! QuestionersModal).question
                    newDevice.answer = (uModal as! QuestionersModal).answer
                    newDevice.option = (uModal as! QuestionersModal).option
                    newDevice.type = "\((uModal as! QuestionersModal).questionType)"

                }
            }
            catch _ as NSError {
                // // print("Could not save\(error),\(error.userInfo)")
            }
        }
        else if dataType is AthleteBackgroundModal.Type{
            do {
                let userListArr = try(context?.fetch(fetchRequest)) as! [SportsInfoEntity]
                if userListArr.count != 0{
                    let newDevice = userListArr.last
                    newDevice?.id = "\((uModal as! AthleteBackgroundModal).sportId)"
                    newDevice?.experience = "\((uModal as! AthleteBackgroundModal).experience)"
                    newDevice?.level = "\((uModal as! AthleteBackgroundModal).level)"
                    newDevice?.zipCode = "\((uModal as! AthleteBackgroundModal).zipcodeInfo)"
                    newDevice?.name = (uModal as! AthleteBackgroundModal).name
                }
                else{
                    let  newDevice = NSEntityDescription.insertNewObject(forEntityName: KCoreDataSportsInfoEntity, into: context!) as! SportsInfoEntity
                    newDevice.id = "\((uModal as! AthleteBackgroundModal).sportId)"
                    newDevice.experience = "\((uModal as! AthleteBackgroundModal).experience)"
                    newDevice.level = "\((uModal as! AthleteBackgroundModal).level)"
                    newDevice.zipCode = "\((uModal as! AthleteBackgroundModal).zipcodeInfo)"
                    newDevice.name = (uModal as! AthleteBackgroundModal).name
                    
                }
            }
            catch _ as NSError {
                // // print("Could not save\(error),\(error.userInfo)")
            }
        }

        do {
            //add the info to the Entity
            try context?.save()
        }
        catch _ as NSError {
            // // print("Could not save\(error),\(error.userInfo)")
        }
    }


    static func fetchDataWithParameters<P>(dataType:P.Type)->[P] {
        let app: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        let context: NSManagedObjectContext? = app?.persistentContainer.viewContext
        var entityName = ""
        if dataType is SportsEntity.Type{
            entityName = KCoreDataSportsEntity
        }
        else if dataType is LevelsEntity.Type{
            entityName = KCoreDataLevelEntity
        }
        else if dataType is StatesEntity.Type{
            entityName = KCoreDataStatesEntity
        }
        else if dataType is QuestionEntity.Type{
            entityName = KCoreDataQuestionEntity
        }
        else if dataType is SportsInfoEntity.Type{
            entityName = KCoreDataSportsInfoEntity
        }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:entityName)
        do {
            let userListArr = try(context?.fetch(fetchRequest)) as! [P]
            return userListArr
        } catch let errorMsg{
            NSUtility.DBlog(errorMsg as AnyObject)
        }
        return []
    }
    static func deleteAllSportsLevelsCertifExpertise<P>(dataType:P.Type){
        let app: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        let context: NSManagedObjectContext? = app?.persistentContainer.viewContext
        var entityName = ""
        if dataType is SportsEntity.Type{
            entityName = KCoreDataSportsEntity
        }
        else if dataType is LevelsEntity.Type{
            entityName = KCoreDataLevelEntity
        }
        else if dataType is StatesEntity.Type{
            entityName = KCoreDataStatesEntity
        }
        else if dataType is QuestionEntity.Type{
            entityName = KCoreDataQuestionEntity
        }
        else if dataType is SportsInfoEntity.Type{
            entityName = KCoreDataSportsInfoEntity
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:entityName)
        
        do {
            let ListArr = try (context?.fetch(fetchRequest)) as! [P]
            if ListArr.count != 0{
                
                
                for newDevice1 in ListArr{
                    context?.delete(newDevice1 as! NSManagedObject)
                }
                try context?.save()
            }
        }
        catch  _{
            // print("Could not save\(error),\(error.userInfo)")
        }
    }
    static func deleteAllData(){
        self.deleteAllUsers()
        self.deleteAllSportsLevelsCertifExpertise(dataType: SportsEntity.self)
        self.deleteAllSportsLevelsCertifExpertise(dataType: LevelsEntity.self)
        self.deleteAllSportsLevelsCertifExpertise(dataType: StatesEntity.self)
        self.deleteAllSportsLevelsCertifExpertise(dataType: QuestionEntity.self)
        self.deleteAllSportsLevelsCertifExpertise(dataType: SportsInfoEntity.self)
    }
}
