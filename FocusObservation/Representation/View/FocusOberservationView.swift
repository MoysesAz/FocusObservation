//
//  FocusOberservationView.swift
//  FocusObservation
//
//  Created by Moyses Miranda do Vale Azevedo on 11/05/23.
//

import SwiftUI

struct FocusObservationView: View {
    let viewModel = FocusObsevationViewModel()
    @State var rectangles: [Bool] = (0..<4).map { _ in false}
    @State var pointer: Int = 1

    var body: some View {
            HStack {
                ForEach((0..<2), id: \.self) {y in
                    VStack {
                        ForEach((0..<2), id: \.self) {x in
                            let index = (y)*2 + x // calcular o índice correto ; Criar generalizacao de casos
                            Rectangle()
                                .foregroundColor(rectangles[index] ? .red : .black)
                        }
                    }
                }
            }
            .onTapGesture {
                resetRectangles()
                selectedRectangle()
                viewModel.descriptionPosisionPixel = pointer.description
                viewModel.snapShot()
                newPointer()
                // estou olhando pro quadrado anterior
            }
            .onAppear{
                resetRectangles()
                selectedRectangle()
                viewModel.setupInput()
                viewModel.setupPhotoOutput()
                viewModel.start()
            }
    }

    private func resetRectangles() {
        for i in 0..<rectangles.count {
            rectangles[i] = false
        }
    }

    private func newPointer() {
        if pointer == 3 {
            pointer = 0
            return
        }
        pointer += 1
    }

    private func selectedRectangle() {
        rectangles[pointer].toggle()
    }
}



extension ViewController {
    func extractView(view: any View) {
        let hostView = UIHostingController(rootView: FocusObservationView())
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(hostView.view)
        NSLayoutConstraint.activate([
            hostView.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostView.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
