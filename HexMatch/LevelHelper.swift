//
//  LevelHelper.swift
//  HexMatch
//
//  Created by Josh McKee on 1/14/16.
//  Copyright © 2016 Josh McKee. All rights reserved.
//

import Foundation

class LevelHelper: NSObject {
    // singleton
    static let instance = LevelHelper()
    
    // Distribution of random piece values. Piece value is index in array, array member value is the pct chance the index will be selected.
    let distribution = [50, 30, 20]

    func initLevel(width: Int, _ height: Int) -> HexMap {
        let hexMap = HexMap(width, height)
        
        var targetCell: HexCell? = nil
        
        // Void out some cells
        for _ in 0...5 {
            // Find an empty, valid targe cell
            while (targetCell == nil || (targetCell != nil && targetCell!.isVoid)) {
                // pick a random coordinate
                let x = Int(arc4random_uniform(UInt32(width)))
                let y = Int(arc4random_uniform(UInt32(height)))
                
                // Get the cell
                targetCell = hexMap.cell(x,y)
            }
            
            targetCell!.isVoid = true
        }
        
        // Place some initial pieces
        for _ in 0...10 {
            // Find an empty, valid targe cell
            while (targetCell == nil || (targetCell != nil && targetCell!.hexPiece != nil) || (targetCell != nil && targetCell!.isVoid)) {
                // pick a random coordinate
                let x = Int(arc4random_uniform(UInt32(width)))
                let y = Int(arc4random_uniform(UInt32(height)))
                
                // Get the cell
                targetCell = hexMap.cell(x,y)
            }
            
            // Load the piece in to the cell
            targetCell!.hexPiece = self.getRandomPiece()
        }
        
        return hexMap
    }
    
    func getRandomPiece() -> HexPiece {
        // Create a new hexPiece
        let hexPiece = HexPiece()
        
        // Assign a random value
        let randomValue = Int(arc4random_uniform(100))
        
        // Start our distribution accumulator off with the first value in the set
        var distributionIndex = 0
        var distributionCurrentValue = self.distribution[distributionIndex]
        var distributionAccumulatedValue = distributionCurrentValue
        
        // Iterate over our distribution set, until our accumulated value exceeds the random value that was selected.
        while (distributionIndex < self.distribution.count-1 && distributionAccumulatedValue < randomValue) {
            distributionCurrentValue = self.distribution[++distributionIndex]
            distributionAccumulatedValue += distributionCurrentValue
        }
        
        // Use the index of whatever value our loop ended at as the value of the new piece
        hexPiece.value = distributionIndex
        
        return hexPiece
    }

}