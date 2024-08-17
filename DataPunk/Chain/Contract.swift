import Foundation
import Web3Core
import BigInt

let dataPunkAddress = "0x65bC5ed6a981A48E2f191bdDB8FADF3317aDe9A5"

class ManagedContract {
    let address: String
    let walletAddress: String
    let chainProxy: ChainProxy
    let abi: String
    
    enum ContractError: Error {
        case invalidAddress, invalidOperation, invalidResult, walletError, abiNotFound
    }
    
    init(address contractAddress: String? = nil, walletAddress: String? = nil) throws {
        self.address = contractAddress ?? dataPunkAddress
        self.chainProxy = ChainProxy()
        
        // Load ABI
        guard let abiString = readABIString(named: "DataNFTContract") else {
            throw ContractError.abiNotFound
        }
        self.abi = abiString
        
        // Check for private keys
        if listPrivateKeys().isEmpty {
            throw ContractError.walletError
        }
        
        // Set wallet address
        if let walletAddress = walletAddress {
            self.walletAddress = walletAddress
        } else if let address = getPrivateKeyAddress() {
            self.walletAddress = address
        } else {
            throw ContractError.invalidAddress
        }
        
        // Validate contract address
        guard EthereumAddress(contractAddress!) != nil else {
            throw ContractError.invalidAddress
        }
    }
    
    // 1. 商家发布任务
    func deployTask(name: String, reward: BigUInt) async throws -> UInt {
        let params = [name, String(reward)]
        let result = try await chainProxy.writeContract(CallContractRequest(
            contractAddress: address,
            method: "deployTask",
            params: params
        ))
        
        guard let taskId = UInt(result) else {
            throw ContractError.invalidResult
        }
        
        return taskId
    }
    
    // 2. 用户提交数据集
    func uploadDataset(taskId: UInt) async throws -> UInt {
        let params = [String(taskId)]
        let result = try await chainProxy.writeContract(CallContractRequest(
            contractAddress: address,
            method: "uploadDataset",
            params: params
        ))
        
        guard let datasetId = UInt(result) else {
            throw ContractError.invalidResult
        }
        
        return datasetId
    }
    
    // 3. 验证者验证数据集
    func verifyDataset(taskId: UInt, datasetId: UInt, value: BigUInt) async throws -> Bool {
        let params = [String(taskId), String(datasetId), String(value)]
        let result = try await chainProxy.writeContract(CallContractRequest(
            contractAddress: address,
            method: "verifyDataset",
            params: params
        ))
        
        return result.lowercased() == "true"
    }
    
    // 4. 质疑数据集
    func raiseChallenge(amount: BigUInt, taskId: UInt, datasetId: UInt, challengeStatus: Bool) async throws -> Bool {
        let params = [String(amount), String(taskId), String(datasetId), challengeStatus ? "true" : "false"]
        let result = try await chainProxy.writeContract(CallContractRequest(
            contractAddress: address,
            method: "raiseChallenge",
            params: params
        ))
        
        return result.lowercased() == "true"
    }
    
    // 5. 获取任务信息
    func getTask(taskId: UInt) async throws -> DataPunkTask {
        let params = [String(taskId)]
        let result = try await chainProxy.readContract(CallContractRequest(
            contractAddress: address,
            method: "getTask",
            params: params
        ))
        
        // 假设返回的是JSON字符串,需要解析
        guard let data = result.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw ContractError.invalidResult
        }
        
        // 解析JSON并构造DataPunkTask对象
        guard let taskId = json["taskId"] as? UInt,
              let taskName = json["taskName"] as? String,
              let publisher = json["publisher"] as? String,
              let reward = json["reward"] as? String,
              let datasetsJson = json["datasets"] as? [[String: Any]] else {
            throw ContractError.invalidResult
        }
        
        let datasets = try datasetsJson.map { datasetJson -> DataPunkDataset in
            guard let datasetId = datasetJson["datasetId"] as? UInt,
                  let uploader = datasetJson["uploader"] as? String,
                  let isValidated = datasetJson["isValidated"] as? Bool,
                  let validator = datasetJson["validator"] as? String else {
                throw ContractError.invalidResult
            }
            return DataPunkDataset(datasetId: datasetId, uploader: uploader, isValidated: isValidated, validator: validator)
        }
        
        return DataPunkTask(taskId: taskId, taskName: taskName, publisher: publisher, reward: BigUInt(reward) ?? BigUInt(0), datasets: datasets)
    }
    
    // 6. 获取代币合约地址
    func getDataPunkCoinInterAddress() async throws -> String {
        let result = try await chainProxy.readContract(CallContractRequest(
            contractAddress: address,
            method: "getDataPunkCoinInterAddress",
            params: []
        ))
        
        return result
    }
}

// 辅助结构体定义
struct DataPunkTask {
    let taskId: UInt
    let taskName: String
    let publisher: String
    let reward: BigUInt
    let datasets: [DataPunkDataset]
}

struct DataPunkDataset {
    let datasetId: UInt
    let uploader: String
    let isValidated: Bool
    let validator: String
}
