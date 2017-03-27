

import Foundation
import CommandLineKit
import Rainbow


let cli = CommandLineKit.CommandLine()


let add = StringOption(shortFlag: "a", longFlag: "add",helpMessage: "添加所有变更到缓存区")
let branch = StringOption(shortFlag: "b", longFlag: "branch",helpMessage: "新建分支")
let tag = StringOption(shortFlag: "t", longFlag: "tag",helpMessage: "新建tag")
let checkout = StringOption(longFlag: "co",helpMessage: "切换分支")
let commit = StringOption(longFlag: "ci",helpMessage: "创建一个commit")

let push = BoolOption(longFlag: "push",helpMessage: "提交代码")
let pull = BoolOption(longFlag: "pull",helpMessage: "拉取代码")
let merge = StringOption(longFlag: "merge",helpMessage: "合并代码")
let stash_save = BoolOption(longFlag: "stash-save",helpMessage: "缓存变更")
let stash_pop = BoolOption(longFlag: "stash-pop",helpMessage: "恢复缓存变更")
let prune = BoolOption(longFlag: "prune",helpMessage: "清除远程仓库已经不存在的分支")
let checkout_tag = StringOption(longFlag: "co-tag",helpMessage: "从指定tag拉出分支并切换到该分支")//longFlag: "checkout"
let help = StringOption(longFlag: "help",helpMessage: "查看帮助")//longFlag: "checkout"

// git tag -l | xargs git tag -d
//git fetch  - - tags  清除本地tag，并拉取远程tag

cli.addOptions(add,branch,tag,checkout,push,pull,merge,stash_save,stash_pop,commit)

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

//operate

if add.wasSet{
    
    //print("git add \(add.value)")
    let addGiter:Giter = Giter.init(operateType: .add, param:add.value!)
    addGiter.excute()
    //print("result - \(addGiter.excute())")
    
}else if branch.wasSet{
    
    //print("branch \(branch.value!)")
    let branchGiter:Giter = Giter.init(operateType: .branch, param: branch.value!)
    branchGiter.excute()
    //print("result - \(branchGiter.excute())")
    
}else if tag.wasSet{
    
    //print("tag \(tag.value!)")
    let tagGiter:Giter = Giter.init(operateType: .tag, param: tag.value!)
    tagGiter.excute()
    //print("result - \(tagGiter.excute())")
    
}else if checkout.wasSet{
    
    //print("checkout \(checkout.value!)")
    let checkoutGiter:Giter = Giter.init(operateType: .checkOut, param: checkout.value!)
    checkoutGiter.excute()
    //print("result - \(checkoutGiter.excute())")
   
}else if commit.wasSet{
    
    //print("checkout \(checkout.value!)")
    let commitGiter:Giter = Giter.init(operateType: .commit, param: commit.value!)
    commitGiter.excute()
    //print("result - \(checkoutGiter.excute())")
    
}else if push.wasSet{
    //print("push \(push.value!)")
    let pushGiter:Giter = Giter.init(operateType: .push, param: String(push.value))
    pushGiter.excute()
    //print("result - \(pushGiter.excute())")
}else if pull.wasSet{
    //print("pull \(pull.value!)")
    let pullGiter:Giter = Giter.init(operateType: .pull, param: String(pull.value))
    pullGiter.excute()
    //print("result - \(pullGiter.excute())")
}else if merge.wasSet{
    //print("merge \(merge.value!)")
    let mergeGiter:Giter = Giter.init(operateType: .merge, param: merge.value!)
    mergeGiter.excute()
    //print("result - \(mergeGiter.excute())")
}else if stash_save.wasSet{
    //print("stash_save \(stash_save.value!)")
    let stash_saveGiter:Giter = Giter.init(operateType: .stashSave, param: String(stash_save.value))
    stash_saveGiter.excute()
    //print("result - \(stash_saveGiter.excute())")
}else if stash_pop.wasSet{
    //print("stash_pop \(stash_pop.value!)")
    let stash_popGiter:Giter = Giter.init(operateType: .stashPop, param: String(stash_pop.value))
    stash_popGiter.excute()
    //print("result - \(stash_popGiter.excute())")
}else{
    print(cli.formatOutput!)
}


