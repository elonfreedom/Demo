//
//  ViewController.swift
//  Demo
//
//  Created by elonfreedom on 2024/8/15.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    // 录音器
    private var audioRecorder: AVAudioRecorder?
    // 用于绘制波形的视图
    private var waveformView = WaveformView()
    // 用于存储录音数据的数组
    private var audioSamples: [CGFloat] = []
    private var recordingTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        let tagsView = TagsView()
        view.addSubview(tagsView)

        tagsView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.center.equalToSuperview()
            make.height.equalTo(40)
        }

        DispatchQueue.global().async {
            // 模拟网络请求或其他异步操作
            sleep(2)
            let newButtonTitles = ["11111", "22222", "11111", "22222", "11111", "22222", "11111", "22222", "11111", "22222", "11111", "22222"]
            //        setupAudioSession()

            DispatchQueue.main.async {
                // 更新 TagsView 的数据
                tagsView.labelTitles = newButtonTitles }
        }

//        tagsView.labelTitles =
//        setupAudioRecorder()
//        setupWaveformView()
    }

    // 配置音频会话
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            if #available(iOS 11.0, *) {
                try AVAudioSession.sharedInstance().setActive(true)
            }
        } catch {
            print("Audio session setup failed: \(error)")
        }
    }

    // 配置并启动录音器
    private func setupAudioRecorder() {
        let 录音设置 = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ] as [String: Any]

        let 录音文件URL = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        do {
            audioRecorder = try AVAudioRecorder(url: 录音文件URL, settings: 录音设置)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        } catch {
            print("Audio recording setup failed: \(error)")
        }
    }

    // 设置波形视图
    private func setupWaveformView() {
        // 将波形视图添加到视图层次结构中，并设置合适的frame
        waveformView.frame = CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: 100)
        waveformView.backgroundColor = .lightGray
        view.addSubview(waveformView)
    }

    // 获取Documents目录的路径
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // 更新波形视图
    func updateWaveform() {
        guard let audioRecorder = audioRecorder else { return }

        // 从录音器获取平均功率
        audioRecorder.updateMeters()
        let rawPowerValue = audioRecorder.averagePower(forChannel: 0)
        // 将 Float 转换为 CGFloat 以满足 pow 函数的要求
        let normalizedValue = pow(CGFloat(10), CGFloat(0.05 * Float(rawPowerValue)))
        audioSamples.append(normalizedValue)

        // 绘制波形
//        drawWaveform()
        waveformView.audioSamples = audioSamples
        waveformView.setNeedsDisplay()

        // 移除旧的样本数据以避免内存问题
        if audioSamples.count > Int(waveformView.bounds.width) {
            audioSamples.removeFirst()
        }
    }



    // 在主线程更新UI
    private func performUIUpdate() {
        DispatchQueue.main.async { [weak self] in
            self?.updateWaveform()
        }
    }

    // 定时更新波形
    private func startWaveformUpdates() {
        // 使用 [weak self] 捕获列表来避免强引用循环
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self]_ in
            // 使用弱引用调用 performUIUpdate 方法
//                [weak self] in
            self?.performUIUpdate()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        startWaveformUpdates()
    }

    deinit {
        // 停止录音和更新
        audioRecorder?.stop()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
}

