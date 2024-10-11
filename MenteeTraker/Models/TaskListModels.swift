import Foundation

struct SectionTaskList {
    let title: String
    let options: [OptionTaskList]
}

struct OptionTaskList {
    let name: String
    let status: String
    let deadline: String
    let traineeName: String
    let handler: () -> Void
}
