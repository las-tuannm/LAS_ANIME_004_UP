import UIKit
import AVFoundation
import Countly

class TaqPlayerController: UIViewController {
    
    fileprivate var source: [VideoIntentModel] = []
    fileprivate var timer: Timer?
    fileprivate var needResumeTimer: Bool = false
    fileprivate var fileSvSelected: FileSVModel?
    
    // MARK: - Properties
    let loadingView = LoadingView()
    
    var data: [TaqiDictionary] = []
    var name: String = ""
    var link: String = ""
    var typeSort: Int = 1
    var episode: AniEpisodesModel?
    var episodes: [AniEpisodesModel] = []
    
    
    lazy var svView: ChooseServerView = {
        let selView = ChooseServerView()
        return selView
    }()
    
    lazy var seasonView: ChooseSeasonView = {
        let selView = ChooseSeasonView()
        return selView
    }()
    
    lazy var speedView: ChooseSpeedView = {
        let selView = ChooseSpeedView()
        return selView
    }()
    
    static func makeController() -> TaqPlayerController {
        let bundle = Bundle(for: Self.self)
        let playerTrailer = TaqPlayerController(nibName: "AniController", bundle: bundle)
        playerTrailer.modalPresentationStyle = .fullScreen
        return playerTrailer
    }
    
    // MARK: - Outlets
    @IBOutlet weak var playerView: TaqPlayerView!
    @IBOutlet weak var controls: TaqPlayerControls!
    
    // MARK: - Config screen present landscape
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        guard let f = self.fileSvSelected else { return }
        let seg = ["sv": f.name,
                   "link": link,
                   "name": controls.titleLabel?.text ?? ""]
        Countly.sharedInstance().endEvent("playback", segmentation: seg, count: 1, sum: 0)
    }
    
    // MARK: - ViewController life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()
        setupProperties()
        updateTitle()
        setupUI()
        loadMoreSource()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToForeground),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToBackground),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        
        // play first url
        if let s = source.first, let sFirst = s.sources.first, let url = URL(string: sFirst.file) {
            self.fileSvSelected = sFirst
            self.svView.fileSvSelected = self.fileSvSelected
            
            let item = TaqPlayerView.makeItem(url: url, headers: sFirst.headers)
            playerView.set(item: item)
            
            self.playerView.controls?.subtitleButton?.isHidden = true
            SubtitleService.shared.vSubtitles = s.tracks
            SubtitleService.shared.subtitleSelected = nil   // reset index selected
            
            if HTMLService.shared.getSourceAnime() == .aniware {
                self.playerView.controls?.subtitleButton?.isHidden = sFirst.type != .softsub
            }
            else {
                self.playerView.controls?.subtitleButton?.isHidden = false
            }
        }
        
        Countly.sharedInstance().startEvent("playback")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Private
    private func setupTimer() {
        let interval = TimeInterval(5)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(triggerTimer),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    private func prepareData() {
        source.removeAll()
        for item in data {
            if let _sources = item["sources"] as? [TaqiDictionary] {
                
                var sourcesNew: [FileSVModel] = []
                for j in _sources {
                    sourcesNew.append(FileSVModel.createInstance(j))
                }
                
                var tracksNew: [SubtitleModel] = []
                if let _tracks = item["tracks"] as? [TaqiDictionary] {
                    for j in _tracks {
                        let sub = SubtitleModel.createInstance(j)
                        tracksNew.append(sub)
                    }
                }
                
                let uniqueTracks = tracksNew.unique{ $0.file }
                source.append(VideoIntentModel(sources: sourcesNew, tracks: uniqueTracks))
            }
        }
    }
    
    private func exitPlayer() {
        if UserDefaults.standard.integer(forKey: "exitpl") > 0 {
            AdsInterstitialHandle.shared.tryToPresent { [weak self] in
                self?.playerView.pause()
                self?.dismiss(animated: true)
            }
        }
        else {
            self.playerView.pause()
            self.dismiss(animated: true)
        }
    }
    
    private func setupUI() {
        // setup controls
        controls.backgroundColor = .clear
        controls.onBack = { [weak self] in
            guard let self = self else { return }
            
            self.exitPlayer()
        }
        controls.onSeason = { [weak self] in
            guard let self = self else { return }
            
            self.chooseSeason()
        }
        
        controls.onSubtitle = {
            let selView = ChooseSubtitleView()
            selView.onOffsub = nil
            selView.onSelectedSub = { subtitle in
                if subtitle.source == .subscene {
                    SubtitleService.shared.downloadSubScene(link: subtitle.file) { webVTT in }
                }
                else {
                    if subtitle.format == .vtt {
                        SubtitleService.shared.downloadSubVTT(link: subtitle.file) { webVTT in }
                    }
                    else {
                        SubtitleService.shared.downloadSubSRT(link: subtitle.file) { webVTT in }
                    }
                }
            }
            selView.show()
        }
        
        controls.onList = { [weak self] in
            guard let self = self else { return }
            
            self.svView.fileSvSelected = self.fileSvSelected
            self.svView.data = self.source
            self.svView.show()
        }
        
        controls.onResize = { [weak self] in
            guard let self = self else { return }
            
            switch self.playerView.renderingView.playerLayer.videoGravity {
            case .resize:
                self.playerView.renderingView.playerLayer.videoGravity = .resizeAspect
            case .resizeAspect:
                self.playerView.renderingView.playerLayer.videoGravity = .resizeAspectFill
            case .resizeAspectFill:
                self.playerView.renderingView.playerLayer.videoGravity = .resize
            default:
                break
            }
        }
        
        
        speedView.onRateChanged = { [weak self] value in
            self?.playerView.player.rate = value
        }
        
        speedView.onTimmingChanged = { value in }
        
        controls.onSpeed = { [weak self] in
            guard let self = self else { return }
            
            self.speedView.show()
        }
        
        // setup player view
        playerView.layer.backgroundColor = UIColor.black.cgColor
        playerView.use(controls: controls)
        playerView.controls?.behaviour.shouldAutohide = true
        playerView.controls?.behaviour.deactivationBlock = { ct in
            ct.behaviour.defaultDeactivationBlock()     // hidden controls
            ct.controlsCoordinator.showBannerIfNeed()   // show banner
        }
        playerView.controls?.behaviour.activationBlock = { ct in
            ct.behaviour.defaultActivationBlock()       // show controls
            ct.controlsCoordinator.hideBannerIfNeed()   // hide banner
        }
        playerView.playbackDelegate = self
        playerView.renderingView.playerLayer.videoGravity = .resizeAspect
        
        // apply style for subtitle
        playerView.renderingView.setSubtitleTextColor(.init(rgb: AppInfo.getSubTitleColor()))
        playerView.renderingView.setSubtitleTextSize(CGFloat(AppInfo.getSubTitleSize()))
        playerView.renderingView.setPaddingSubtitle(CGFloat(AppInfo.getSubTitlePosition()))
        
        controls.seasonButton?.isHidden = false
    }
    
    private func loadMoreSource() {
        // chi dung cho aniw
        if HTMLService.shared.getSourceAnime() == .aniware {
            ServService.shared.fetchNextSourceIfAvailable { [weak self] moreData in
                guard let self = self else { return }
                if moreData.count == 0 {
                    return
                }
                
                for item in moreData {
                    if let _sources = item["sources"] as? [TaqiDictionary] {
                        
                        var sourcesNew: [FileSVModel] = []
                        for j in _sources {
                            sourcesNew.append(FileSVModel.createInstance(j))
                        }
                        
                        var tracksNew: [SubtitleModel] = []
                        if let _tracks = item["tracks"] as? [TaqiDictionary] {
                            for j in _tracks {
                                let sub = SubtitleModel.createInstance(j)
                                tracksNew.append(sub)
                            }
                        }
                        
                        let uniqueTracks = tracksNew.unique{ $0.file }
                        self.source.append(VideoIntentModel(sources: sourcesNew, tracks: uniqueTracks))
                    }
                }
                
                self.svView.data = self.source
                self.loadMoreSource()
            }
        }
    }
    
    private func updateTitle() {
        controls.titleLabel?.text = episode?.sourceID == nil ? name : "[Ep \(episode?.episode ?? "0")] \(name)"
    }
    
    private func setupProperties() {
        // remove all subtile temp
        SubtitleService.shared.cleanSubDir()
        SubtitleService.shared.subtitleSelected = nil   // reset index selected
        
        //
        svView.data = source
        svView.onSelected = { [weak self] (pack, tracks) in
            guard let self = self, let url = URL.init(string: pack.file) else { return }
            
            self.controls.behaviour.show()
            self.setupTimer()
            self.fileSvSelected = pack  // cache
            
            let item = TaqPlayerView.makeItem(url: url, headers: pack.headers)
            self.playerView.set(item: item)
            self.playerView.controls?.subtitleButton?.isHidden = true
            SubtitleService.shared.vSubtitles = tracks
            SubtitleService.shared.subtitleSelected = nil   // reset index selected
            
            if HTMLService.shared.getSourceAnime() == .aniware {
                self.playerView.controls?.subtitleButton?.isHidden = pack.type != .softsub
            }
            else {
                self.playerView.controls?.subtitleButton?.isHidden = false
            }
        }
    }
    
    private func chooseSeason() {
        seasonView.delegate = self
        seasonView.episodeId = self.episode?.sourceID ?? ""
        seasonView.typeSort = self.typeSort
        seasonView.episodes = self.episodes
        seasonView.nameAnime = self.name
        seasonView.show()
    }
    
    @objc func triggerTimer() {
        if self.controls.behaviour.showingControls {
            self.controls.controlsCoordinator.hideBannerIfNeed()
        }
    }
    
    @objc func appMovedToForeground() {
        if needResumeTimer {
            needResumeTimer = false
            setupTimer()
        }
    }
    
    @objc func appMovedToBackground() {
        self.playerView.pause()
        if timer != nil {
            needResumeTimer = true
            timer?.invalidate()
            timer = nil
        }
    }
    
    func watchAnime(episode: AniEpisodesModel) {
        self.loadingView.show()
        
        ServService.shared.fetchServer(link: self.link, name: self.name, season: episode.season, episode: episode.episode, sourceId: episode.sourceID) { [weak self] data in
            
            self?.loadingView.dismiss()
            self?.seasonView.closeClicked()
            guard let self = self else {
                return
            }
            
            if data.count == 0 {
                // alert not found link here
                return
            }
            
            self.data = data
            self.episode = episode
            self.prepareData()
            self.updateTitle()
            self.loadMoreSource()
            
            SubtitleService.shared.subtitleSelected = nil   // reset index selected
            
            if let s = self.source.first, let sFirst = s.sources.first, let url = URL(string: sFirst.file) {
                self.controls.behaviour.show()
                self.setupTimer()
                
                self.fileSvSelected = sFirst
                self.svView.fileSvSelected = self.fileSvSelected
                
                let item = TaqPlayerView.makeItem(url: url, headers: sFirst.headers)
                self.playerView.set(item: item)
                
                self.playerView.controls?.subtitleButton?.isHidden = true
                SubtitleService.shared.vSubtitles = s.tracks
                SubtitleService.shared.subtitleSelected = nil   // reset index selected
                
                if HTMLService.shared.getSourceAnime() == .aniware {
                    self.playerView.controls?.subtitleButton?.isHidden = sFirst.type != .softsub
                }
                else {
                    self.playerView.controls?.subtitleButton?.isHidden = false
                }
            }
        }
    }
    
    // MARK: -
}

extension TaqPlayerController: TaqPlayerPlaybackDelegate {
    func timeDidChange(player: TaqPlayer, to time: CMTime) {
        let currentTime = Int(CMTimeGetSeconds(time) * 1000)
        let expectTime = currentTime + self.speedView.timing
        var subText: String?
        
        if let subtitle = SubtitleService.shared.subtitleSelected, let webVTT = subtitle.webVTT {
            subText = webVTT.searchSubtitles(time: expectTime)
        }
        playerView.renderingView.setSubtitle(subText)
    }
    
    func startBuffering(player: TaqPlayer) {
        if !controls.behaviour.showingControls {
            controls.behaviour.show()
        }
    }
    
    func endBuffering(player: TaqPlayer) {
        
    }
    
    func playbackDidFailed(with error: TaqPlayerError) {
        self.alertPlayback { [weak self] in
            guard let self = self else { return }
            
            self.rp(content: cantplay)
        }
    }
    
    fileprivate func rp(content: String) {
        guard let f = self.fileSvSelected else { return }
        
        let seg = ["sv": f.name,
                   "sv-link": f.file,
                   "link": link,
                   "name": controls.titleLabel?.text ?? "",
                   "content": content]
        Countly.sharedInstance().recordEvent("playback-failed", segmentation: seg)
    }
}

extension TaqPlayerController: ChooseSeasonDelegate {
    
    func selectEpisode(episode: AniEpisodesModel) {
        guard let episodeCurrentId = self.episode?.sourceID else { return }
        
        if episodeCurrentId == episode.sourceID {
            self.alertWarning(message: episodeisplay)
        }
        else {
            if HTMLService.shared.getSourceAnime() == .aniware {
                watchAnime(episode: episode)
            }
            else {
                NetworksService.shared.loadInfoas(link: link, title: name, season: episode.season, episode: episode.sourceID) { [weak self] data in
                    if data.count == 0 {
                        // alert not found link here
                        return
                    }
                    
                    self?.handleData(data, episode: episode)
                }
            }
        }
    }
    
    private func handleData(_ data: [TaqiDictionary], episode: AniEpisodesModel) {
        if episode.link == "" {
            self.alertNotLink { [weak self] in
                self?.rp(content: emptylink)
            }
        }
        else {
            self.seasonView.closeClicked()
            self.timer?.invalidate()
            self.timer = nil
            self.data = data
            self.episode = episode
            
            self.prepareData()
            self.setupProperties()
            self.updateTitle()
            self.setupTimer()
            
            if let s = source.first, let sFirst = s.sources.first, let url = URL(string: sFirst.file) {
                self.fileSvSelected = sFirst
                self.svView.fileSvSelected = self.fileSvSelected
                
                let item = TaqPlayerView.makeItem(url: url, headers: sFirst.headers)
                playerView.set(item: item)
                
                self.playerView.controls?.subtitleButton?.isHidden = true
                SubtitleService.shared.vSubtitles = s.tracks
                SubtitleService.shared.subtitleSelected = nil   // reset index selected
                
                if HTMLService.shared.getSourceAnime() == .aniware {
                    self.playerView.controls?.subtitleButton?.isHidden = sFirst.type != .softsub
                }
                else {
                    self.playerView.controls?.subtitleButton?.isHidden = false
                }
            }
        }
    }
}
