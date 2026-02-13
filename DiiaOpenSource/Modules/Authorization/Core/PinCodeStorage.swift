import Foundation
import DiiaAuthorizationPinCode

struct PinCodeStorage: PinCodeStorageProtocol {
    let storage: StoreHelper
    
    func getIncorrectPincodeAttemptsCount() -> Int? {
        return storage.getValue(forKey: .incorrectPincodeCount)
    }
    
    func saveIncorrectPincodeAttemptsCount(_ value: Int) {
        storage.save(value, type: Int.self, forKey: .incorrectPincodeCount)
    }
}
