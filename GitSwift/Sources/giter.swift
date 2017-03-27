//
//  giter.swift
//  GitSwift
//
//  Created by 邱灿清 on 2017/3/24.
//
//

import Foundation
import PathKit
#if os(OSX)
    import Darwin
#elseif os(Linux)
    import Glibc
#endif
import Darwin.POSIX.stdlib

public enum GitOperateType:NSInteger {
    
    case branch = 100
    case commit
    case tag
    case checkOut
    case checkOutTag
    case merge
    
    case add = 200
    case push
    case pull
    case stashSave
    case stashPop
    
    public var description: String {
        switch self {
        case .branch:
            return "branch"
        case .commit:
            return "commit"
        case .tag:
            return "tag"
        case .checkOut:
            return "checkout"
        case .checkOutTag:
            return "checkout"
        case .push:
            return "push"
        case .pull:
            return "pull"
        case .merge:
            return "merge"
        case .add:
            return "add"
        case .stashSave:
            return "stash"
        case .stashPop:
            return "stash"
        }
    }
}

public class Giter {
    
    private var operateType:GitOperateType
    private var param:String
    required public init(operateType:GitOperateType,param:String) {
        self.operateType = operateType
        if self.operateType.rawValue >= 200 {
            self.param = ""
        }else{
            self.param = param
        }
    }
    
    public func excute() -> () {
        
        do {
            for path:Path in try Path.current.parent().children() {

                var parentGit:Bool = false
                if path.lastComponent == ".git"{
                    parentGit = true
                }
                if parentGit {
                    self.excuteGit();
                }
                
                
                
                
                if path.isDirectory {
                    var isGit:Bool = false
                    do {
                        for subPath in try path.children() {
                            if subPath.lastComponent == ".git"{
                                isGit = true
                            }
                        }
                        if isGit {
                            let bash = Process()
                            bash.launchPath = "/usr/local/bin/bash"
                            bash.arguments = ["cd",path.string]
                            bash.launch()
                            bash.waitUntilExit()
                            self.excuteGit();
                        }
                    } catch {
                        
                    }
                }
            }
        } catch {
            
        }
    }
    
    private func excuteGit()->(){
        
        let git = Process()
        let outpipe = Pipe()
        git.standardOutput = outpipe
        let errpipe = Pipe()
        git.standardError = errpipe
        git.launchPath = "/usr/bin/git"

        var arguments:[String] = []
        arguments.append(self.operateType.description)
        if self.operateType == .add {
            
            arguments.append(".")
            
        }else if self.operateType == .checkOutTag {
            
            arguments.append("-b")
            arguments.append("tag_\(self.param)")
            arguments.append(self.param)

        }else if self.operateType == .commit {
            
            if self.param.characters.count > 0 {
                arguments.append("-m")
                arguments.append(self.param)
            }
            
        }else if self.operateType == .stashSave {
            
            arguments.append("save")

        }else if self.operateType == .stashPop {

            arguments.append("pop")
            
        }else{
            if self.param.characters.count > 0 {
                arguments.append(self.param)
            }
        }
        git.arguments = arguments
        git.launch()
        
        let outdata = outpipe.fileHandleForReading.availableData
        var outputString = String(data: outdata, encoding: String.Encoding.utf8) ?? ""
        
        //let errdata = errpipe.fileHandleForReading.availableData
        //let errString = String(data: errdata, encoding: String.Encoding.utf8) ?? ""
        
        git.waitUntilExit()
        
        //if errString.characters.count > 0 {
            //print("errString: \(errString)")
            //return errString
        //}
        if outputString.characters.count > 0 {
            print("result : \(outputString)")
        }else{
            outputString = "success"
            print("result : \(outputString)")
        }
        //return outputString
    }
}
