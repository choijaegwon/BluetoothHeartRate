//
//  ContentView.swift
//  BLEHeartRate
//
//  Created by Jae kwon Choi on 2023/04/15.
//

import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = HRViewModel()

    var body: some View {
        VStack {
            Text(viewModel.BLElocation)
                .font(.system(size: 40))
            Text("\(viewModel.BLEHeartRate)")
                .font(.system(size: 60))
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
