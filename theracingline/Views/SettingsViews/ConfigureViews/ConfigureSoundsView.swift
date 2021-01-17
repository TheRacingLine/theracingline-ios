//
//  ConfigureSoundsView.swift
//  theracingline
//
//  Created by David Ellis on 17/01/2021.
//

import SwiftUI
import AVFoundation

struct ConfigureSoundsView: View {
    
    @ObservedObject var data = DataController.shared
    @ObservedObject var notifications = NotificationController.shared
    @State var audioPlayer: AVAudioPlayer!

    
    var tick = "checkmark"
    
    
    var body: some View {
        ScrollView {
            VStack {
                GroupBox(label: SettingsLabelView(labelText: "Notification Sounds", labelImage: "waveform.circle")){
                    
                    Divider().padding(.vertical, 4)

                    Button(action: {
                        data.menuHaptics()
                        data.setNotificationSound(sound: "flyby_notification_no_bell.aiff")
                        playSounds(soundName: "flyby_notification_no_bell.aiff")
                    }) {
                        if data.notificationSound == "flyby_notification_no_bell.aiff" {
                            SettingsRowView(content: "Fly-by", symbol: tick)
                        } else {
                            SettingsRowView(content: "Fly-by")
                        }
                    }
                    
                    Divider().padding(.vertical, 4)
                    
                    Button(action: {
                        data.menuHaptics()
                        data.setNotificationSound(sound: "flyby_notification_bell.aiff")
                        playSounds(soundName: "flyby_notification_bell.aiff")
                    }) {
                        if data.notificationSound == "flyby_notification_bell.aiff" {
                            SettingsRowView(content: "Fly-by with bell", symbol: tick)
                        } else {
                            SettingsRowView(content: "Fly-by with bell")
                        }
                    }
                    
                    Divider().padding(.vertical, 4)
                    
                    Button(action: {
                        data.menuHaptics()
                        data.setNotificationSound(sound: "notification_1.aiff")
                        playSounds(soundName: "notification_1.aiff")

                    }) {
                        if data.notificationSound == "notification_1.aiff" {
                            SettingsRowView(content: "Pops", symbol: tick)
                        } else {
                            SettingsRowView(content: "Pops")
                        }
                    }
                    
                    Divider().padding(.vertical, 4)
                    
                    Button(action: {
                        data.menuHaptics()
                        data.setNotificationSound(sound: "notification_2.aiff")
                        playSounds(soundName: "notification_2.aiff")
                    }) {
                        if data.notificationSound == "notification_2.aiff" {
                            SettingsRowView(content: "Bong", symbol: tick)
                        } else {
                            SettingsRowView(content: "Bong")
                        }
                    }
                    
                    Divider().padding(.vertical, 4)
                    
                    Button(action: {
                        data.menuHaptics()
                        data.setNotificationSound(sound: "notification_3.aiff")
                        playSounds(soundName: "notification_3.aiff")
                    }) {
                        if data.notificationSound == "notification_3.aiff" {
                            SettingsRowView(content: "Dings", symbol: tick)
                        } else {
                            SettingsRowView(content: "Dings")
                        }
                    }
                }
                
                GroupBox(label: SettingsLabelView(labelText: "Credits", labelImage: "person.circle")) {
                    Divider().padding(.vertical, 4)
                    SettingsDescriptionView(text: "Sound design by Sounds Good Soundworks", useBlack: true)
                    Divider().padding(.vertical, 4)
                    
                    Link(destination: URL(string: "https://soundsgoodsoundworks.com/")!) {
                        SettingsLinkView(content: "Sounds Good Sound Works", symbol: "arrow.up.right.square", linkDestination: "soundsgoodsoundworks.com")
                    }
                } //GROUPBOX
    
            } // VSTACK
            .padding(.horizontal, 20)
        } // SCROLLVIEW
        .navigationBarTitle("Notification Sounds")
    }
    
    func playSounds(soundName : String) {
            guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: nil) else {
                fatalError("Unable to find \(soundName) in bundle")
            }

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print(error.localizedDescription)
            }
            audioPlayer.play()
            notifications.rebuildNotifications()
    }

}

struct ConfigureSoundsView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigureSoundsView()
    }
}
