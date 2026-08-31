import SwiftUI
 
struct ContentView: View {
    @StateObject private var healthManager = HealthManager()
 
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 28))
                .foregroundColor(.green)
 
            Text("Anxolotl")
                .font(.headline)
 
            Text(healthManager.connectionStatus)
                .font(.caption2)
                .foregroundColor(.gray)
 
            if healthManager.isStreaming {
                HStack(spacing: 4) {
                    Circle()
                        .fill(healthManager.isRecording ? .green : .yellow)
                        .frame(width: 6, height: 6)
                    Text(healthManager.isRecording ? "Recording" : "Setting Up")
                        .font(.caption2)
                        .foregroundColor(healthManager.isRecording ? .green : .yellow)
                }
            }
        }
        .onAppear {
            Task {
                await healthManager.requestPermissions()
                healthManager.startStreaming()
            }
        }
    }
}
