#
#  Be sure to run `pod spec lint TransitionManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "TransitionManager"
  s.version      = "0.3"
  s.summary      = "Painless custom transitioning. Easy extend, easy setup, just focus on animations."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
  TransitionManager
=================

Painless custom transitioning. Easy extend, easy setup, just focus on animations.


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

One important part is `completion()` must be called because the `TransitionManager` finishes transition after it gets called.


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
                   DESC

  s.homepage     = "https://github.com/cemolcay/TransitionManager"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "cemolcay" => "ccemolcay@gmail.com" }
  # Or just: s.author    = "cemolcay"
  # s.authors            = { "cemolcay" => "ccemolcay@gmail.com" }
  s.social_media_url   = "http://twitter.com/cemolcay"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  s.platform     = :ios
  s.platform     = :ios, "8.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

s.source       = { :git => "https://github.com/cemolcay/TransitionManager.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "TransitionManager/Source/*.swift"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
