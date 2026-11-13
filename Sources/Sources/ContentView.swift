import SwiftUI

struct ContentView: View {

    var body: some View {
        ZStack {

            // Metal graphics background
            MetalView()
                .ignoresSafeArea()

            // Main interface
            VStack(spacing: 25) {

                Spacer()

                Text("BEAST")
                    .font(.system(
                        size: 48,
                        weight: .black
                    ))
                    .foregroundColor(.green)

                Text("FPS LAB")
                    .font(.title2.bold())
                    .foregroundColor(.white)

                Text("TACTICAL TRAINING SYSTEM")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                Button {
                    print("Training started")
                } label: {
                    Text("START TRAINING")
                        .font(.headline.bold())
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }

                Button("SETTINGS") {
                    print("Settings opened")
                }
                .foregroundColor(.white)

                Spacer()

                Text("BUILD 0.1.0 | METAL ENGINE")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(30)
        }
        .preferredColorScheme(.dark)
    }
}
