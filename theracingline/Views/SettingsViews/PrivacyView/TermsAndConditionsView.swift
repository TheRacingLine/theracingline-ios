//
//  TermsAndConditionsView.swift
//  theracingline
//
//  Created by David Ellis on 15/11/2020.
//

import SwiftUI

struct TermsAndConditionsView: View {
    
    @StateObject var vm = ScrollToModel()
    
    var body: some View {
        ScrollView {
            VStack {
                GroupBox {
                    Text("1. Terms")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    SettingsDescriptionView(text: "By accessing theracingline app, you are agreeing to be bound by these terms of service, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these terms, you are prohibited from using or accessing this app. The materials contained in this website are protected by applicable copyright and trademark law.", useBlack: true)
                } //GROUPBOX
                GroupBox {
                    Group{
                        Text("2. Use Licence")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        Divider().padding(.vertical, 4)
                    }
                    Group {
                        SettingsDescriptionView(text: "Permission is granted to temporarily download one copy of the materials (information or software) on TheRacingLine's website for personal, non-commercial transitory viewing only. This is the grant of a licence, not a transfer of title, and under this licence you may not:", useBlack: true)
                        Divider().padding(.vertical, 4)
                        SettingsDescriptionView(text: "modify or copy the materials;", useBlack: true)
                        Divider().padding(.vertical, 4)
                        SettingsDescriptionView(text: "attempt to decompile or reverse engineer any software contained on TheRacingLine's website;", useBlack: true)
                        Divider().padding(.vertical, 4)
                        SettingsDescriptionView(text: "remove any copyright or other proprietary notations from the materials; or", useBlack: true)
                        Divider().padding(.vertical, 4)
                        SettingsDescriptionView(text: "transfer the materials to another person or 'mirror' the materials on any other server.", useBlack: true)
                        Group{
                            Divider().padding(.vertical, 4)
                            SettingsDescriptionView(text: "This licence shall automatically terminate if you violate any of these restrictions and may be terminated by TheRacingLine at any time. Upon terminating your viewing of these materials or upon the termination of this licence, you must destroy any downloaded materials in your possession whether in electronic or printed format.", useBlack: true)
                        }

                    }
                } //GROUPBOX
                GroupBox {
                    Text("3. Disclaimer")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    SettingsDescriptionView(text: "The materials on TheRacingLine's website are provided on an 'as is' basis. TheRacingLine makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.", useBlack: true)
                    
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "Further, TheRacingLine does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on its website or otherwise relating to such materials or on any sites linked to this site.", useBlack: true)
                } //GROUPBOX
                GroupBox {
                    Text("4. Limitations")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    SettingsDescriptionView(text: "In no event shall TheRacingLine or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on TheRacingLine's website, even if TheRacingLine or a TheRacingLine authorised representative has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you.", useBlack: true)
                } //GROUPBOX
                GroupBox {
                    Text("5. Accuracy of materials")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    SettingsDescriptionView(text: "The materials appearing on TheRacingLine's website could include technical, typographical, or photographic errors. TheRacingLine does not warrant that any of the materials on its website are accurate, complete or current. TheRacingLine may make changes to the materials contained on its website at any time without notice. However TheRacingLine does not make any commitment to update the materials.", useBlack: true)
                } //GROUPBOX
                GroupBox {
                    Text("6. Links")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    SettingsDescriptionView(text: "TheRacingLine has not reviewed all of the sites linked to its website and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by TheRacingLine of the site. Use of any such linked website is at the user's own risk.", useBlack: true)
                } //GROUPBOX
                GroupBox {
                    Text("7. Modifications")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    SettingsDescriptionView(text: "TheRacingLine may revise these terms of service for its website at any time without notice. By using this website you are agreeing to be bound by the then current version of these terms of service.", useBlack: true)
                } //GROUPBOX
                GroupBox {
                    Text("8. Governing Law")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                    SettingsDescriptionView(text: "These terms and conditions are governed by and construed in accordance with the laws of United Kingdom and you irrevocably submit to the exclusive jurisdiction of the courts in that State or location.", useBlack: true)
                } //GROUPBOX
            }.padding(.horizontal, 20)
            .navigationBarTitle("Terms & Conditions")
        }
    }
}

struct TermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditionsView()
    }
}

class ScrollToModel: ObservableObject {
    enum Action {
        case end
        case top
    }
    @Published var direction: Action? = nil
}
