TransitionManager
=================

Painless custom transitioning. Easy extend, easy setup, just focus on animations.

Install
----

### Cocoapods

``` ruby
use_frameworks!
pod 'TransitionManager'
```

### Manual

Copy & paste `TransitionManager` folder into your project.

Usage 
-----

Copy & paste `TransitionManager.swift` into your project.

-  Declare a `TransitionManager` object.  
-  Init it with a [`TransitionManagerAnimation`](#Create)  
-  Assign it as your navigation controller's delegate if you use navigation controller.  
  -  Else assign it as your view controller's `transitioningDelegate`.  

``` swift
	
	var transition: TransitionManager!
	    
	override func viewDidLoad() {
	   super.viewDidLoad()
	   
	   transition = TransitionManager (transitionAnimation: FadeTransitionAnimation())
	   navigationController?.delegate = transition
	}
	
```


Creating Transition Animations <a id="Create"></a>
-----


Create a subclass of `TransitionManagerAnimation` 

``` swift
	class FadeTransitionAnimation: TransitionManagerAnimation {

	}
```

`TransitionManagerAnimation` class implements `TransitionManagerDelegate` protocol.

##### TransitionManagerDelegate <a id="Delegate"></a>

``` swift
protocol TransitionManagerDelegate {

    /// Transition nimation method implementation
    func transition(
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        isDismissing: Bool,
        duration: NSTimeInterval,
        completion: () -> Void)

    /// Interactive transitions,
    /// update percent in gesture handler
    var interactionTransitionController: UIPercentDrivenInteractiveTransition? { get set }
}
```

For transition animation, we should override `transition` func and write our custom animation in it.

``` swift

class FadeTransitionAnimation: TransitionManagerAnimation {
    override func transition(
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        isDismissing: Bool,
        duration: NSTimeInterval,
        completion: () -> Void) {
        if isDismissing {
            closeAnimation(container,
                fromViewController: fromViewController,
                toViewController: toViewController,
                duration: duration,
                completion: completion)
        } else {
            openAnimation(container,
                fromViewController: fromViewController,
                toViewController: toViewController,
                duration: duration,
                completion: completion)
        }
    }    
}

```

One important part is `completion()` must be called because the `TransitionManager` finishes transition after it gets called.


### Interaction Transition

Interaction transition has 3 parts:
* Init `interactionTransitionController` and either pop or push navigation controller when gesture (interaction) starts.
* Calculate your `percent`s on gesture change and `updateInteractiveTransition:` with that percent
* When gesture ended, decide if your transition complete or not and give information to your `interactionTransitionController` with `finishInteractiveTransition ()` and `cancelInteractiveTransition ()`


### Easier `TransitionManager` setup

You can create a `TransitionManagerAnimation` container enum and give it all your animations

``` swift
	enum TransitionManagerAnimations {
	    case Fade
	    case Pull
	}
```

Write a func that returns correct transition animation in enum

``` swift
enum TransitionManagerAnimations {
    case Fade
    case Pull
    
    func transitionAnimation () -> TransitionManagerAnimation {
        switch self {
        case .Fade:
            return FadeTransitionAnimation()
        case .Pull:
            return PullTransitionAnimation()
        }
    }
}
```

Extend `TransitionManager` and write a new init method like

``` swift
extension TransitionManager {
    convenience init (transition: TransitionManagerAnimations) {
        self.init (transitionAnimation: transition.transitionAnimation())
    }
}
```

Now you can create `TransitionManager` in your view controller like

``` swift
transition = TransitionManager (transition: .Left(navigationController!))
navigationController?.delegate = transition
```
