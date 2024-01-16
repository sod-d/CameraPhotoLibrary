//
//  ViewController.swift
//  CameraPhotoLibrary
//
//  Created by sodud on 2024/01/16.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers //UTType 사용을 위해 삽입


class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var imgView: UIImageView!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage : UIImage! //촬영, 갤러리에서 불러온 이미지 저장
    var videoURL: URL!          //녹화한 비디오의 URL 저장
    var flagImageSave = false   //이미지 저장 여부
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnCaptureImageFromCamera(_ sender: UIButton) {
        if( UIImagePickerController.isSourceTypeAvailable(.camera)){ //카메라 사용 가능 여부 확인
            flagImageSave = true
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera                             //소스 타입
//            imagePicker.mediaTypes = [kUTTypeImage as String]          //iOS 15.0 부터는 미지원
            imagePicker.mediaTypes = [UTType.image.identifier as String] //미디어 타입 설정
            imagePicker.allowsEditing = false                            //편집 비허용
            
            present(imagePicker, animated: true, completion: nil)
        }else{
            myAlert("Camera inccessable", message: "Application cannot access the camera.")
        }
    }
    
    @IBAction func btnRecordVideoFromCamera(_ sender: UIButton) {
    }
    @IBAction func btnLoadImageFromLibrary(_ sender: UIButton) {
    }
    @IBAction func btnLoadVideoFromLibrary(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            flagImageSave = false
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            //            imagePicker.mediaTypes = [kUTTypeMovie as String] //iOS 15.0 부터는 미지원
            imagePicker.mediaTypes = [UTType.movie.identifier as String]
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }else{
            myAlert("Photo album inaccessble", message: "Application cannot access the photo album.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
//        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
        if mediaType.isEqual(to: UTType.image.identifier as NSString as String) {
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            if flagImageSave {
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            }
            
            imgView.image = captureImage
//        }else if mediaType.isEqual(to: kUTTypeMovie as NSString as String){
//        }else if mediaType.isEqual(to: kUTTypeMovie as NSString as String){
//            if flagImageSave {
//                videoURL = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//
//                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
//            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func myAlert(_ title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

