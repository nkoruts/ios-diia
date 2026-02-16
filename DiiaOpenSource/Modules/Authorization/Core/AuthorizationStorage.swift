import Foundation
import DiiaAuthorization

// TODO: - REMOVE UNUSED METHODS
struct AuthorizationStorage: AuthorizationStorageProtocol {
    let storage: StoreHelper

    func getHashedPincode() -> String? {
        return storage.getValue(forKey: .authPincode)
    }

    func saveHashedPincode(_ value: String?) {
        storage.save(value, type: String?.self, forKey: .authPincode)
    }

    func getAuthToken() -> String? {
        return nil
    }

    func saveAuthToken(_ value: String?) { }

    func getLogoutToken() -> String? {
        nil
    }

    func saveLogoutToken(_ value: String) { }

    func removeLogoutToken() { }

    func getLastPincodeDate() -> Date? {
        return storage.getValue(forKey: .lastPincodeDate)
    }

    func saveLastPincodeDate(_ value: Date) {
        storage.save(value, type: Date.self, forKey: .lastPincodeDate)
    }

    func removeLastPincodeDate() {
        storage.removeValue(forKey: .lastPincodeDate)
    }
}

// MARK: - Service authorization storage
extension AuthorizationStorage {
    func getServiceToken() -> String? {
        log("The app doesn't support Service authorization, so fetching result will be replaced by nil stub for method \(#function)")
        return nil
    }

    func saveServiceToken(_ value: String?) {
        log("The app doesn't support Service authorization, so saving operation will be ignored for method \(#function)")
    }

    func getServiceLogoutToken() -> String? {
        log("The app doesn't support Service authorization, so fetching result will be replaced by nil stub for method \(#function)")
        return nil
    }

    func saveServiceLogoutToken(_ value: String) {
        log("The app doesn't support Service authorization, so saving operation will be ignored for method \(#function)")
    }

    func removeServiceLogoutToken() {
        log("The app doesn't support Service authorization, so saving operation will be ignored for method \(#function)")
    }
}
