# 사진 앨범 접근

## AVFoundation & PhotoKit

### AVFoundation

- 오디오, 비디오를 다루는 프래임워크
  - 편집, 녹화, 캡처, 불러오기 내보내기 등 기능 제공

### PhotoKit

- Photos 앱을 조작할 수 있는 API 를 제공하는 프래임워크
- 사진 fetching 시 자동으로 권한 물어봄
  - fetching 메소드가 호출 되는 시점에 권한 물어봄

### 문제.1 CollectionViewCell 가로모드 너비

viewWillLayoutSubviews + CollectionFlowLayout
