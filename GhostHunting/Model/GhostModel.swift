//
//  GhostModel.swift
//  GhostHunting
//
//  Created by dary winata nugraha djati on 19/08/23.
//

import Foundation
import RealityKit
import AVFAudio

class GhostModel: Entity {
    let ghostName : String
    var entity : Entity?
    var audioPlayback : AudioPlaybackController?
    
    init(ghostName: String) {
        self.ghostName = ghostName
    }
    
    @MainActor required init() {
        fatalError("init() has not been implemented")
    }
    
    func loadEntity() {
        guard let url = Bundle.main.url(forResource: ghostName, withExtension: "usdz") else {return}
        do {
            entity = try Entity.load(contentsOf: url)
        } catch {
            print("cannot render entity")
        }
    }
    
    func getEntity() -> Entity {
        if entity == nil {
            fatalError("theres no entity yet")
        }
        
        return entity!
    }
    
    func loadAudio() {
        do {
            let audioGhost = try AudioFileResource.load(named: "\(ghostName).mp3", inputMode: .spatial, loadingStrategy: .preload, shouldLoop: true)
            if entity != nil {
                audioPlayback = entity?.prepareAudio(audioGhost)
            } else {
                print("entity is nil")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getAudio() -> AudioPlaybackController {
        if audioPlayback == nil {
            fatalError("playback is nil")
        }
        
        return audioPlayback!
    }
}
