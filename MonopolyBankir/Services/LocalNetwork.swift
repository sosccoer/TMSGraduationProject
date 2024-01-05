import Foundation
import Network
import Combine
import UIKit

let sendGameModel = PassthroughSubject <GameModel, Never>()
let sendToScreen = PassthroughSubject <String, Never>()
let refreshScreen = PassthroughSubject <Bool, Never>()
let typeOfPlayerLocal = PassthroughSubject <TypeOfPlayer, Never>()

class LocalNetworkService: ObservableObject {
    public static let shared = LocalNetworkService()
    @Published var browser: NWBrowser?
    
    @Published var listener: NWListener?
    @Published var connections = [NWConnection]()
    
    var connection: NWConnection?
    var endpoints: [NWEndpoint] = []
    //    private var queue: DispatchQueue
    var connectionName = "_monopoly._tcp"
    
    private var backgroundQueueUdpListener = DispatchQueue(label: "udp-lis.bg.queue", attributes: [])
    private var backgroundQueueUdpConnection = DispatchQueue(label: "udp-con.bg.queue", attributes: [])
    private var backgroundQueueUdpBrowser = DispatchQueue(label: "udp-bro.bg.queue", attributes: [])
    
    private init() {//name: String
        let name = UUID()
        self.connectionName = "_monopoly._tcp"
        
        
        // MARK: Init Listeners
        do {
            self.listener = try NWListener(using: .tcp)
            listener?.service = NWListener.Service(name: "\(name)", type: connectionName)
            
            self.listener?.stateUpdateHandler = { listenerState in
                print("👂🏼👂🏼👂🏼 NWListener Handler called")
                switch listenerState {
                case .ready:
                    print("Listener: ✅ Ready and listens on port: \(self.listener?.port?.debugDescription ?? "-")")
                case .failed(let error):
                    print("Listener: Failed \(error)")
                    self.listener = nil
                case .cancelled:
                    print("Listener: 🛑 Cancelled by myOffButton")
                    for connection in self.connections {
                        connection.cancel()
                    }
                    DispatchQueue.main.async {
                        self.listener = nil
                    }
                default:
                    break
                }
            }
            
            self.listener?.start(queue: backgroundQueueUdpListener)
            self.listener?.newConnectionHandler = { incomingUdpConnection in
                print("📞📞📞 NWConnection Handler called ")
                incomingUdpConnection.stateUpdateHandler = { udpConnectionState in
                    switch udpConnectionState {
                    case .ready:
                        print("Connection: ✅ ready")
                        self.connections.append(incomingUdpConnection)
                        self.receiveData(incomingUdpConnection)
                    case .failed(let error):
                        print("Connection: 🔥 failed: \(error)")
                        self.connections.removeAll(where: { incomingUdpConnection === $0 })
                    case .cancelled:
                        print("Connection: 🛑 cancelled")
                        self.connections.removeAll(where: { incomingUdpConnection === $0 })
                    default:
                        break
                    }
                }
                
                incomingUdpConnection.start(queue: self.backgroundQueueUdpConnection)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        // MARK: Init Browser
        self.browser = NWBrowser(for: .bonjour(type: connectionName, domain: "local"), using: .tcp)
        setupBrowserHandlers(for: browser!)
        
        // MARK: Start NWs
        browser?.start(queue: backgroundQueueUdpBrowser)
    }
    deinit {
        self.browser?.cancel()
        self.connection?.cancel()
        self.listener?.cancel()
        browser = nil
        listener = nil
    }
    
    func restartLocalNW(name: String) {
        self.connectionName = "_monopoly._tcp"
        
        UserDefaults.standard.setValue(name, forKey: User.name)
        
        // MARK: Init Listeners
        do {
            self.listener = try NWListener(using: .tcp)
            listener?.service = NWListener.Service(name: "\(name)", type: connectionName)
            
            self.listener?.stateUpdateHandler = { listenerState in
                print("👂🏼👂🏼👂🏼 NWListener Handler called")
                switch listenerState {
                case .ready:
                    print("Listener: ✅ Ready and listens on port: \(self.listener?.port?.debugDescription ?? "-")")
                case .failed(let error):
                    print("Listener: Failed \(error)")
                    self.listener = nil
                case .cancelled:
                    print("Listener: 🛑 Cancelled by myOffButton")
                    for connection in self.connections {
                        connection.cancel()
                    }
                    DispatchQueue.main.async {
                        self.listener = nil
                    }
                default:
                    break
                }
            }
            
            self.listener?.start(queue: backgroundQueueUdpListener)
            self.listener?.newConnectionHandler = { incomingUdpConnection in
                print("📞📞📞 NWConnection Handler called ")
                incomingUdpConnection.stateUpdateHandler = { udpConnectionState in
                    switch udpConnectionState {
                    case .ready:
                        print("Connection: ✅ ready")
                        self.connections.append(incomingUdpConnection)
                        self.receiveData(incomingUdpConnection)
                    case .failed(let error):
                        print("Connection: 🔥 failed: \(error)")
                        self.connections.removeAll(where: { incomingUdpConnection === $0 })
                    case .cancelled:
                        print("Connection: 🛑 cancelled")
                        self.connections.removeAll(where: { incomingUdpConnection === $0 })
                    default:
                        break
                    }
                }
                
                incomingUdpConnection.start(queue: self.backgroundQueueUdpConnection)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        // MARK: Init Browser
        self.browser = NWBrowser(for: .bonjour(type: connectionName, domain: "local"), using: .tcp)
        setupBrowserHandlers(for: browser!)
        
        // MARK: Start NWs
        browser?.start(queue: backgroundQueueUdpBrowser)
        
    }
    /**
     This function is restart listener
     
     - warning: Use this only in case that you need to restart listener
     
     # Example #
     ```
     // Use this when app go to background scene phase
     ```
     
     */
    func restartListener() {
        self.listener?.cancel()
        do {
            self.listener = try NWListener(using: .tcp)
            // listener?.service = NWListener.Service(type: connectionName)
            listener?.service = NWListener.Service(name: UIDevice.current.name, type: connectionName)
            
            self.listener?.stateUpdateHandler = { (listenerState) in
                print("👂🏼👂🏼👂🏼 NWListener Handler called")
                switch listenerState {
                case .setup:
                    print("Listener: Setup")
                case .waiting(let error):
                    print("Listener: Waiting \(error)")
                case .ready:
                    print("Listener: ✅ Ready and listens on port: \(self.listener?.port?.debugDescription ?? "-")")
                case .failed(let error):
                    print("Listener: Failed \(error)")
                    self.listener = nil
                case .cancelled:
                    print("Listener: 🛑 Cancelled by myOffButton")
                    for connection in self.connections {
                        connection.cancel()
                    }
                    self.listener = nil
                default:
                    break;
                    
                }
            }
            
            self.listener?.start(queue: backgroundQueueUdpListener)
            self.listener?.newConnectionHandler = { (incomingUdpConnection) in
                print("📞📞📞 NWConnection Handler called ")
                incomingUdpConnection.stateUpdateHandler = { (udpConnectionState) in
                    
                    switch udpConnectionState {
                    case .setup:
                        print("Connection: 👨🏼‍💻 setup")
                    case .waiting(let error):
                        print("Connection: ⏰ waiting: \(error)")
                    case .ready:
                        print("Connection: ✅ ready")
                        self.connections.append(incomingUdpConnection)
                        self.receiveData(incomingUdpConnection)
                    case .failed(let error):
                        print("Connection: 🔥 failed: \(error)")
                        self.connections.removeAll(where: {incomingUdpConnection === $0})
                    case .cancelled:
                        print("Connection: 🛑 cancelled")
                        self.connections.removeAll(where: {incomingUdpConnection === $0})
                    default:
                        break
                    }
                }
                
                incomingUdpConnection.start(queue: self.backgroundQueueUdpConnection)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func receiveData(_ incomingUdpConnection: NWConnection) {
        incomingUdpConnection.receiveMessage { [weak self] (data, context, isComplete, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Receive error: \(error)")
                incomingUdpConnection.cancel()
                self.connections.removeAll(where: { incomingUdpConnection === $0 })
                return
            }
            
            if let data = data, !data.isEmpty {
                
                var typeOfPlayer: TypeOfPlayer = .guest
                if let data = UserDefaults.standard.value(forKey: User.typeOfPlayer) {
                    
                    typeOfPlayer = (try? JSONDecoder().decode(TypeOfPlayer.self, from: data as! Data)) ?? TypeOfPlayer.guest
                    print(typeOfPlayer)
                }
                
                
                
                if let stringData = String(data: data, encoding: .utf8){
                    DispatchQueue.main.async {
                        Coder().decoder(dataString: stringData)
                    }
                    
                }
                
            }
            
            if isComplete {
                incomingUdpConnection.cancel()
                self.connections.removeAll(where: { incomingUdpConnection === $0 })
            } else {
                self.receiveData(incomingUdpConnection)
            }
        }
    }
    
    private func findDeviceName(in string: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Za-z]+[0-3]")
            let range = NSRange(location: 0, length: string.utf16.count)
            
            if let match = regex.firstMatch(in: string, options: [], range: range) {
                let startIndex = string.index(string.startIndex, offsetBy: match.range.location)
                let endIndex = string.index(startIndex, offsetBy: match.range.length)
                let extractedString = String(string[startIndex..<endIndex])
                return extractedString
            }
        } catch {
            print("Invalid regular expression pattern.")
        }
        return "Invalid device name"
    }
    
    func restartBrowser() -> Bool {
        self.browser?.cancel()
        browser = NWBrowser(for: .bonjour(type: connectionName, domain: "local"), using: .tcp)
        setupBrowserHandlers(for: browser ?? NWBrowser(for: .bonjour(type: connectionName, domain: "local"), using: .tcp))
        browser?.start(queue: backgroundQueueUdpBrowser)
        return true
    }
    
    private func setupBrowserHandlers(for browser: NWBrowser) {
        // MARK: Browser handlers
        browser.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                print("Browser is ready")
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled:
                print("Browser is cancelled")
            case .waiting:
                print("Browser is waiting")
            case .setup:
                print("Browser is setup")
            @unknown default:
                break
            }
        }
        
        browser.browseResultsChangedHandler = { results, changes in
            // control changes
            for change in changes {
                print(change)
            }
            //
            for result in results {
                if case .service = result.endpoint {
                    print(self.findDeviceName(in: result.endpoint.debugDescription))
                    print(result)
                }
                DispatchQueue.main.async {
                    changeCountOfBrowser.send(true)
                }
            }
        }
    }
    
    func send(string: String) {
        let data = Data(string.utf8)
        let endpoints = browser?.browseResults
        
        endpoints?.forEach { result in
            let connection = NWConnection(to: result.endpoint, using: .tcp)
            connection.send(content: data, completion: .contentProcessed { error in
                if error != nil {
                    print("Send Error FROM SEND")
                }
            })
            connection.start(queue: backgroundQueueUdpConnection)
            connection.stateUpdateHandler = { newState in
                switch newState {
                case .ready:
                    connection.cancel()
                default:
                    break
                }
            }
        }
    }
    
    func changeListenerName(name: String) {
        let service = NWListener.Service(name: name, type: connectionName)
        self.listener?.service = service
    }
    
    func startDeinit() {
        self.browser?.cancel()
        self.connection?.cancel()
        self.listener?.cancel()
    }
    
}

extension LocalNetworkService {
    func getArrayOfUsers() -> [String] {
        var arrayOfUsers: [String] = []
        self.browser?.browseResults.forEach({ result in
            let name = getCorrectName(name: result.endpoint.debugDescription)
            arrayOfUsers.append(name)
        })
        return arrayOfUsers
    }
    func getCorrectName(name: String) -> String {
        var correctName = ""
        if let dotIndex = name.firstIndex(of: ".") {
            correctName = String(name.prefix(upTo: dotIndex))
        }
        return correctName
    }
}

enum User {
    static let name = "nameOfPlayer"
    static let typeOfPlayer = "typeOfPlayer"
}
