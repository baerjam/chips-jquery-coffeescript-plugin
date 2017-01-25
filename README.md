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

## Rails Integration
Integrated with Rails using a Taggable concern that can me mixed into any model

### Concern
```ruby
module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings
  end

  module ClassMethods
    def tagged_with(*tags)
      joins(:tags).where(tags.map { |tag| "tags.name = '#{tag.strip}'" }.join(' or '))
    end
  end

  def tag_names
    tags.map(&:name)
  end

  # Sets full tag list for object with comma seperated tag list
  # Example:
  #  Subject.tag_names  #=> ["tag1", "tag2"]
  #
  #  Subject.tag_names = "tag1, tag2, tag3"
  #  Subject.tag_names  #=> ["tag3", "tag2", "tag3"]
  def tag_names=(tags)
    self.tags = tags.split(',').map do |tag|
      Tag.find_or_create_by(name: tag.strip)
    end
  end
end
```

### Models
```ruby
class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy

  validates :name, presence: true

  after_validation :normalize_name

  private

  def normalize_name
    self.name = name.downcase
  end
end

class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :taggable, polymorphic: true

  validates :taggable, presence: true
  validates :tag,      presence: true
end
```




