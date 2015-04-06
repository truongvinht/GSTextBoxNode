GSTextBoxNode
==============

A SpriteKit iOS class to get auto-typing labels inside of a battle box for RPG-Games.

Require: SpriteKit in iOS 7 & GSTextAutoTypeNode

Please use your own "BoxConstants.h" to modify your desired configurations
#Example

Typing:
```Objective-C
GSTextBoxNode *box = [[GSTextBoxNode alloc] initWithFontName:@"Arial"];
box.delegate = self;
box.isAutoContinue = YES;
[self addChild:box];
[box typeText:@"OMG, the class is awesome!" withDelay:0.1f withHide:NO];
```
Battle Mode with 4 buttons:
```Objective-C
GSTextBoxNode *box = [[GSTextBoxNode alloc] initWithFontName:@"Arial"];
box.delegate = self;
box.isAutoContinue = YES;
[self addChild:box];
[box initButtonLabelsForTopLeft:@"Fight" andTopRight:@"Items" andBottomLeft:@"Switch" andBottomRight:@"Escape"];
[box setBoxMode:TextBoxLayoutBattle];
```

To handle touch events in battle mode you need to implement the protocol TextBoxLayerDelegate and add
```Objective-C
- (void)buttonWithLabel:(TextBoxButton)button{
    //any button pressed
}
```

Hint: If you can't interact with the box, then you need to implement the following lines
```Objective-C
- (void)didMoveToView:(SKView *)view{
    // textbox is the GSTextBoxNode 
    [textBox activateTouchEventsInView:view];
}
```

#License
MIT License (MIT)
