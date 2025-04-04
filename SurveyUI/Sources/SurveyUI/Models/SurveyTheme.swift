//
//  SurveyTheme.swift
//  
//
//  Created by David Ali on 20/03/25.
//

import SwiftUI

public protocol SurveyTheme {
    var backgroundColor: Color? { get }
    var foregroundColor: Color? { get }
    
    var surveyIntroFont: Font { get }
    var questionFont: Font { get }
    var calloutFont: Font { get }
    var bodyFont: Font { get }
    
    var optionBackgroundColor: Color { get }
    var unselectedOptionForegroundColor: Color { get }
    var selectedOptionForegroundColor: Color { get }
}

public class SurveyThemeManager {
    public static var shared: SurveyTheme = DefaultSurveyTheme()
}

struct DefaultSurveyTheme: SurveyTheme {
    var backgroundColor: Color? = Color("BackgroundColor", bundle: .module)
    var foregroundColor: Color? = Color("ForegroundColor", bundle: .module)
    
    var surveyIntroFont = Font.title2
    var questionFont = Font.title3
    var calloutFont: Font = Font.callout
    var bodyFont: Font = Font.body
    
    var optionBackgroundColor = Color.blue
    var unselectedOptionForegroundColor = Color.blue
    var selectedOptionForegroundColor = Color.white
}
