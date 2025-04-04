//
//  SingleSelectionQuestionView.swift
//  
//
//  Created by David Ali on 21/03/25.
//

import SwiftUI

struct SingleSelectionQuestionView<T: SingleSelectionVMProtocol>: View {
    @ObservedObject var viewModel: T
    @State private var selectedId = ""
    @State private var comments: String
    @FocusState private var isInputActive: Bool
    
    init(viewModel: T) {
        self.viewModel = viewModel
        self.comments = viewModel.currentResponse.comments ?? ""
    }
    
    private var selectedOptions: [String] {
        return viewModel.currentResponse.selectedOptionsId ?? []
    }
    
    private var allowsTextOptionId: String? {
        viewModel.currentQuestion.allowTextOption?.id
    }
    
    private var showTextField: Bool {
        if let allowsTextOptionId = allowsTextOptionId {
            if selectedOptions.contains(where: { $0 == allowsTextOptionId }) {
                return true
            }
        }
        return false
    }
    
    private var disableTextField: Bool {
        if let allowsTextId = allowsTextOptionId {
            return !selectedOptions.contains(allowsTextId)
        }
        return true
    }
    
    var body: some View {
        ForEach(viewModel.currentQuestion.options) { option in
            QuestionOptionButton(title: option.description,
                    isSelected: selectedOptions.contains(option.id)) {
                withAnimation {
                    viewModel.selectOption(option.id)
                    if !option.allowsText { comments = "" }
                }
            }
            .padding(.vertical, 4)
            .scaleEffect(selectedOptions.contains(option.id) ? 0.95 : 0.9)
        }
        
        if showTextField {
            CommentTextField(placeholder: "Comparte tus comentarios",
                             commentText: $comments) {
                isInputActive = false
                viewModel.addComment(comments)
                comments = viewModel.currentResponse.comments ?? ""
            }
                .transition(.opacity)

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
