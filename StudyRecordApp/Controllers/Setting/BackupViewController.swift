//
//  BackupViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/20.
//

import UIKit

final class BackupViewController: UIViewController {
    
    @IBOutlet private weak var subCustomNavigationBar: SubCustomNavigationBar!
    
    private let backupUseCase = BackupUseCase(
        repository: BackupRepository()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubCustomNavigationBar()
        
    }
    
}

// MARK: - func
private extension BackupViewController {
    
    func createFileName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        let fileName = Constant.appName + "_backup_file_" + formatter.string(from: Date()) + ".txt"
        return fileName
    }
    
}

// MARK: - IBAction func
private extension BackupViewController {
    
    @IBAction func backupButtonDidTapped(_ sender: Any) {
        let fileName = createFileName()
        let documentURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: documentURL)
        backupUseCase.backup(documentURL: documentURL)
        let documentPickerVC = UIDocumentPickerViewController(
            forExporting: [documentURL],
            asCopy: true
        )
        documentPickerVC.modalPresentationStyle = .fullScreen
        present(documentPickerVC, animated: true)
    }
    
    @IBAction func restoreButtonDidTapped(_ sender: Any) {
        let documentPickerVC = UIDocumentPickerViewController(forOpeningContentTypes: [.text],
                                                              asCopy: true)
        documentPickerVC.delegate = self
        documentPickerVC.allowsMultipleSelection = false
        documentPickerVC.modalPresentationStyle = .fullScreen
        present(documentPickerVC, animated: true)
    }
    
}

// MARK: - UIDocumentPickerDelegate
extension BackupViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController,
                        didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        let sourceURLPathString = url.path
        let destinationURLPathString = url.deletingPathExtension().path
        let sourceURL = URL(fileURLWithPath: sourceURLPathString)
        let destinationURL = URL(fileURLWithPath: destinationURLPathString)
        do {
            if !FileManager.default.fileExists(atPath: destinationURLPathString) {
                try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            }
            guard let realmFileURL = backupUseCase.getRealmFileURL() else { return }
            try FileManager.default.removeItem(at: realmFileURL)
            try FileManager.default.copyItem(at: destinationURL, to: realmFileURL)
            backupUseCase.updateRealm(fileURL: destinationURL)
        } catch {
            print("DEBUG_PRINT: ", error.localizedDescription)
        }
        NotificationCenter.default.post(name: .reloadLocalData, object: nil)
    }
    
}

// MARK: - SubCustomNavigationBarDelegate
extension BackupViewController: SubCustomNavigationBarDelegate {
    
    func saveButtonDidTapped() { }
    
    func dismissButtonDidTapped() {
        dismiss(animated: true)
    }
    
    var navTitle: String {
        return L10n.backup
    }
    
}

// MARK: - setup
private extension BackupViewController {
    
    func setupSubCustomNavigationBar() {
        subCustomNavigationBar.delegate = self
        subCustomNavigationBar.saveButton(isHidden: true)
    }
    
}
