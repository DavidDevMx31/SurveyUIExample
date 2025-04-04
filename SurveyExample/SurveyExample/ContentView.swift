//
//  ContentView.swift
//  SurveyExample
//
//  Created by David Ali on 05/03/25.
//

import SwiftUI
import SurveyUI

struct ContentView: View {
    let survey: Survey
    
    var body: some View {
        SurveyView(survey: survey) { result in
            debugPrint(result)
        }
    }
}


struct MyAppTheme: SurveyTheme {
    var backgroundColor: Color? = Color("BackgroundColor")
    var foregroundColor: Color? = Color("ForegroundColor")
    
    var headlineFont = Font.headline
    var titleFont = Font.title
    var bodyFont = Font.system(size: 16, weight: .regular)
    var calloutFont = Font.callout
    
    var surveyIntroFont = Font.headline
    var questionFont = Font.title
    var optionBackgroundColor = Color(red: 0.99, green: 0.27, blue: 0.06)
    var selectedOptionForegroundColor = Color(red: 0.92, green: 0.92, blue: 0.92)
    var unselectedOptionForegroundColor = Color(red: 0.74, green: 0.78, blue: 0.75)
}
