import XCTest
import Contract

class EncryptionTests: XCTestCase {
    var key: SymmetricKey!

    override func setUp() {
        super.setUp()
        key = SymmetricKey(size: .bits256)
    }

    override func tearDown() {
        key = nil
        super.tearDown()
    }

    func testEncryptAndDecryptFile() throws {
        // 创建测试文件
        let testFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("testFile.txt")
        let encryptedFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("testFile.encrypted")
        let decryptedFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("testFile.decrypted")

        try "Hello, World!".data(using: .utf8)?.write(to: testFileURL)

        // 测试加密
        try encryptFile(atPath: testFileURL.path, using: key, outputPath: encryptedFileURL.path)
        XCTAssertTrue(FileManager.default.fileExists(atPath: encryptedFileURL.path))

        // 测试解密
        try decryptFile(atPath: encryptedFileURL.path, using: key, outputDecryptedPath: decryptedFileURL.path)
        XCTAssertTrue(FileManager.default.fileExists(atPath: decryptedFileURL.path))

        // 验证解密后的文件内容是否与原始文件相同
        let originalData = try Data(contentsOf: testFileURL)
        let decryptedData = try Data(contentsOf: decryptedFileURL)
        XCTAssertEqual(originalData, decryptedData, "Decrypted data does not match the original data")
    }
}