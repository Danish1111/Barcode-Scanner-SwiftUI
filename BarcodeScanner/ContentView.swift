//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Danish on 18/06/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var scannedCode: String? = "Not Yet Scanned"

    var body: some View {
        

        VStack {
            
            HStack{
                
                Text("Barcode Scanner")
                    .font(.largeTitle)
                   
                Spacer()

            } .padding(20)
            
            Spacer()
            
            CameraView(scannedCode: $scannedCode)
                .frame(height: 220)
                .padding(.bottom, 50)
            
            
            HStack{
                Image(systemName: "barcode.viewfinder")
                Text("Barcode Scanner")
            }
            .padding(.bottom, 50)

                        
            Text(scannedCode!)
                .font(.largeTitle)
                .foregroundColor(.red)
                .fontWeight(.bold)
            
            Spacer()



        }
        
    }
}

#Preview {
    ContentView()
}
