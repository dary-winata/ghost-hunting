////
////  MachineLearning.swift
////  GhostHunting
////
////  Created by dary winata nugraha djati on 09/08/23.
////
//
//import CoreML
//
//class MachineLearning {
//    var dataModel: MLModel
//    
//    init(modelUrl: String) {
//        let modelUrl = modelUrl
//        guard let dataUrl = Bundle.main.url(forResource: modelUrl, withExtension: "mlmodelc") else {return}
//        do {
//            let model = try MLModel(contentsOf: dataUrl)
//            self.dataModel = model
//        } catch {
//            fatalError("dataset is not aplicable")
//        }
//    }
//}
