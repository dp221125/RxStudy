

# Start! RxSwift

## 01. 비동기 작업과 Observable

Observer 는  Observable를  subscribe

Observable이 무언가를 방출 observer 반응

~~~swift
    func rxDownImage() -> Observable<UIImage?> {
        return Observable.create { seal in
            self.asyncGetImage() { image in
                seal.onNext(image)
                seal.onCompleted()
            }
            return Disposables.create()
        }
    }
    
   func downImage() {
       rxDownImage()
            .observeOn(MainScheduler.instance)
            .subscribe({ result in
                switch result {
                case let .next(image):
                   self.randomImage?.image = image
                case let .error(err):
                    print(err.localizedDescription)
                case .completed:
                    break
                }
            })
        .disposed(by: disposeBag)
    }
~~~



## 02. Disposable, DisposeBag

dispose -> 취소와 관련된 

~~~Swift
var disposable: Disposable?
disposable?.dispose()  //취소

var disposbag = DisposeBag()
.disposed(by: disposeBag) // 특정 작업을 disposeBag에 담기
disposebag = DisposeBag() // disposeBag에 담긴 작업 취소

~~~



## 03. Operators

### Just(생성)

![image-20190730140035145](/Users/meo/Library/Application Support/typora-user-images/image-20190730140035145.png)

~~~swift
    func example1() {
        Observable.just("Hello RxSwift")  // "Hello RxSwift" 입력
            .subscribe(onNext: { str in
                print(str)              // "Hello RxSwift" 출력
            })
            .disposed(by: disposeBag)
    }
    
    func example2() {
        Observable.just(["Hello", "RxSwift"])  // ["Hello", "RxSwift"] 입력
            .subscribe(onNext: { str in
                print(str)              // ["Hello", "RxSwift"] 출력
            })
            .disposed(by: disposeBag)
    }
~~~

- 들어온 데이터를 그대로 출력


### from(생성)

![image-20190730140708565](/Users/meo/Library/Application Support/typora-user-images/image-20190730140708565.png)

~~~swift
    func example3() {
        Observable.from(["Hello" , "RxSwift"])  // ["Hello", "RxSwift"] 입력
            .subscribe(onNext: { str in
                print(str)              // Hello 출력 후 RxSwift 출력
            })
            .disposed(by: disposeBag)
    
~~~

- Array에 각 요소를 하나씩 배출


### map(변환)

![image-20190730141056454](/Users/meo/Library/Application Support/typora-user-images/image-20190730141056454.png)

~~~swift
    func example4() {
        Observable.just("RxSwift")  // RxSwift 입력
            .map { "\($0): ReactiveX Swift"}
            .subscribe(onNext: { str in
                print(str)              // RxSwift: ReactiveX Swift 출력
            })
            .disposed(by: disposeBag)
    }
    
    func example5() {
        Observable.from(["Hello", "RxSwift"])  // ["Hello", "RxSwift"] 입력
            .map { $0.count }
            .subscribe(onNext: { str in
                print(str)              // 5 출력 후 7 출력
            })
            .disposed(by: disposeBag)
    }
    
~~~

- 데이터를 변환 후 아래로 전달


### filter(필터)

![image-20190730141922261](/Users/meo/Library/Application Support/typora-user-images/image-20190730141922261.png)

~~~swift
    func example6() {
        Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])  //[1 ~ 10] 입력
            .filter { $0 != nil}
            .filter { $0! % 2 == 0 }
            .subscribe(onNext: { str in
                print(str)              // 2, 4, 6, 8, 10 출력
            })
            .disposed(by: disposeBag)
    }
~~~

- filter에 true일 때만 아래로 전달


### flatMap(변환)

![image-20190730150959668](/Users/meo/Library/Application Support/typora-user-images/image-20190730150959668.png)

~~~swift
    func example7() -> Observable<UIImage?> {
        return Observable.just("1920x1080")
            .map { $0.replacingOccurrences(of: "x", with: "/") } //Observable<String>
            .map { "https://picsum.photos/\($0)/?random" } //Observable<String>
            .map { URL(string: $0) } //Observable<URL?>
            .filter { $0 != nil }
            .map { $0! } //Observable<URL>
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default)) // 백그라운드
//          .map {self.imageLoading($0)} //Observable<Observable<UIImage?>>
            .flatMap {self.imageLoading($0)} //Observable<UIImage?>
    }

    func imageLoading(_ url: URL) -> Observable<UIImage?> {
        return Observable.just(url)
            .map { try Data(contentsOf: $0) }
            .map { UIImage(data: $0) }
    }
    
~~~

- 다른 operator와 달리 Observable이 리턴됨.


### combineLatest(결합)

![image-20190730164747507](/Users/meo/Library/Application Support/typora-user-images/image-20190730164747507.png)



~~~swift
    func example() {
        let stringArray = ["HELLO", "RXSwift"]
        let stringArray2 = ["EASY", "difficult"]
        
        Observable.combineLatest(Observable.from(stringArray).map(textLength),
                                 Observable.from(stringArray2).map(textLength),
                                 resultSelector: {str1, str2 in str1 && str2}
            )
            .subscribe(onNext: { (bool) in
                print(bool) 
            }).disposed(by: disposeBag)
    }
~~~

- Stream 두 개를 입력 받음.


- 둘 중 하나라도 변화가 있으면 다른 스트림의 최근값과 결합

### Zip

![image-20190731140015580](/Users/meo/Library/Application Support/typora-user-images/image-20190731140015580.png)

~~~swift
    func example() {
        let stringArray = ["HELLO", "RXSwift"]
        let stringArray2 = ["EASY", "difficult"]

        Observable.zip(Observable.from(stringArray).map(textLength),
                       Observable.from(stringArray2).map(textLength),
                       resultSelector: {str1, str2 in str1 && str2 }
            )
            .subscribe(onNext: { (bool) in
                print(bool) 
            }).disposed(by: disposeBag)  
    }
    
~~~



## 04. OnNext, OnError, OnComplete

최종적으로 만들어진 데이터를 사용하겠다. -> subscribe

subscribe의 ReturnType: Disposable

~~~swift
    func example() {
        Observable.just("Hello RxSwift")  
            .subscribe() // Hello RxSwift가 내려오고 끝. (실행만 시키고 결과를 신경 안씀)
            .disposed(by: disposeBag)
    }
~~~

~~~swift
    func example() {
        Observable.from(["Hello" , "RxSwift"])  // "Hello RxSwift" 입력
            .subscribe({ (event) in
                switch event {
                case .next(let str):
                    print(str)
                case .error(let err):
                    print(err.localizedDescription)
                case .completed:
                    print("completed")
                }
            })
            .disposed(by: disposeBag)
    }
~~~

- 성공하면 Hello 출력 -> RxSwift 출력 -> completed 출력


- 실패하면  completed 출력 안됨


~~~swift
    func exmaple() {
        Observable.from(["Hello", "RxSwift"])
            .subscribe(onNext: { (str) in
                print(str)
            }, onError: { (error) in
                print(error.localizedDescription)
            }, onCompleted: {
                print("completed")
            }, onDisposed: {
                print("dispose")
            })
            .disposed(by: disposeBag)
    }
~~~

- 성공: Hello 출력 -> RxSwift 출력 -> completed 출력 -> dispose 출력


- 실패: error 내용 출력 ->  dispose 출력


- onNext, onError, onCompleted, onDisposed 중 원하는 것만 골라서 사용 가능


## 05. Scheduler

### observeOn

~~~swift
.observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
.observeOn(MainScheduler.instance) //메인에서 돌리는 방법
~~~

- observeOn을 건 다음 줄부터 영향을 줌.


### subscribeOn

~~~swift
.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
~~~

- 위치에 무관함


### side-effect

- 외부에 영향을 주는 부분 -> .subscribe / .do


## 06. Subject

Observer와 Observable 두 역할을 수행 

-> Observer 역할: 하나 이상의 Observable을 구독

-> Observable 역할: 아이템을 방출

브릿지 또는 프록시 종류

### BehaviorSubject

![image-20190731131519597](/Users/meo/Library/Application Support/typora-user-images/image-20190731131519597.png)

- subscribe 하면 최근값 방출 or 최근값이 없으면 default 값 방출

![image-20190731131657386](/Users/meo/Library/Application Support/typora-user-images/image-20190731131657386.png)

- BehaviorSubject가 Error를 방출하면 그 이후에 .subscribe하면 에러를 방출

### PublishSubject

![image-20190731132035227](/Users/meo/Library/Application Support/typora-user-images/image-20190731132035227.png)

- subscribe 한 이후의  Observerble이 방출된 값만 관찰자에게 전달

### RelaySubject

![image-20190731141134796](/Users/meo/Library/Application Support/typora-user-images/image-20190731141134796.png)

- subscribe 시점과 상관없이 Observable에서 방출된 모드 값을 Observer에게 전달

### AsyncSubject

![image-20190731141626217](/Users/meo/Library/Application Support/typora-user-images/image-20190731141626217.png)

![image-20190731141940922](/Users/meo/Library/Application Support/typora-user-images/image-20190731141940922.png)

- Observable Stream이 완료된 후  마지막 값을 방출

- Observable 방출된 값이 없으면 AsyncSubject도 값을 내보내지 않고 완료

- 에러가 나면 에러를 전달



