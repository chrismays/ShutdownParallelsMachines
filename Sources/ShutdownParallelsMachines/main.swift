import Foundation
import Basic

let tempFile = "/tmp/vmlist.txt"
let path = "\(NSTemporaryDirectory())temp.txt"

func getListOfRunningMachines() -> String {
    do {
        let task = Process(arguments: ["prlctl", "list", "-o", "uuid"])
        try task.launch()
        let result = try task.waitUntilExit()
        return try result.utf8Output()
    } catch {
        print("Cannot list the currently running virtual machines")
    }
    
    return ""
}

func stop(virtualMachine: String) {
    do {
        let uuid = virtualMachine.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "")
        let task = Process(arguments: ["prlctl", "stop", uuid])
        try task.launch()
        try task.waitUntilExit()
    } catch {
        print("Cannot stop the virtual machine with UUID \(virtualMachine)")
    }
}

let output = getListOfRunningMachines()

var machines = output.split(separator: "\n")
if machines.count > 0 {
    machines.remove(at: 0)
}
for machine in machines {
    stop(virtualMachine: machine.description)
}
