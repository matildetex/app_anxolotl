import Foundation
import HealthKit
import WatchKit
import WatchConnectivity
import CoreMotion
import Combine

class HealthManager: NSObject, ObservableObject, WCSessionDelegate, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {

    @Published var isStreaming: Bool = false
    @Published var isRecording: Bool = false
    @Published var connectionStatus: String = "A ligar..."

    private let healthStore = HKHealthStore()
    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?
    private var wcSession: WCSession?

    // Acelerómetro
    private let motionManager = CMMotionManager()
    private let motionQueue = OperationQueue()

    override init() {
        super.init()
        if WCSession.isSupported() {
            wcSession = WCSession.default
            wcSession?.delegate = self
            wcSession?.activate()
        }
    }

    //Permissions

    func requestPermissions() async {
        let typesToShare: Set<HKSampleType> = [
            HKObjectType.workoutType()
        ]
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        ]
        try? await healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead)
    }

    //Start Streaming

    func startStreaming() {
        guard !isStreaming else { return }
        startWorkoutSession()
        startAccelerometer()
    }

    //Workout Session (HR, steps, calories, distance)

    private func startWorkoutSession() {
        let config = HKWorkoutConfiguration()
        config.activityType = .other
        config.locationType = .unknown

        do {
            let session = try HKWorkoutSession(healthStore: healthStore, configuration: config)
            let builder = session.associatedWorkoutBuilder()

            session.delegate = self
            builder.delegate = self
            builder.dataSource = HKLiveWorkoutDataSource(
                healthStore: healthStore,
                workoutConfiguration: config
            )

            self.workoutSession = session
            self.workoutBuilder = builder

            session.startActivity(with: Date())
            builder.beginCollection(withStart: Date()) { success, _ in
                if success {
                    DispatchQueue.main.async { self.isStreaming = true }
                }
            }
        } catch {
            print("Erro ao iniciar workout session: \(error)")
        }
    }

    //Acelerómetro (25Hz)
    private func startAccelerometer() {
        guard motionManager.isAccelerometerAvailable else {
            print("Acelerómetro não disponível")
            return
        }

        motionManager.accelerometerUpdateInterval = 1.0 / 25.0

        var batch: [[String: Any]] = []

        motionManager.startAccelerometerUpdates(to: motionQueue) { [weak self] data, error in
            guard let self = self, let data = data else { return }

            batch.append([
                "x": data.acceleration.x,
                "y": data.acceleration.y,
                "z": data.acceleration.z,
                "t": Date().timeIntervalSince1970
            ])

            if batch.count >= 5 {
                self.sendToPhone(data: ["acc_batch": batch])
                batch = []
            }
        }
    }

    //HKWorkoutSessionDelegate

    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState,
                        date: Date) {
        DispatchQueue.main.async {
            self.isStreaming = (toState == .running)
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didFailWithError error: Error) {
        print("Workout session error: \(error)")
    }

    //HKLiveWorkoutBuilderDelegate

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {}

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder,
                        didCollectDataOf collectedTypes: Set<HKSampleType>) {

        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { continue }

            let stats = workoutBuilder.statistics(for: quantityType)
            var data: [String: Any] = ["timestamp": Date().timeIntervalSince1970]

            switch quantityType.identifier {
            case HKQuantityTypeIdentifier.heartRate.rawValue:
                if let value = stats?.mostRecentQuantity()?.doubleValue(for: HKUnit(from: "count/min")) {
                    data["hr"] = value
                    data["ibi"] = value > 0 ? (60.0 / value) * 1000 : 0
                }
            case HKQuantityTypeIdentifier.stepCount.rawValue:
                if let value = stats?.sumQuantity()?.doubleValue(for: .count()) {
                    data["steps"] = value
                }
            case HKQuantityTypeIdentifier.activeEnergyBurned.rawValue:
                if let value = stats?.sumQuantity()?.doubleValue(for: .kilocalorie()) {
                    data["calories"] = value
                }
            case HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue:
                if let value = stats?.sumQuantity()?.doubleValue(for: .meter()) {
                    data["distance"] = value
                }
            default:
                continue
            }

            if data.count > 1 {
                sendToPhone(data: data)
            }
        }
    }

    //WatchConnectivity

    private func sendToPhone(data: [String: Any]) {
        guard let session = wcSession, session.isReachable else {
            try? wcSession?.updateApplicationContext(data)
            return
        }
        session.sendMessage(data, replyHandler: nil, errorHandler: nil)
    }

    func session(_ session: WCSession,
                 didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            if let recording = message["recording"] as? Bool {
                self.isRecording = recording
            }
        }
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        DispatchQueue.main.async {
            self.connectionStatus = activationState == .activated ? "On" : "Off"
        }
    }
}
