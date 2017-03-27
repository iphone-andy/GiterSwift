

import Foundation
import CommandLineKit
import Rainbow


let cli = CommandLineKit.CommandLine()


let add = StringOption(shortFlag: "a", longFlag: "add",helpMessage: "添加所有变更到缓存区")
let branch = StringOption(shortFlag: "b", longFlag: "branch",helpMessage: "新建分支")
let tag = StringOption(shortFlag: "t", longFlag: "tag",helpMessage: "新建tag")
let checkout = StringOption(longFlag: "co",helpMessage: "切换分支")//longFlag: "checkout"
let push = StringOption(longFlag: "push",helpMessage: "提交代码")
let pull = StringOption(longFlag: "pull",helpMessage: "拉取代码")
let merge = StringOption(longFlag: "merge",helpMessage: "合并代码")
let stash_save = StringOption(longFlag: "stash-save",helpMessage: "缓存变更")
let stash_pop = StringOption(longFlag: "stash-pop",helpMessage: "恢复缓存变更")


cli.addOptions(add, branch, tag, checkout,push,pull,merge,stash_save,stash_pop)

cli.formatOutput = { s, type in
    var str: String
    switch(type) {
    case .error:
        str = s.red.bold
    case .optionFlag:
        str = s.green.underline
    case .optionHelp:
        str = s.blue
    default:
        str = s
    }
    
    return cli.defaultFormat(s: str, type: type)
}

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

print("add \(add.value!)")

let addGiter:Giter = Giter.init(operateType: .add, param: add.value!)

print("result - \(addGiter.excute())")


