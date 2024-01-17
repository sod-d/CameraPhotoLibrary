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

    @IBOutlet var firImgView: UIImageView!
    @IBOutlet var secImgView: UIImageView!
    @IBOutlet var imgView: UIImageView!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage : UIImage! //촬영, 갤러리에서 불러온 이미지 저장
    var videoURL: URL!          //녹화한 비디오의 URL 저장
    var flagImageSave = false   //이미지 저장 여부
    
    var numImage = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnCaptureImageFromCamera(_ sender: UIButton) {
        if( UIImagePickerController.isSourceTypeAvailable(.camera)){ //카메라 사용 가능 여부 확인
            flagImageSave = true
            numImage = numImage + 1
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
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            flagImageSave = true
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
//            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.mediaTypes = [UTType.movie.identifier as String]
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
            
        }else{
            myAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    @IBAction func btnLoadImageFromLibrary(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            flagImageSave = false
            numImage = numImage + 1
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
//            imagePicker.mediaTypes = [kUTTypeImage  as String]
            imagePicker.mediaTypes = [UTType.image.identifier  as String]
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
            
        }
        else{
            myAlert("Photo album inaccessable", message: "Application cannot access the photo album.")
        }
        
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
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString //미디어 종류 확인
        
//        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
        if mediaType.isEqual(to: UTType.image.identifier as NSString as String) { //이미지일 경우
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage //이미지를 captureImage안에 할당
            
            if flagImageSave {
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            }
            print("numImage === \(numImage)")
            if numImage == 1{
                firImgView.image = captureImage
            }else if numImage == 2{
                secImgView.image = captureImage
            }else {
                imgView.image = captureImage
            }
            
            
//        }else if mediaType.isEqual(to: kUTTypeMovie as NSString as String){
        }else if mediaType.isEqual(to: UTType.movie.identifier as NSString as String){ //비디오일 경우
            if flagImageSave {
                videoURL = (info[UIImagePickerController.InfoKey.mediaURL] as! URL)
                
                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
            }
        }
        self.dismiss(animated: true, completion: nil) //현재 뷰 컨트롤러 제거 -> 뷰에서 이미지 피커 화면을 제거하여 초기 뷰를 보여줌
    }
    
    //사용자가 사진/비디오를 촬영하지 않고 취소할 경우 처음 뷰 상태로 돌아가야 함
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        numImage = numImage - 1
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func myAlert(_ title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnReset(_ sender: UIButton) {
        firImgView.image = nil
        secImgView.image = nil
        imgView.image = nil
        numImage = 0
    }
}

