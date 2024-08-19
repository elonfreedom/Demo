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
    private var recordButton: UIButton!
    private var recordingURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .red
        setupAudioRecorder()
        setupWaveformView()
        setupRecordButton()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("音频会话配置失败: \(error)")
        }
    }

    // 配置录音器
    private func setupAudioRecorder() {
        setupAudioSession()

        let recordingSettings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ] as [String: Any]

        recordingURL = getDocumentsDirectory().appendingPathComponent("\(UUID().uuidString).m4a")

        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, settings: recordingSettings)
            audioRecorder?.isMeteringEnabled = true
        } catch {
            print("录音器配置失败: \(error)")
        }
    }
    // 设置录音按钮
    private func setupRecordButton() {
        recordButton = UIButton(type: .system)
        recordButton.frame = CGRect(x: (view.bounds.width - 100) / 2, y: 250, width: 100, height: 50)
        recordButton.setTitle("开始录音", for: .normal)
        recordButton.backgroundColor = .systemBlue
        recordButton.setTitleColor(.white, for: .normal)
        recordButton.layer.cornerRadius = 10
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        view.addSubview(recordButton)
    }
    // 录音按钮点击事件
    @objc private func recordButtonTapped() {
        guard let audioRecorder = audioRecorder else {
            setupAudioRecorder()
            return
        }

        if !audioRecorder.isRecording {
            // 开始录音
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            startWaveformUpdates()
            recordButton.setTitle("停止录音", for: .normal)
        } else {
            // 停止录音并保存文件
            audioRecorder.stop()
            recordingTimer?.invalidate()
            saveRecording()
            recordButton.setTitle("开始录音", for: .normal)
        }
    } // 设置波形视图
    private func setupWaveformView() {
        waveformView.frame = CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: 100)
        waveformView.backgroundColor = .lightGray
        view.addSubview(waveformView)
    }
    // 保存录音
    // 保存录音文件
    private func saveRecording() {
        guard let recordingURL = recordingURL else { return }
        print("录音已保存到: \(recordingURL)")
        // 可根据需要添加更多逻辑来处理保存的文件
    }
    // 获取Documents目录的路径
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // 更新波形视图
//    func updateWaveform() {
//        guard let audioRecorder = audioRecorder else { return }
//
//        audioRecorder.updateMeters()
//        let rawPowerValue = audioRecorder.averagePower(forChannel: 0)
//        let normalizedValue = pow(CGFloat(10), CGFloat(0.05 * Float(rawPowerValue)))
//        audioSamples.append(normalizedValue)
//
//        waveformView.audioSamples = audioSamples
//        waveformView.setNeedsDisplay()
//
//        if audioSamples.count > Int(waveformView.bounds.width) {
//            audioSamples.removeFirst()
//        }
//    }

    func updateWaveform() {
        guard let audioRecorder = audioRecorder else { return }

        audioRecorder.updateMeters()
        let rawPowerValue = audioRecorder.averagePower(forChannel: 0)

        // 将 dB 值转换为线性比例，并对其进行放大
        let minDb: CGFloat = -80.0 // 最小 dB 值
        let level = max(0.0, (CGFloat(rawPowerValue) - minDb) / -minDb) // 将 dB 值归一化到 [0, 1] 范围内
        let scaledValue = level * 50.0 // 乘以放大因子

        audioSamples.append(scaledValue)

        waveformView.audioSamples = audioSamples
        waveformView.setNeedsDisplay()

        if audioSamples.count > Int(waveformView.bounds.width) {
            audioSamples.removeFirst()
        }
    }

    // 在主线程更新UI
    private func performUIUpdate() {
        DispatchQueue.main.async { [weak self] in
            self?.updateWaveform()
            self?.waveformView.updateOffset() // 更新偏移量，实现向左滑动
        }
    }

    // 定时更新波形
    private func startWaveformUpdates() {
        // 使用 [weak self] 捕获列表来避免强引用循环
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self]_ in
            // 使用弱引用调用 performUIUpdate 方法
            self?.performUIUpdate()
        }
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        startWaveformUpdates()
//    }

    deinit {
        // 停止录音和更新
        audioRecorder?.stop()
        recordingTimer?.invalidate()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
}

