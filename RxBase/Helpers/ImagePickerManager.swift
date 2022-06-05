//
//  ImagePickerManager.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

import Photos
import MobileCoreServices

protocol ToImagePickerController {
    var navigationController: UINavigationController { get }
}

extension ToImagePickerController {
    func showPickPhotoBottomSheet() -> Observable<UIImage?> {
        return Observable.create { obs -> Disposable in
            let imagePickerManager = ImagePickerManager(from: navigationController)
            let aletVC = UIAlertController(title: "Open",
                                           message: nil,
                                           preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
            
            let libraryAction = UIAlertAction(
                title: "Libary",
                style: .default
            ) {  _ in
                imagePickerManager.pickPhoto(from: .photoLibrary)
                    .bind(to: obs)
                    .disposed(by: aletVC.rx.disposeBag)
            }
            
            let cameraAction = UIAlertAction(
                title: "Camera",
                style: .default
            ) { _ in
                imagePickerManager
                    .pickPhoto(from: .camera)
                    .bind(to: obs)
                    .disposed(by: aletVC.rx.disposeBag)
            }
            
            aletVC.addAction(libraryAction)
            aletVC.addAction(cameraAction)
            aletVC.addAction(cancelAction)
            
            navigationController.present(
                aletVC,
                animated: true,
                completion: nil
            )
            
            return Disposables.create {
                aletVC.dismiss(animated: true, completion: nil)
            }
        }
    }
}

enum ImagePickerManagerError: Error {
    case accessDenied
    case accessRestricted
}

final class ImagePickerManager: NSObject {
    
    private var singelObserver: ((SingleEvent<UIImage?>) -> Void)?
    
    private weak var viewController: UIViewController?
    
    private let disposeBag = DisposeBag()
    
    init(from viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func pickPhoto(from sourceType: UIImagePickerController.SourceType, allowsEditing: Bool = true) -> Observable<UIImage?> {
        return Single.create { single in
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                    DispatchQueue.main.async {
                        let picker = UIImagePickerController()
                        picker.sourceType = sourceType
                        picker.delegate = self
                        picker.allowsEditing = allowsEditing
                        self.singelObserver = single
                        picker.mediaTypes = [kUTTypeImage as String]
                        picker.modalPresentationStyle = .fullScreen
                        self.viewController?.present(picker, animated: true, completion: nil)
                    }
                }
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.pickPhoto(from: sourceType)
                            .subscribe(onNext: {(images) in
                            single(.success(images))
                        }, onError: { (error) in
                            single(.failure(error))
                        })
                        .disposed(by: self.disposeBag)
                    } else {
                        single(.failure(ImagePickerManagerError.accessDenied))
                    }
                }
            case .denied:
                single(.failure(ImagePickerManagerError.accessDenied))
            case .restricted:
                single(.failure(ImagePickerManagerError.accessRestricted))
            @unknown default:
                break
            }
            return Disposables.create { }
        }
        .asObservable()
    }
}

extension ImagePickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            if let image = info[.originalImage] as? UIImage {
                singelObserver?(.success(image.upOrientationImage()))
            }
            return
        }
        singelObserver?(.success(image.upOrientationImage()))
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        singelObserver?(.success(nil))
    }
}
