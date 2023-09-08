import Foundation

struct User: Codable {
    let id: String
    let password: String
    let nickname: String
    var image: Data?
    var watchHistory: [Video]?
    var favoriteVideos: [Video]?
    var isLoggedIn: Bool
    
    // 랜덤 닉네임 생성 메서드
    static func generateRandomNickname(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomNickname = String((0..<length).map { _ in characters.randomElement()! })
        return randomNickname
    }
    
    // 초기화 설정
    init(id: String, password: String, image: Data?, watchHistory: [Video]?, favoriteVideos: [Video]?) {
        self.id = id
        self.password = password
        self.nickname = User.generateRandomNickname(length: 8) // 8자리 랜덤 닉네임 생성
        self.image = image
        self.watchHistory = watchHistory
        self.favoriteVideos = favoriteVideos
        self.isLoggedIn = false
    }
}


