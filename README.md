# chips-jquery-coffeescript-plugin

A jQuery plugin in CoffeeScript to add tagging/chips to a page

[Demo](http://jamesfbaer.com/chips-demo)

## Features
- Add/Remove tags
- Save on enter keypress
- Duplicate tag detecttion
- Multiple taggable items per page

### HTML

```html
<div class="chips" id="chips1">
  <h3>Item 1</h3>
  <div class="chip">
    <span class="chip-name">Tag1</span>
    <button type="button" class="close" aria-label="Close"><span>&times;</span></button>
  </div>
  <div class="chip">
    <span class="chip-name">Tag2</span>
    <button type="button" class="close" aria-label="Close"><span>&times;</span></button>
  </div>
</div>
```

### jQuery

Use the plugin as follows:

```js
$('.chips').chips();
```
