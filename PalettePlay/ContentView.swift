//
//  ContentView.swift
//  PalettePlay
//
//  Created by Simranjeet Kaur on 12/03/24.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    
    @State private var canvas = PKCanvasView()
    @State private var showAlert = false
    var body: some View {
        NavigationView {
            
            // Canvas
            CanvasRepresentation(canvas: canvas)
                .navigationBarItems(trailing: Button(action: {
                    // Save Image to gallery
                    saveImage()
                }, label: {
                    Text("Save")
                }))
            
             .navigationBarItems(leading: Button(action: {
             // To clear the canvas
                 canvas.drawing = PKDrawing()
             }, label: {
             Text("Clear")
             }))
        }
        .navigationViewStyle(.stack)
        .alert(isPresented: $showAlert) {
            Alert(title: Text(""), message: Text("Save to Gallery"), dismissButton: .default(Text("OK")))
        }
    }
    
    
    func saveImage() {
        //get the image
        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
        // save the image
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            showAlert = true
        }
        showAlert = false
    }
}

struct CanvasRepresentation: UIViewRepresentable {
    
    var canvas: PKCanvasView
    let picker = PKToolPicker.init()
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.tool = PKInkingTool(.pen , color: .black, width: 4)
        canvas.drawingPolicy = .default
        canvas.becomeFirstResponder()
        return canvas
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        picker.addObserver(canvas)
        picker.setVisible(true, forFirstResponder: uiView)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
