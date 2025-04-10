//
//  Divider.swift
//  
//
//  Created by David Ali on 21/03/25.
//

import SwiftUI

struct Divider: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        
        return path
    }
}
