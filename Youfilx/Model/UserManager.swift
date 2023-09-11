import Foundation



// User 객체를 UserDefaults에 저장하는 메서드
func saveUserToUserDefaults(user: User) {
    let userDefaults = UserDefaults.standard
    do {
        let encoder = JSONEncoder()
        let userData = try encoder.encode(user)
        userDefaults.set(userData, forKey: "user")
    } catch {
        print("User 객체를 저장하는 데 실패함.")
    }
}

// UserDefaults에서 User 객체를 로드하는 메서드
func loadUserFromUserDefaults() -> User? {
    let userDefaults = UserDefaults.standard
    if let userData = userDefaults.data(forKey: "user") {
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(User.self, from: userData)
            return user
        } catch {
            print("User 객체를 불러오는데 실패함")
        }
    }
    return nil
}

func initializeUserDefaults(id: String, password: String, image: Data?, watchHistory: [Video]?, favoriteVideos: [Video]?) {
    let user = User(id: id, password: password, image: image, watchHistory: watchHistory, favoriteVideos: favoriteVideos)
    saveUserToUserDefaults(user: user)
}



