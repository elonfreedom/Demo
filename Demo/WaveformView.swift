import UIKit

class WaveformView: UIView {
    // 用于存储录音数据的数组
    var audioSamples: [CGFloat] = []
    
    // 控制波形的缩放比例
    var amplitudeScale: CGFloat = 5.0
    
    // 控制波形的水平偏移量
    private var horizontalOffset: CGFloat = 0.0

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), !audioSamples.isEmpty else { return }
        
        // 配置波形线条
        context.setStrokeColor(UIColor.blue.cgColor) // 将波形颜色设置为蓝色
        context.setLineWidth(2) // 设置线宽
        
        // 绘制中心线
        let centerX = rect.width / 2
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineWidth(1)
        context.move(to: CGPoint(x: centerX, y: rect.minY))
        context.addLine(to: CGPoint(x: centerX, y: rect.maxY))
        context.strokePath()
        
        // 波形图绘制逻辑
        let waveformCenter = rect.midY // 中心线
        let sampleRate = rect.width / CGFloat(audioSamples.count)
        
        // 计算波形的初始绘制位置
        let startOffset = centerX - horizontalOffset
        
        // 移动到第一个样本点的中心位置
        let firstSampleY = waveformCenter - (audioSamples.first! * amplitudeScale)
        context.move(to: CGPoint(x: startOffset, y: firstSampleY))
        
        for (i, sample) in audioSamples.enumerated() {
            let pointX = startOffset + CGFloat(i) * sampleRate
            if pointX > centerX { break } // 确保波形仅绘制在中心线左侧
            
            let upperY = waveformCenter - (sample * amplitudeScale) // 上半部分
            let lowerY = waveformCenter + (sample * amplitudeScale) // 下半部分
            
            // 绘制上半部分
            context.addLine(to: CGPoint(x: pointX, y: upperY))
            
            // 绘制下半部分
            context.addLine(to: CGPoint(x: pointX, y: lowerY))
        }
        
        // 绘制完成路径
        context.strokePath()
    }
    
    // 更新水平偏移量，以实现向左滑动效果
    func updateOffset() {
        horizontalOffset += 1.0 // 每次更新增加的偏移量，可以根据需要调整
        setNeedsDisplay() // 触发重新绘制
    }
}
