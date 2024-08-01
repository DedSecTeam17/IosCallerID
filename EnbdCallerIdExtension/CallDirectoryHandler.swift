import CallKit


class CallDirectoryHandler: CXCallDirectoryProvider {
    
    
    let jsonFilerManager: JSONFileManager =  JSONFileManager()
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self
        
        guard let numbers = jsonFilerManager.loadNumbersFromJSON() else {
                  print("Failed to load numbers from JSON.")
                  context.completeRequest()
                  return
              }
        
              for number in numbers {
                  if let phoneNumberString = number["phoneNumber"], let label = number["label"], let phoneNumber = CXCallDirectoryPhoneNumber(phoneNumberString) {
                      print("PHONE NUMBER : \(phoneNumber) LABEL: \(label)")
    
                      context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
                  } else {
                      print("Invalid phone number or label in JSON: \(number)")
                  }
              }
        context.completeRequest()
    }
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {
    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        print("Request failed: \(error.localizedDescription)")
    }
}

extension CXCallDirectoryPhoneNumber {
    init?(_ string: String) {
        if let number = UInt64(string) {
            self.init(number)
        } else {
            return nil
        }
    }
}
