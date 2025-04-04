//
//  OpenQuestionView.swift
//  
//
//  Created by David Ali on 21/03/25.
//

import SwiftUI

struct OpenQuestionView<T: OpenQuestionVMProtocol>: View {
    let placeholder: String
    @ObservedObject var viewModel: T
    @State private var userComments = ""
    
    var body: some View {
        TextField(placeholder, text: $userComments)
            .onSubmit {
                viewModel.saveUserComment(userComments)
            }
    }
}

/*
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
*/
