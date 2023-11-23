//
//  ZeusError.swift
//  Zeus
//
//  Created by 罗树新 on 2023/11/14.
//

import Foundation

public enum ZeusError: Error {
    
    /// Response 结果错误
    public enum ResponseError: Error {
        
        /// 解析 keys 错误
        case parsingKeysFailed(String)
    }
}
