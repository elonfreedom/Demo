//
//  WaveView.swift
//  Demo
//
//  Created by elonfreedom on 2024/8/15.
//

import UIKit

class WaveformView: UIView {
    // 用于存储录音数据的数组
    var audioSamples: [CGFloat] = []
    
    // 控制波形的缩放比例
    var amplitudeScale: CGFloat = 5.0

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), !audioSamples.isEmpty else { return }
        
        // 配置红色笔触
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(2) // 设置线宽
        
        // 波形图绘制逻辑
        let waveformCenter = rect.midY // 中心线
        let sampleRate = rect.width / CGFloat(audioSamples.count)
        
        // 移动到第一个样本点的中心位置
        let firstSampleY = waveformCenter - (audioSamples.first! * amplitudeScale)
        context.move(to: CGPoint(x: 0, y: firstSampleY))
        
        for (i, sample) in audioSamples.enumerated() {
            let pointX = CGFloat(i) * sampleRate
            let upperY = waveformCenter - (sample * amplitudeScale) // 上半部分
            let lowerY = waveformCenter + (sample * amplitudeScale) // 下半部分
            
            // 绘制上半部分
            if i == 0 {
                // 第一个样本点，从中心线开始绘制
                context.move(to: CGPoint(x: pointX, y: upperY))
            } else {
                context.addLine(to: CGPoint(x: pointX, y: upperY))
            }
            
            // 绘制下半部分
            context.addLine(to: CGPoint(x: pointX, y: lowerY))
        }
        
        // 绘制完成路径
        context.strokePath()
    }
}
