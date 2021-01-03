//
//  PrivacyPolicyView.swift
//  theracingline
//
//  Created by David Ellis on 15/11/2020.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        VStack{
            GroupBox {
                SettingsDescriptionView(text: "I don't store your data, full stop. I physically can't. I have nowhere to store it. I don't even have a database to store it. So even if you ask nicely to see your data, I have nothing to show you.")
                Divider().padding(.vertical, 4)

                SettingsDescriptionView(text: "I don't have any intermediate systems which store your data. I have no analytics in this application. Advertisements are served either on a schedule, or at random. They are not targeted.")
                Divider().padding(.vertical, 4)

                SettingsDescriptionView(text: "Payment processing is handled by Apple. I do not process your payment data. If you need to cancel your subscription you can find the option in your iCloud account.")

            } //GROUPBOX
            Spacer()
        }.padding(.horizontal, 20)
        .navigationBarTitle("Privacy Policy")
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
    }
}
