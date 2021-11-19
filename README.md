# StudyRecordApp

## App Store URL
[TaskR]()  


## 技術・ライブラリ  
【アーキテクチャ】  
MVC: Cocoa MVCを採用  
MVVM: KickstarterのViewModelインターフェースを採用。ViewModelの宣言時は型をViewModelTypeとし、制約をつけること    
clean　architecture: アンクルボブ提唱のものを採用  
【リアクティブプログラミング】  
RxSwift/RxCocoa： MVVMアーキテクチャ導入のために使用  
【データベース】  
RealmSwift： Userのデータ以外をこちらに保存する  
Firestore: Userのデータはこちらに保存する  
【その他】  
PKHUD: 非同期処理の待ち時間にprogressを表示させるために使用  
ReachabilitySwift: Firebaseの通信が可能かどうかを調べために使用  
ScrollableGraphView: Graph表示のために使用  
Firebase/Analytics:  レポートのために使用    
Firebase/Auth: User認証のために使用     
Firebase/Crashlytics: クラッシュを検知するために使用  
SwiftGen: ハードコードをできるだけしたいために使用  
mailcore2-ios: 自身のメールアドレスに直接届けるために使用    
LicensePlist: ライブラリのライセンスを表示させるために使用  
SwiftFormat/CLI: Xcodeのフォーマットを整えるために使用  
SwiftLint: Swiftのコードのフォーマットを揃えるために使用     


## アーキテクチャ
MVC  
MVVM  
clean　architecture  


## アプリ挙動動画
![ezgif com-gif-maker](https://user-images.githubusercontent.com/66917548/142624979-d5f555bb-823d-422f-8cbe-c876ddbd6cd5.gif)


## アプリの特徴・工夫した点  
・直感的に操作できるUI   
・おしゃれなデザイン   
・バイブレーション、ウェーブ、フェードイン、フェードアウトなどのアニメーション   
・1億通り以上選べるテーマカラー   
・ダークモード対応   
・20通り以上選べるグラフデザイン   
・目標ページに統計情報を表示   
・パスコード、FaceIDでプライバシーを保護   
・日本語、英語対応   
・120通り以上選べるアプリアイコン   
・簡単にバックアップ、リストアができる   
・ログイン、サインアップ機能   


## 技術的に工夫した点   
・RxSwift/RxCocoaを用いてリアクティブプログラミングをし、MVCアーキテクチャからMVVMアーキテクチャに書き換え、ViewControllerの責務を減らし、テスト容易性を意識した。  
・RxCocoaのDriver, Signalなどを用いてメインスレッドで実行やエラーを流さないことを保証した。  
・clean　architectureを用いて詳細の決定を先延ばしにした。  
・ViewController間の通知やViewとViewController間の通知などをクロージャ、デリゲート、RxSwiftなどを用いて疎結合を意識した。  
・DataStoreとUseCaseにRepositoryを挟み、ViewControllerが具体的なデータの保存先を意識しないようにDIした。  
・RealmやFirebaseに依存したモデルクラスとそれぞれの共通型のモデルクラスを用意し、Repositoryで変換することでViewControllerやUseCaseが具体的な型に依存しないようにした。  
・HalfModalを自作し、使いやすいUIを実現した。  
・UITableView, UICollectionViewなどのExtensionを実装して使いやすくした。  
・ライトモード、ダークモードを全ての画面で実装した。  
・日本語と英語と対応させて国際化した。  
・SwiftLint, SwiftFormatを使い、ソースコードのフォーマットを共通化した。  
・SwiftGenを用いてハードコードしないようにした。  
・Crashlyticsを用いてクラッシュ検知した。  



## 今後の予定  
音声入力  
課金処理  
広告導入  
CI/CD  
テストコード  


