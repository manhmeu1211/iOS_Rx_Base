//
//  Extension.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

// swiftlint:disable all
extension UIViewController {
    
    @objc func executeBackgroundTask(_ task: @escaping (_ end: @escaping()->Void)->Void){
        
        async_main{
            //background task to continue even if App is closed
            var backTask = UIBackgroundTaskIdentifier(rawValue: .max)
            backTask = UIApplication.shared.beginBackgroundTask(withName: "background task") {
                
                //clean up if necessary
                
                UIApplication.shared.endBackgroundTask(backTask)
                backTask = UIBackgroundTaskIdentifier.invalid
            }
            
            task(){
                UIApplication.shared.endBackgroundTask(backTask)
                backTask = UIBackgroundTaskIdentifier.invalid
            }
        }
    }
    
    @objc func executeBackgroundTask_serial(_ queue: DispatchQueue, task: @escaping (_ end: @escaping()->Void)->Void){
        
        async {
            //background task to continue even if App is closed
            var backTask = UIBackgroundTaskIdentifier.invalid
            
            backTask = UIApplication.shared.beginBackgroundTask(withName: "background task") {
                
                //clean up if necessary
                
                UIApplication.shared.endBackgroundTask(backTask)
                backTask = UIBackgroundTaskIdentifier.invalid
            }
            
            sync_wait { (go) in
                async_serial_main_wait(queue){ next in
                    task(){
                        next()
                        UIApplication.shared.endBackgroundTask(backTask)
                        backTask = UIBackgroundTaskIdentifier.invalid
                        go()
                    }
                    
                }
            }
        }
        
        
    }
    
    
}

func executeBackgroundTask(_ task: @escaping (_ end: @escaping()->Void)->Void){
    
    async_main{
        //background task to continue even if App is closed
        var backTask = UIBackgroundTaskIdentifier(rawValue: .max)
        backTask = UIApplication.shared.beginBackgroundTask(withName: "background task") {
            
            //clean up if necessary
            
            UIApplication.shared.endBackgroundTask(backTask)
            backTask = UIBackgroundTaskIdentifier.invalid
        }
        
        task(){
            UIApplication.shared.endBackgroundTask(backTask)
            backTask = UIBackgroundTaskIdentifier.invalid
        }
    }
}

func async(_ block: (()->())?){

    guard let block = block else { return }

    DispatchQueue.global().async(execute: block)
    
}


func sync(_ block: (()->())?){
    
    guard let block = block else { return }
    
    DispatchQueue.global().sync(execute: block)

}

func async_main(_ block:(()->())?){
    guard let block = block else { return }
    
    DispatchQueue.main.async(execute: block)
}

func sync_main(_ block:(()->())?){
    guard let block = block else { return }
    
    if Thread.isMainThread {// if already in main just execute code
        block()
    } else {
        DispatchQueue.main.sync(execute: block)
    }

}

func serial_handle(_ name: String)->DispatchQueue{
    return DispatchQueue(label: name, attributes: [])
}

func serial_handle()->DispatchQueue{
    return serial_handle("serialQueue")
}

func async_serial(_ queue: DispatchQueue?, block:(()->Void)?){
    
    guard let block = block else { return }
    guard let queue = queue else { return }
    
    queue.async(execute: block)
    
}

func async_serial_wait(_ queue: DispatchQueue, block: ((_ next:@escaping()->Void)->Void)?){
    
    guard let block = block else { return }
    
    queue.async {
        queue.suspend()
        block { queue.resume() }
    }
    
}

func async_serial_main(_ queue: DispatchQueue, block:(()->Void)?){
    
    guard let block = block else { return }
    
    async_serial_wait(queue) { next in async_main { block(); next() } }
    
}

func async_serial_main_wait(_ queue: DispatchQueue, block:((_ next:@escaping()->Void)->Void)?){
    
    guard let block = block else { return }
    
    async_serial(queue) {
        queue.suspend()
        async_main{ block { queue.resume() } }
    }
}

func group_handle()->DispatchGroup{
    return DispatchGroup()
}

func async_group(_ group: DispatchGroup ,block: (()->())?){
    guard let block = block else { return }
    DispatchQueue.global().async(group: group, execute: block)
}

func async_group_main(_ group: DispatchGroup, block:(()->())?){
    guard let block = block else { return }
    DispatchQueue.main.async(group: group, execute: block)
}

func async_group_wait(_ group: DispatchGroup, block:((_ go:@escaping()->Void)->Void)?){
    
    guard let block = block else { return }
    
    async_group(group) {
        sync_wait({ (go) in block(){ go() } })
    }
}

func async_group_main_wait(_ group:DispatchGroup, block:((_ go:@escaping()->Void)->Void)?){
    guard let block = block else { return }
    
    async_group(group) {
        sync_wait{ go in sync_main { block(){ go() } } }
    }
}

func async_after(_ group: DispatchGroup, block: (()->())?){
    
    guard let block = block else { return }
    
    group.notify(queue: DispatchQueue.global(), execute: block)
}

func async_main_after(_ group: DispatchGroup, block: (()->())?){
    
    guard let block = block else { return }
    
    group.notify(queue: DispatchQueue.main, execute: block)
}


func sync_wait(_ block: ((_ go:@escaping()->Void)->Void)?){
    
    guard let block = block else { return }
    
    let s = serial_handle()
    
    s.suspend()
    block { s.resume() }
    s.sync{}
}

typealias Singleton = (op: OperationQueue,ser: DispatchQueue)

func singleton_handle()-> Singleton{
    return (OperationQueue(),serial_handle())
}

func async_singleton(_ s: Singleton?, block: (()->Void)?){

    guard let block = block else { return }
    
    async_serial(s?.ser) {//to make sure checking op count always happens in a single thread
        let operation = BlockOperation(block: block)
        operation.queuePriority = .normal
        operation.qualityOfService = .default
        
        if s?.op.operationCount == 0 {
            s?.op.addOperation(operation)
        }
    }
    
    //skip otherwise
}

func async_singleton(_ s: Singleton?, killAfter d: Double, block:((_ cancelled:@escaping()->Bool)->Void)?){
    
    guard let block = block else { return }
    
    async_serial(s?.ser) {//to make sure checking op count always happens in a single thread
        let operation = BlockOperation()
        operation.addExecutionBlock { [unowned operation] in
            block { operation.isCancelled }
        }
        operation.queuePriority = .normal
        operation.qualityOfService = .default
        
        if s?.op.operationCount == 0 {
            s?.op.addOperation(operation)
            
            delay_main(d){
                guard let ops = s?.op.operations else { return }
                
                if ops.contains(operation) {
                    s?.op.cancelAllOperations()
                    
                    print("singleton cancelled!")
                }
                
            }
        } else {
            //print("singleton busy!")
        }
    }
    
}

func async_singleton_wait(_ s: Singleton?, block: ((_ end:@escaping()->Void)->Void)?){
    
    guard let block = block else { return }
    
    async_serial(s?.ser) {//to make sure checking op count always happens in a single thread
        let operation = BlockOperation(){
            sync_wait{ go in block { go() } }
        }
        operation.queuePriority = .normal
        operation.qualityOfService = .default
        
        if s?.op.operationCount == 0 {
            s?.op.addOperation(operation)
        }
        //skip otherwise
        
    }
    
}

func oneShot(_ block: inout (()->Void)?){
    block?()
    block = nil
}

func delay_main(_ after:Double, block:(()->())?){
    
    guard let block = block else { return }
    
    let delay = DispatchTime.now() + Double(Int64(after * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: delay, execute: block)
    
}

func delay_serial(_ queue: DispatchQueue, after:Double,block:(()->())?){
    
    guard let block = block else { return }
    
    let delay = DispatchTime.now() + Double(Int64(after * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    
    queue.asyncAfter(deadline: delay, execute: block)
}


func delay_serial_wait(_ queue: DispatchQueue, after:Double,block:((_ next:@escaping()->Void)->Void)?){
    
    guard let block = block else { return }
    
    let delay = DispatchTime.now() + Double(Int64(after * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    
    queue.asyncAfter(deadline: delay){
        queue.suspend()
        block { queue.resume() }
    }
}


func delay(_ queue:DispatchQueue, after:Double,block:(()->())?){
    let delay = DispatchTime.now() + Double(Int64(after * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    if let block = block {
        queue.asyncAfter(deadline: delay, execute: block)
    }
}

func halt(_ duration: Double){
    
    sync_wait { go in
        delay_main(duration, block: go)
    }
}

func skip(_ block:(()->())?){}


extension DispatchQueue{
    
    func async_repeat(_ times: Int, every: Double, block:(()->Void)?)->Timer?{
        
        guard let block = block else { return nil }
        
        let noCount = times<2
        var count = 0
        
        let timer = Timer.scheduledTimer(withTimeInterval: every, repeats: times != 1){ (timer) in
            self.async(execute: block)
            
            if !noCount {
                count += 1
                if count>=times { timer.invalidate() }
            }
            
        }
        return timer
    }
}

private var tapLock = false
private let lockQueue = DispatchQueue(label: "lock queue", attributes: [])
func lock(_ duration:Double)->Bool{
    var proceed = true
    lockQueue.sync{
        if tapLock == false {
            tapLock = true
            delay(lockQueue,after: duration){
                tapLock = false
            }
        } else {
            proceed = false
        }
    }
    return proceed
}

func docFlagExists(_ name: String)-> Bool{
    
    let fileManager = FileManager.default
    let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    let path = docsDir + "/"+name
    return fileManager.fileExists(atPath: path)
}

func setDocFlag(_ name: String){
    let fileManager = FileManager.default
    let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    let path = docsDir + "/"+name
    fileManager.createFile(atPath: path, contents: nil, attributes: nil)
}

func deleteDocFlag(_ name: String){
    let fileManager = FileManager.default
    let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    let path = docsDir + "/"+name
    do {
        try fileManager.removeItem(at: URL(fileURLWithPath: path))
    } catch let error as NSError {
        print(error.localizedDescription)
    }
}

func deleteFileDoc(_ name: String) -> Bool{
    
    let fileManager = FileManager.default
    let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let path = docsDir + "/" + name
    
    guard fileManager.fileExists(atPath: path) else { return false }
    
    do {
        try fileManager.removeItem(atPath: path)
    } catch let error as NSError {
        NSLog("could not remove \(path)")
        print(error.localizedDescription)
    }
    
    return true
}

func renameFileDoc(old OldName: String, new name: String){
    
    let fileManager = FileManager.default
    let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    let path = docsDir + "/" + OldName
    let newPath = docsDir + "/" + name
    
    do {
        try fileManager.moveItem(atPath: path, toPath: newPath)
    }
    catch let error as NSError {
        print("Can't move file: \(error)")
    }
    
}

func moveFileDoc(_ path: String, newName name: String){
    
    let fileManager = FileManager.default
    let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    let newPath = docsDir + "/" + name
    
    do {
        try fileManager.moveItem(atPath: path, toPath: newPath)
    }
    catch let error as NSError {
        print("Can't move file: \(error)")
    }
}

func loadImageDoc(_ name : String)->UIImage?{
    
    var image : UIImage? = nil
    
    let fileManager = FileManager.default
    let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    let path = docsDir + "/" + name
    
    if let prevData = fileManager.contents(atPath: path) {
        image = UIImage(data: prevData)
    }
    
    return image
}

func loadImage(_ path : String)->UIImage?{
    
    var image : UIImage? = nil
    
    let fileManager = FileManager.default

    if let prevData = fileManager.contents(atPath: path) {
        image = UIImage(data: prevData)
    }
    
    return image
}

func deleteFile(_ path:String){
    
    let fileManager = FileManager.default
    guard fileManager.fileExists(atPath: path) else { return }
    
    do {
        try fileManager.removeItem(atPath: path)
    } catch let error as NSError {
        NSLog("could not remove \(path)")
        print(error.localizedDescription)
    }
    return
}

func anim(_ duration: Double, actions: @escaping ()->Void, completion: (()->Void)?){
    UIView .animate(withDuration: duration, animations: actions, completion: { _ in completion?()})
}

func anim(_ duration:Double,actions: @escaping ()->Void){
    anim(duration,actions: actions, completion: nil)
}


/*
//make Int conform to SequenceType
extension Int : SequenceType {
    public func generate() -> RangeGenerator<Int> {
        return (0..<self).generate()
    }
}
*/
extension UIImage {
    
    func addImagePadding(x: CGFloat, y: CGFloat) -> UIImage? {
        let width: CGFloat = size.width + x
        let height: CGFloat = size.height + y
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        let origin: CGPoint = CGPoint(x: (width - size.width) / 2, y: (height - size.height) / 2)
        draw(at: origin)
        let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithPadding
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    func customDescription () -> String {
        return String(format:"%.5f", self)
    }
    func roundDouble(num: Double) -> Float {
        
        //Create NSDecimalNumberHandler to specify rounding behavior
        let numHandler = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.down, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        
        let roundedNum = NSDecimalNumber(value: num).rounding(accordingToBehavior: numHandler)
        
        //Convert to float so you don't get the endless repeating decimal.
        return Float(roundedNum)
    }

}
extension Array {
    func customDescription() -> String {
        return self.description
    }
}

func resizeImage(_ ciImage: CIImage, scale: CGFloat, orient: Bool=false) -> UIImage {
    
    let image = orient ? orientImageWithDevice(ciImage) : UIImage(ciImage: ciImage)
    
    return resizeImage(image, scale: scale)
    
}

func resizeImage(_ image: UIImage, scale: CGFloat)->UIImage{
    
    let newHeight = image.size.height * scale
    let newWidth = image.size.width * scale
    
    return resizeImage(image, newWidth: newWidth, newHeight: newHeight)
}

func resizeImage(_ image: UIImage, newWidth: CGFloat, newHeight: CGFloat)->UIImage{
    
    UIGraphicsBeginImageContext(CGSize(width: floor(newWidth), height: floor(newHeight)))
    image .draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

func resizeImage(_ image: CIImage, newWidth: CGFloat, newHeight: CGFloat)->UIImage{
    
    return resizeImage(UIImage(ciImage: image), newWidth: newWidth, newHeight: newHeight)
}

func cropImage(_ image: CIImage, to rect: CGRect, margin: CGFloat=0)-> CIImage{
    
    var rect = rect.insetBy(dx: -margin, dy: -margin)//add margin
    rect = rect.applying(CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -image.extent.height))//convert to CoreImage coordinates
    
    let cropped = image.cropped(to: rect)
    return cropped.transformed(by: CGAffineTransform(translationX: -rect.origin.x, y: -rect.origin.y))
}

func checkLandscape()->Bool {
    
    switch UIDevice.current.orientation {
        
    case .landscapeLeft, .landscapeRight: return true
        
    case .portrait, .portraitUpsideDown: return false
        
    default:
        return true
    }
}

func rotatePortraitImage(_ image: CIImage) -> CIImage? {
    
    let statusBarOrientation = UIApplication.shared.statusBarOrientation
    
    switch UIDevice.current.orientation {
        
    case .landscapeLeft: return nil
        
    case .landscapeRight: return nil
        
    case .portrait:
        
        if statusBarOrientation == .landscapeRight {
            //rotate right
            return image.transformed(by: CGAffineTransform(rotationAngle: DegToRad(-90))).transformed(by: CGAffineTransform(translationX: 0, y: image.extent.size.width))
            
        } else {
            //rotate left
            return image.transformed(by: CGAffineTransform(rotationAngle: DegToRad(90))).transformed(by: CGAffineTransform(translationX: image.extent.size.height, y: 0))
            
        }
        
    case .portraitUpsideDown:
        
        if statusBarOrientation == .landscapeRight {
            //rotate left
            return image.transformed(by: CGAffineTransform(rotationAngle: DegToRad(90))).transformed(by: CGAffineTransform(translationX: image.extent.size.height, y: 0))
            
        } else {
            //rotate right
            return image.transformed(by: CGAffineTransform(rotationAngle: DegToRad(-90))).transformed(by: CGAffineTransform(translationX: 0, y: image.extent.size.width))
            
        }
        
    default:
        return nil
    }
    
}

func orientImageWithDevice(_ image: CIImage) -> UIImage {
    
    switch UIDevice.current.orientation {
        
    case .landscapeLeft: return UIImage(ciImage: image, scale: 1, orientation: .up)
        
    case .landscapeRight: return UIImage(ciImage: image, scale: 1, orientation: .down)
        
    case .portrait: return UIImage(ciImage: image, scale: 1, orientation: .right)
        
    case .portraitUpsideDown: return UIImage(ciImage: image, scale: 1, orientation: .left)
        
    default:
        return UIImage(ciImage: image, scale: 1, orientation: .up)
    }
    
}

extension CGFloat {
    
}


func DegToRad(_ a:CGFloat)->CGFloat {
    
    let b = CGFloat(M_PI) * a/180
    
    return b
}

