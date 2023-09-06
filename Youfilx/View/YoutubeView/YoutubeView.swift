//
//  YoutubeView.swift
//  Youfilx
//
//  Created by hong on 2023/09/05.
//

import UIKit
import WebKit

public enum YoutubeViewState: String {
    case notStart = "-1"
    case end = "0"
    case playing = "1"
    case pause = "2"
    case buffering = "3"
    case `null` = "null"
}

public class YoutubeView: UIView {
    
    private enum YoutubeViewError: LocalizedError {
        case jsonToStringErrorOcurred
    }

    private lazy var webView: WKWebView = prepareWKWebView()
    
    private var playerVars: [String: AnyObject] = [
        "autoplay": 0 as AnyObject,
        "mute": 0 as AnyObject,
        "loop": 0 as AnyObject,
        "controls": 1 as AnyObject,
        "cc_load_policy": 0 as AnyObject,
        "start": 0 as AnyObject,
        "rel": 0 as AnyObject
    ]
    
    private var playerCallBacks: [String: AnyObject] = [
        "onReady": "onReady" as AnyObject,
        "onStateChange": "onStateChange" as AnyObject,
        "onPlaybackQualityChange": "onPlaybackQualityChange" as AnyObject,
        "onError": "onPlayerError" as AnyObject
    ]

    public var state: ((YoutubeViewState) -> Void)? = nil
    
    public init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func loadYoutube(videoId: String, startTime: Int = 0, isAutoPlay: Bool = false) {
        do {
            let youtubeHTML = try loadYoutubeHTML(
                videoId: videoId,
                startTime: startTime,
                isAutoPlay: isAutoPlay
            )
            webView.loadHTMLString(youtubeHTML, baseURL: URL(string: "about:blank"))
        } catch {
            print(error)
        }
    }
    
    private func prepareWKWebView() -> WKWebView {
        let wkWebViewConfiguration = WKWebViewConfiguration()
        wkWebViewConfiguration.allowsInlineMediaPlayback = true
        wkWebViewConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = true
        let wkWebView = WKWebView(frame: frame, configuration: wkWebViewConfiguration)
        wkWebView.scrollView.isScrollEnabled = false
        wkWebView.allowsBackForwardNavigationGestures = true
        wkWebView.allowsLinkPreview = true
        wkWebView.backgroundColor = .clear
        wkWebView.navigationDelegate = self
        self.addSubview(wkWebView)
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wkWebView.topAnchor.constraint(equalTo: self.topAnchor),
            wkWebView.leftAnchor.constraint(equalTo: self.leftAnchor),
            wkWebView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            wkWebView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
        return wkWebView
    }
    
    private func htmlPath() -> String {
        return Bundle(for: YoutubeView.self).path(forResource: "YoutubePlayer", ofType: "html") ?? ""
    }
    
    private func playerParameters(_ videoId: String) -> [String: AnyObject] {
        return [
            "height": "100%" as AnyObject,
            "width": "100%" as AnyObject,
            "videoId": videoId as AnyObject,
            "events": playerCallBacks as AnyObject,
            "playerVars": playerVars as AnyObject
        ]
    }
    
    private func startTimeSetting(_ time: Int) {
        playerVars["start"] = time as AnyObject
    }
    
    private func autoPlaySetting() {
        playerVars["autoplay"] = 1 as AnyObject
        playerVars["mute"] = 1 as AnyObject
    }
    
    private func jsonString(object: AnyObject) throws -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            guard let jsonText = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) else {
                throw YoutubeViewError.jsonToStringErrorOcurred
            }
            return jsonText as String
        } catch {
            throw error
        }
    }
    
    private func loadYoutubeHTML(
        videoId: String,
        startTime: Int = 0,
        isAutoPlay: Bool = false
    ) throws -> String {
        do {
            var rawHTMLString = try NSString(contentsOfFile: htmlPath(), encoding: String.Encoding.utf8.rawValue) as String
            startTimeSetting(startTime)
            if isAutoPlay {
                autoPlaySetting()
            }
            let jsonText = try jsonString(object: playerParameters(videoId) as AnyObject)
            rawHTMLString = rawHTMLString.replacingOccurrences(of: "%@", with: jsonText)
            return rawHTMLString
        } catch {
            throw error
        }
    }
    
    public func getCurrentTime(completion: ((Double) -> Void)? = nil) {
        evaluateJavaScript(command: "getCurrentTime()") { result in
            if let result = result as? Double {
                completion?(result)
            }
        }
    }
    
    private func evaluateJavaScript(command: String, completion: ((Any?) -> Void)? = nil) {
        let fullCommand = "player.\(command);"
        webView.evaluateJavaScript(fullCommand) { (result, error) in
            if let error, (error as NSError).code != 5 {
                print(error)
                completion?(nil)
            }
            completion?(result)
        }
    }
    
    fileprivate func eventProcess(_ url: URL) {
        guard let stateCode = url.absoluteString.components(separatedBy: "=").last else { return }
        guard let currentState = YoutubeViewState.init(rawValue: stateCode) else { return }
        state?(currentState)
    }
    
}

extension YoutubeView: WKNavigationDelegate {
    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy
        ) -> Void) {
        var action: WKNavigationActionPolicy?
        defer {
            decisionHandler(action ?? .allow)
        }
        guard let url = navigationAction.request.url else {return}
        if url.scheme == "ytplayer" {
            eventProcess(url)
            action = .cancel
        }
    }
}
