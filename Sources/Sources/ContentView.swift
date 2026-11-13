import SwiftUI

struct ContentView: View {

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {

                Text("BEAST FPS LAB")
                    .font(.largeTitle.bold())
                    .foregroundColor(.green)

                Text("MOBILE FPS TRAINING SYSTEM")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                Button("START TRAINING") {
                    print("Training started")
                }
                .font(.headline)
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(12)

                Button("SETTINGS") {
                    print("Settings opened")
                }
                .foregroundColor(.white)

                Spacer()

                Text("VERSION 0.1.0")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(25)
        }
    }
}
