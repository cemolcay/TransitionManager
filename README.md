TransitionManager
=================

Painless custom transitioning. Easy extend, easy setup, just focus on animations.


Usage 
-----

Copy & paste `TransitionManager.swift` into your project.

Decleare a `TransitionManager` object.  
Init it with a [`TransitionManagerAnimation`](#Create)  
Assign it as your navigation controller's delegate if you use navigation controller.  
Else assign it as your view controller's `transitioningDelegate`.  

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
	        
	    func transition (
	        container: UIView,
	        fromViewController: UIViewController,
	        toViewController: UIViewController,
	        duration: NSTimeInterval,
	        completion: ()->Void)
	        
	    var interactionTransitionController: UIPercentDrivenInteractiveTransition? { get set }
	}

```

For transition animation, we should override `transition` func and write our custom animation in it.

``` swift

class FadeTransitionAnimation: TransitionManagerAnimation {
    
    override func transition (
        container: UIView,
        fromViewController: UIViewController,
        toViewController: UIViewController,
        duration: NSTimeInterval,
        completion: ()->Void) {
            
            let fromView = fromViewController.view
            let toView = toViewController.view
            
            container.addSubview(toView)
            toView.alpha = 0
            
            UIView.animateWithDuration(
                duration,
                animations: {
                    toView.alpha = 1
                },
                completion: { finished in
                    completion ()
            })
    }
}

```

One important part is `completion()` must be called because the `TransitionManager` finishes transition after it get called.


### Interaction Transition

Create a `TransitionManagerAnimation` subclass and write an initilizer with `UINavigationController` parameter.

Add its `view` a pan gesture

``` swift
	class LeftTransitionAnimation: TransitionManagerAnimation {
	    
	    var navigationController: UINavigationController!
	    
	    init (navigationController: UINavigationController) {
	        super.init()
	        
	        self.navigationController = navigationController
	        self.navigationController.view.addGestureRecognizer(UIPanGestureRecognizer (target: self, action: Selector("didPan:")))
	    }
	    
	}
```

We will update `interactionTransitionController` variable in [`TransitionManagerDelegate`](#Delegate) in gesture handler.

``` swift
    func didPan (gesture: UIPanGestureRecognizer) {
        let percent = gesture.translationInView(gesture.view!).x / gesture.view!.bounds.size.width
        
        switch gesture.state {
        case .Began:
            interactionTransitionController = UIPercentDrivenInteractiveTransition()
            navigationController.popViewControllerAnimated(true)
            
        case .Changed:
            interactionTransitionController!.updateInteractiveTransition(percent)
            
        case .Ended:
            if percent > 0.5 {
                interactionTransitionController!.finishInteractiveTransition()
            } else {
                interactionTransitionController!.cancelInteractiveTransition()
            }
            interactionTransitionController = nil
            
        default:
            return
        }
    }
```

Interaction transition has 3 parts:
* Init `interactionTransitionController` and either pop or push navigation controller when gesture (interaction) starts.
* Calculate your `percent`s on gesture change and `updateInteractiveTransition:` with that percent
* When gesture ended, decide if your transition complete or not and give information to your `interactionTransitionController` with `finishInteractiveTransition ()` and `cancelInteractiveTransition ()`


### Easier `TransitionManager` setup

You can create a `TransitionManagerAnimation` container enum and give it all your animations

``` swift
	enum TransitionManagerAnimations {
	    case Fade
	    case Left
	}
```

Write a func that returns correct transition animation in enum

``` swift
	enum TransitionManagerAnimations {
	    case Fade
	    case Left (UINavigationController)
	    
	    func transitionAnimation () -> TransitionManagerAnimation {
	        switch self {
	        case .Fade:
	            return FadeTransitionAnimation()
	            
	        case .Left (let nav):
	            return LeftTransitionAnimation(navigationController: nav)
	            
	        default:
	            return TransitionManagerAnimation()
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
