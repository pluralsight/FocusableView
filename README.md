# FocusableView

`FocusableView.swift` is a subclass of `UIView` that can be used to mimic Apple's focus styling on tvOS.

`FocusableView` is configurable, allowing you to tweak the types of interactions that a user can have with your view. Simply set `FocusableView`'s properties to what you'd like and add a subview.

The following properties are what provide the configurability:
- `focusedBackgroundStyle`: A `FocusableViewBackgroundStyle` enum value that will change the background style of the view when focused. `.None` will cause no change in behavior. `.Blur(UIBlurEffectStyle)` adds a blur view behind your subview when focused. `.Color(UIColor)` adds a view with a background color behind your subview when focused. The default value is `.None`.
- `focusStyle`: A `FocusableViewFocusStyle` enum value that can cause your view to grow when focused. `.None` causes no changes (no scaling) when focused. `.Grow(scale: CGFloat)` makes your view scale to the provided value when your view becomes focused. The default value is `.None`.
- `wiggle`: A value of type `FocusableViewWiggle` that configures how your view will wiggle when the user pans around on the touchpad of their Siri Remote. You can configure the wiggle style and direction. `.Translation` style will simply shift your view in the provided direction(s). `.PerspectiveRotation` will slightly rotate and shift your view in the provided direction(s). The supported directions are `Vertical` and `Horizontal`. These can also be used in combination. The default value is `nil`.
- `showsShadowOnFocus`: A `Bool` that determines if your view will show a shadow when it's focused. The default value is `false`.
- `enabled`: A `Bool` value that determines if your view can become focused. The default value is `true`.

Addtionally, you can set the `delegate` on the view in order to support selection of your view.
