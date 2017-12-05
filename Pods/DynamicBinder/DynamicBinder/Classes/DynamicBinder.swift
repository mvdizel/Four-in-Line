//
//  DynamicBinder.swift
//  Pods
//
//  Created by Vasilii Muravev on 29/08/2017.
//
//

// MARK: - Typealias
public typealias BindedHandler<T> = (T) -> Void

public struct DynamicBinderInterface<T> {
  
  // MARK: - Public Instance Attributes
  public var value: T! { return binder?.value }
  
  
  // MARK: - Private Instance Attributes
  private weak var binder: DynamicBinder<T>!
  
  
  // MARK: - Initializers
  fileprivate init(_ binder: DynamicBinder<T>) {
    self.binder = binder
  }
  
  
  // MARK: - Public Instance Methods
  public func bind(with observer: AnyObject, _ handler: @escaping BindedHandler<T>) {
    binder?.bind(with: observer, handler)
  }
  
  public func bindAndFire(with observer: AnyObject, _ handler: @escaping BindedHandler<T>) {
    binder?.bindAndFire(with: observer, handler)
  }
  
  public func unbind(_ observer: AnyObject) {
    binder?.unbind(observer)
  }
}

public class DynamicBinder<T> {
  
  // MARK: - Public Instance Attributes
  public lazy var interface: DynamicBinderInterface<T> = { [unowned self] in
    return DynamicBinderInterface(self)
  }()
  public var value: T { didSet { fireListeners() }}
  
  
  // MARK: - Private Instance Attributes
  private var listeners: [Listener<T>] = []
  
  
  // MARK: - Initializers
  public init(_ value: T) {
    self.value = value
  }
  
  @available(*, unavailable) private init() {
    fatalError("unavailable")
  }
  
  
  // MARK: - Public Instance Methods
  public func fire() {
    fireListeners()
  }
  
  public func bind(with observer: AnyObject, _ handler: @escaping BindedHandler<T>) {
    let listener = Listener(observer, handler)
    listeners.append(listener)
  }
  
  public func bindAndFire(with observer: AnyObject, _ handler: @escaping BindedHandler<T>) {
    bind(with: observer, handler)
    handler(value)
  }
  
  public func unbind(_ observer: AnyObject) {
    listeners = listeners.filter({ $0.observer !== observer && $0.observer != nil })
  }
  
  
  // MARK: - Private Instance Methods
  
  /// Fires all listeners and cleans deallocated observers.
  private func fireListeners() {
    listeners = listeners.flatMap({
      guard let handler = $0.handler, let _ = $0.observer else {
        return nil
      }
      handler(value)
      return $0
    })
  }
}


// MARK: - Listener
private struct Listener<T> {
  
  // MARK: - Public Instance Attributes
  weak var observer: AnyObject?
  var handler: BindedHandler<T>?
  
  
  // MARK: - Initializers
  init(_ observer: AnyObject, _ handler: @escaping BindedHandler<T>) {
    self.observer = observer
    self.handler = handler
  }
}
